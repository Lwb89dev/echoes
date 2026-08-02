/// A Nostr account's public profile card (NIP-01 kind 0 "set_metadata").
///
/// Unlike everything else in this app, this is **not** encrypted: kind 0 is
/// a plain, public Nostr event by design — the same profile card any other
/// Nostr client reads. Echoes only ever fetches its own logged-in user's
/// profile (to show a friendlier name/avatar in Settings instead of a raw
/// npub), never anyone else's.
class NostrProfile {
  final String publicKeyHex;
  final String? name;
  final String? displayName;
  final String? picture;
  final String? about;

  const NostrProfile({
    required this.publicKeyHex,
    this.name,
    this.displayName,
    this.picture,
    this.about,
  });

  /// The best available human-readable label, preferring `display_name`
  /// (meant to be the user's chosen "pretty" name) over `name` (the
  /// NIP-05-adjacent handle). Null if neither is set, so callers can fall
  /// back to a truncated npub.
  ///
  /// Sanitized before display: a profile's name is attacker-chosen text
  /// that ends up right next to trust decisions (the share-confirmation
  /// dialog identifies the recipient by it), so invisible/bidi-control
  /// characters are stripped — they enable spoofing tricks like RLO-
  /// reversing or zero-width padding a lookalike name — and the length is
  /// capped so a boundless "name" can't crowd the real npub out of the
  /// dialog. Display-only: the raw fields stay untouched on the model.
  String? get label {
    final display = _sanitizeForDisplay(displayName);
    if (display != null) return display;
    return _sanitizeForDisplay(name);
  }

  /// Strips C0/C1 controls plus the invisible formatting range —
  /// zero-width chars, bidi embedding/override/isolate marks, BOM — and
  /// collapses runs of whitespace, then caps at [maxChars]. Null when
  /// nothing visible is left.
  static String? _sanitizeForDisplay(String? raw, {int maxChars = 48}) {
    if (raw == null) return null;
    final cleaned = raw
        .replaceAll(
          RegExp(r'[\u0000-\u001F\u007F-\u009F\u200B-\u200F\u2028-\u202E\u2060-\u206F\uFEFF]'),
          '',
        )
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (cleaned.isEmpty) return null;
    if (cleaned.length <= maxChars) return cleaned;
    return '${cleaned.substring(0, maxChars)}…';
  }

  /// Parses a kind-0 event's `content` (already JSON-decoded) into a
  /// profile. Every field is optional per spec, so nothing here throws for
  /// a sparse or unfamiliar profile — an empty/malformed field is simply
  /// treated as absent rather than failing the whole fetch.
  factory NostrProfile.fromMetadataJson(String publicKeyHex, Map<String, dynamic> json) {
    return NostrProfile(
      publicKeyHex: publicKeyHex,
      name: json['name'] as String?,
      displayName: json['display_name'] as String?,
      picture: json['picture'] as String?,
      about: json['about'] as String?,
    );
  }

  /// Serialized for the small local cache in SharedPreferences (see
  /// [ProfileNotifier]) — not related to the Nostr wire format.
  Map<String, dynamic> toJson() => {
    'publicKeyHex': publicKeyHex,
    'name': name,
    'displayName': displayName,
    'picture': picture,
    'about': about,
  };

  factory NostrProfile.fromJson(Map<String, dynamic> json) {
    return NostrProfile(
      publicKeyHex: json['publicKeyHex'] as String,
      name: json['name'] as String?,
      displayName: json['displayName'] as String?,
      picture: json['picture'] as String?,
      about: json['about'] as String?,
    );
  }
}
