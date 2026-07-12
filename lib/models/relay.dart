/// A Nostr relay configured by the user (e.g. wss://relay.damus.io).
///
/// Every configured relay is used for both reading and writing — the app
/// has no UI to set them up asymmetrically, so a per-relay read/write split
/// would just be state nothing can ever change away from "both enabled".
class Relay {
  final String url;

  const Relay({required this.url});

  Map<String, dynamic> toJson() => {'url': url};

  factory Relay.fromJson(Map<String, dynamic> json) {
    return Relay(url: json['url'] as String);
  }

  @override
  bool operator ==(Object other) => other is Relay && other.url == url;

  @override
  int get hashCode => url.hashCode;
}

/// Default relays suggested during onboarding and in Settings' relay
/// section.
const List<String> defaultRelayUrls = [
  'wss://relay.damus.io',
  'wss://nos.lol',
  'wss://relay.nostr.band',
];

/// Always queried *in addition to* the user's configured relays when
/// looking up a kind-0 profile (see `NostrService.fetchProfileMetadata`).
///
/// A note-storage relay list has no reason to carry a user's profile
/// metadata — it was very likely published by whatever other Nostr client
/// they use, to that client's own default relays, not Echoes'. These are
/// widely-used, metadata-oriented relays (purplepag.es exists specifically
/// to aggregate kind-0/kind-3/NIP-65 events network-wide) included so
/// Settings can show a name/avatar even when the configured relay set
/// never received the profile event itself. Read-only, public data — no
/// privacy trade-off in querying relays beyond the user's own choices for
/// this one lookup.
const List<String> profileMetadataFallbackRelayUrls = [
  'wss://purplepag.es',
  'wss://relay.damus.io',
  'wss://nos.lol',
];
