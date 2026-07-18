import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile.dart';
import '../utils/constants.dart';
import 'auth_provider.dart';
import 'relay_provider.dart';
import 'service_providers.dart';

/// The logged-in account's public Nostr profile (display name + avatar),
/// re-fetched whenever [authProvider] resolves to a (possibly new) user.
///
/// Emits the last-cached profile (SharedPreferences) immediately, if any,
/// then replaces it with a freshly-fetched one once the relay round-trip
/// completes — so Settings never shows a blank state on launch just
/// because the network fetch hasn't finished yet. A failed/empty fetch
/// falls back to keeping whatever was cached rather than clearing it: a
/// stale name/avatar is strictly better than none for this decorative,
/// non-critical feature.
class ProfileNotifier extends AsyncNotifier<NostrProfile?> {
  @override
  Future<NostrProfile?> build() async {
    developer.log('ProfileNotifier.build called', name: 'ProfileNotifier');
    final author = ref.watch(authProvider).value;
    if (author == null) return null;

    final cached = await _loadCached(author.publicKeyHex);
    if (cached != null) state = AsyncData(cached);

    NostrProfile? fetched;
    try {
      final relays = ref.read(relayProvider).value ?? const [];
      fetched = await ref.read(nostrServiceProvider).fetchProfileMetadata(
            publicKeyHex: author.publicKeyHex,
            relays: relays,
          );
    } catch (e) {
      developer.log('Could not refresh profile metadata: $e', name: 'ProfileNotifier');
    }
    if (fetched == null) return cached;

    await _saveCached(fetched);
    return fetched;
  }

  Future<NostrProfile?> _loadCached(String publicKeyHex) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.prefsProfileCacheKey);
    if (raw == null) return null;
    try {
      final profile = NostrProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      // Guards against showing a previous account's cached name/avatar
      // right after switching to a different Nostr account.
      return profile.publicKeyHex == publicKeyHex ? profile : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveCached(NostrProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefsProfileCacheKey, jsonEncode(profile.toJson()));
  }
}

final profileProvider = AsyncNotifierProvider<ProfileNotifier, NostrProfile?>(ProfileNotifier.new);

/// Best-effort public profile for an arbitrary pubkey — unlike [profileProvider]
/// (scoped to the logged-in account, disk-cached), this is for showing a
/// human name/avatar in place of a bare npub wherever the UI references
/// *another* Nostr user (e.g. share-sheet recipients). No disk cache, and
/// `autoDispose` so entries live only while something on screen is showing
/// them: without it, every pubkey ever previewed would pin a cache entry
/// (and its fetch result) for the app's whole lifetime.
final peerProfileProvider =
    FutureProvider.autoDispose.family<NostrProfile?, String>((ref, publicKeyHex) async {
  final relays = ref.watch(relayProvider).value ?? const [];
  try {
    return await ref.watch(nostrServiceProvider).fetchProfileMetadata(
          publicKeyHex: publicKeyHex,
          relays: relays,
        );
  } catch (e) {
    developer.log('Could not fetch peer profile for $publicKeyHex: $e', name: 'peerProfileProvider');
    return null;
  }
});

/// The logged-in account's NIP-02 contacts ("following" list), each
/// resolved to its best-effort public profile — powers the share sheet's
/// local recipient autocomplete (`ShareNoteSheet._matchingContacts`):
/// filtering entirely client-side against people already followed, never a
/// network-wide name search (deliberately rejected — see
/// [AppConstants.contactListEventKind] — since an unverified name match on
/// the whole network is an impersonation risk when the wrong recipient
/// means leaking a note). Not disk-cached, and `autoDispose`: the list
/// stays alive while a share sheet is watching it and is dropped when the
/// sheet closes, so the next open re-fetches a fresh follow list instead
/// of serving one cached since app launch.
final contactsProvider = FutureProvider.autoDispose<List<NostrProfile>>((ref) async {
  final me = ref.watch(authProvider).value;
  if (me == null) return const [];
  final service = ref.watch(nostrServiceProvider);
  final relays = ref.watch(relayProvider).value ?? const [];
  try {
    final pubkeys = await service.fetchContactPubkeys(publicKeyHex: me.publicKeyHex, relays: relays);
    if (pubkeys.isEmpty) return const [];
    return await service.fetchProfilesBatch(publicKeyHexes: pubkeys, relays: relays);
  } catch (e) {
    developer.log('Could not fetch contacts: $e', name: 'contactsProvider');
    return const [];
  }
});

/// Downloads and disk-caches the avatar at [url] (a profile's public
/// `picture` field — not encrypted, this is the same image any other
/// Nostr client would display), keyed by the URL's sha256 so re-fetching
/// the same profile never re-downloads it. Returns null on any failure
/// (missing image, network error, non-200 response): [_AccountSection]
/// falls back to a plain icon in that case, same as "no avatar set".
final avatarFileProvider = FutureProvider.family<File?, String>((ref, url) async {
  // The `picture` field is unvalidated data off a relay. Refusing non-HTTPS
  // here matters doubly since the app's Android network config permits
  // cleartext app-wide (for user-configured `ws://` LAN relays — see
  // network_security_config.xml): without this check, that OS-level
  // allowance would silently extend to plain-HTTP avatar fetches too.
  // Same policy as attachments (`AttachmentUploadService._requireHttps`),
  // just non-throwing — no avatar is a fine outcome, it's decorative.
  if (!url.startsWith('https://')) return null;

  final cacheService = ref.watch(fileCacheServiceProvider);
  final key = sha256.convert(utf8.encode(url)).toString();

  final cached = await cacheService.get(key);
  if (cached != null) return cached;

  // Streamed download with a hard size cap, instead of `http.get`: that
  // buffers however much the server decides to send, so a hostile profile
  // could point `picture` at a multi-gigabyte URL and turn a decorative
  // avatar fetch into a memory DoS. Past the cap the stream is abandoned
  // mid-flight and nothing is cached.
  const maxAvatarBytes = 8 * 1024 * 1024;
  const maxRedirects = 5;
  final client = http.Client();
  try {
    // Redirects are followed manually and https-only, for the same reason
    // the initial URL is: the default client would silently follow a
    // downgrade redirect onto plain http.
    var current = Uri.parse(url);
    for (var hop = 0; hop <= maxRedirects; hop++) {
      final request = http.Request('GET', current)..followRedirects = false;
      final response = await client.send(request).timeout(const Duration(seconds: 15));
      if (const {301, 302, 303, 307, 308}.contains(response.statusCode)) {
        final location = response.headers['location'];
        if (location == null) return null;
        final target = current.resolve(location);
        if (target.scheme != 'https') return null;
        current = target;
        continue;
      }
      if (response.statusCode != 200) return null;
      final bytes = BytesBuilder(copy: false);
      await for (final chunk in response.stream.timeout(const Duration(seconds: 15))) {
        bytes.add(chunk);
        if (bytes.length > maxAvatarBytes) {
          developer.log('Avatar at $url exceeds $maxAvatarBytes bytes — dropped', name: 'avatarFileProvider');
          return null;
        }
      }
      return await cacheService.put(key, bytes.takeBytes());
    }
    return null;
  } catch (e) {
    developer.log('Could not download avatar from $url: $e', name: 'avatarFileProvider');
    return null;
  } finally {
    client.close();
  }
});
