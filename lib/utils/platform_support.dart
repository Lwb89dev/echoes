import 'dart:io';

/// Central home for "does this platform support X" checks, so the reasoning
/// behind each one lives in a single place instead of being re-derived (or
/// silently forgotten) at every call site.
class PlatformSupport {
  PlatformSupport._();

  /// Amber (NIP-55 signer) is a separate Android app that Echoes talks to
  /// via an Android intent — there is no equivalent on any other platform,
  /// and `amberflutter` only registers a native implementation for Android.
  /// [NostrService.isAmberInstalled] already degrades gracefully if this is
  /// ignored (it catches `MissingPluginException`), but hiding the button
  /// entirely on desktop/iOS is the honest UI: that login method simply
  /// doesn't exist there, it's not just "not installed".
  static bool get supportsAmber => Platform.isAndroid;

  /// Voice note *playback* (and the waveform drawn over it) goes through
  /// `audio_waveforms`, which only ships a native implementation for
  /// Android/iOS — there's no Linux/Windows backend to call into. Recording
  /// itself (`record` package) does have desktop backends, but a take that
  /// can never be played back on the device that made it isn't worth
  /// exposing: better to not offer voice notes at all on unsupported
  /// platforms than to offer a feature that immediately dead-ends.
  ///
  /// This also sidesteps a second, separate Linux-only gap: `record`'s
  /// Linux backend doesn't capture audio itself, it shells out to the
  /// `parecord`/`ffmpeg` binaries on the host `PATH` — which don't exist
  /// inside the Flatpak sandbox unless bundled as their own modules (see
  /// `flatpak/org.echoes.echoes.json`). Since this flag already keeps
  /// [VoiceRecorder] from ever being reachable there, that gap is moot
  /// rather than something the Flatpak packaging needs to solve.
  static bool get supportsVoiceNotes => Platform.isAndroid || Platform.isIOS;
}
