import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import 'service_providers.dart';

/// Global authentication state: `null` = no local Nostr account, so
/// [LoginScreen]; otherwise the user is "logged in" with that identity.
///
/// `build()` runs at app startup and is the "is there already a saved
/// Nostr account?" check from the app's requirements: it reads the
/// persisted [LoginMethod] and rebuilds the session accordingly — via
/// Amber (pubkey only, no private key involved) or via a local private
/// key. If there is no saved session, it stays `null` and the UI shows the
/// login screen. Echoes never creates new accounts: the user either
/// imports an existing private key or delegates to Amber.
class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    developer.log('AuthNotifier.build called (checking for a local Nostr account)', name: 'AuthNotifier');

    final localStorageService = ref.read(localStorageServiceProvider);
    final publicKeyHex = await localStorageService.loadPublicKey();
    if (publicKeyHex == null) return null;

    final nostrService = ref.read(nostrServiceProvider);
    final loginMethod = await localStorageService.loadLoginMethod() ?? LoginMethod.privateKey;

    if (loginMethod == LoginMethod.amber) {
      return User(
        publicKeyHex: publicKeyHex,
        npub: nostrService.publicKeyToNpub(publicKeyHex),
        loginMethod: LoginMethod.amber,
      );
    }

    final privateKeyHex = await localStorageService.loadPrivateKey();
    if (privateKeyHex == null) return null; // Inconsistent state: treat as logged out.
    return nostrService.login(privateKeyHex);
  }

  /// Imports an existing Nostr account from a private key (hex or nsec).
  Future<void> importAccount(String privateKey) async {
    developer.log('AuthNotifier.importAccount called', name: 'AuthNotifier');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final nostrService = ref.read(nostrServiceProvider);
      final localStorageService = ref.read(localStorageServiceProvider);

      // Decoding runs inside its own guard so a malformed key can never
      // leak: bech32/bip340/BigInt.parse all throw exceptions that embed
      // the raw input string, and that exception object would otherwise
      // end up both in this provider's retained error state and rendered
      // on screen by the login form. Collapse any decode failure into a
      // fixed, key-free marker exception instead — the caller shows a
      // generic "invalid key" message for it.
      final User user;
      try {
        user = await nostrService.importAccount(privateKey);
      } catch (_) {
        throw const InvalidPrivateKeyException();
      }

      if (user.privateKeyHex != null) {
        await localStorageService.savePrivateKey(user.privateKeyHex!);
      }
      await localStorageService.savePublicKey(user.publicKeyHex);
      await localStorageService.saveLoginMethod(user.loginMethod);
      return user;
    });
  }

  /// Login delegated to Amber (NIP-55 external signer): the private key is
  /// never imported into the app, it stays inside Amber.
  Future<void> loginWithAmber() async {
    developer.log('AuthNotifier.loginWithAmber called', name: 'AuthNotifier');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final nostrService = ref.read(nostrServiceProvider);
      final localStorageService = ref.read(localStorageServiceProvider);
      final user = await nostrService.loginWithAmber();
      await localStorageService.savePublicKey(user.publicKeyHex);
      await localStorageService.saveLoginMethod(user.loginMethod);
      return user;
    });
  }

  /// Clears the local Nostr account and brings the state back to "logged out".
  Future<void> logout() async {
    developer.log('AuthNotifier.logout called', name: 'AuthNotifier');
    final localStorageService = ref.read(localStorageServiceProvider);
    await localStorageService.clearSession();
    state = const AsyncData(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(AuthNotifier.new);

/// Thrown by [AuthNotifier.importAccount] when the entered private key can't
/// be decoded. Deliberately carries *no* detail — in particular never the
/// key the user typed — because it can surface in on-screen error text; the
/// login form maps it to a generic localized message. See the security
/// rationale in [AuthNotifier.importAccount].
class InvalidPrivateKeyException implements Exception {
  const InvalidPrivateKeyException();

  @override
  String toString() => 'Invalid private key';
}
