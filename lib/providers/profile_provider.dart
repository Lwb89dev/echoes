import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

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

/// Downloads and disk-caches the avatar at [url] (a profile's public
/// `picture` field — not encrypted, this is the same image any other
/// Nostr client would display), keyed by the URL's sha256 so re-fetching
/// the same profile never re-downloads it. Returns null on any failure
/// (missing image, network error, non-200 response): [_AccountSection]
/// falls back to a plain icon in that case, same as "no avatar set".
final avatarFileProvider = FutureProvider.family<File?, String>((ref, url) async {
  final cacheService = ref.watch(fileCacheServiceProvider);
  final key = sha256.convert(utf8.encode(url)).toString();

  final cached = await cacheService.get(key);
  if (cached != null) return cached;

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return null;
    return await cacheService.put(key, response.bodyBytes);
  } catch (e) {
    developer.log('Could not download avatar from $url: $e', name: 'avatarFileProvider');
    return null;
  }
});
