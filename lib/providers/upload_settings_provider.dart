import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/upload_provider.dart';
import '../utils/constants.dart';

/// The upload provider (file host) attachments get encrypted-and-uploaded
/// to, persisted across launches. Defaults to [blossomHzrd149Provider] —
/// see [builtInUploadProviders] for why it (and its fellow built-in) were
/// picked specifically: both are Blossom hosts confirmed to store an
/// upload's opaque bytes as-is rather than rejecting anything that fails
/// to decode as a real image, which every attachment this app uploads is.
class UploadProviderNotifier extends Notifier<UploadProviderOption> {
  @override
  UploadProviderOption build() {
    _load();
    return blossomHzrd149Provider;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.prefsUploadProviderKey);
    if (raw == null) return;
    try {
      state = UploadProviderOption.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Corrupted/outdated preference value: keep the default rather than
      // failing Settings over a non-critical, easily-reset choice.
    }
  }

  Future<void> setProvider(UploadProviderOption provider) async {
    state = provider;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefsUploadProviderKey, jsonEncode(provider.toJson()));
  }
}

final uploadProviderProvider = NotifierProvider<UploadProviderNotifier, UploadProviderOption>(
  UploadProviderNotifier.new,
);
