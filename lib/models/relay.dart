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
///
/// Deliberately does NOT include relay.nostr.band: unlike a plain storage
/// relay, it's a search/indexing service — subscribing to it with an
/// `authors: [pubkey]` filter (which every fetch here does) hands a
/// network-wide indexer "this pubkey is active right now, from this IP",
/// a presence beacon a note-storage relay has no reason to also be. It's
/// otherwise unremarkable as a relay, so if a user adds it back manually
/// that's an informed choice — it's only excluded from what's *suggested*.
// Four general-purpose, no-auth, write-accepting relays rather than two: one
// relay having a bad day (relay.damus.io in particular has been flaky) then
// only halves the redundancy instead of removing it. All four were probed
// live (open socket + REQ + reply) on 2026-07-20; auth-gated relays
// (nostr.land) and search/indexing relays (relay.nostr.band — a presence
// beacon, see below) are deliberately excluded from the suggested set.
const List<String> defaultRelayUrls = [
  'wss://relay.damus.io',
  'wss://nos.lol',
  'wss://offchain.pub',
  'wss://nostr.mom',
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
