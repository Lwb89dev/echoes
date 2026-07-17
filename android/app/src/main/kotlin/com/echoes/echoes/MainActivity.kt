package com.echoes.echoes

import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // PRIVACY — blank only the recents/app-switcher thumbnail, on API 31+
        // (Android 12). Without this, minimizing the app leaves a live
        // screenshot of whatever note was on screen sitting in the task
        // switcher — a fully involuntary content leak. Deliberately NOT
        // FLAG_SECURE: that would also block manual screenshots, and being
        // able to screenshot a note (e.g. to share it) is worth keeping —
        // this only closes the involuntary leak, not deliberate ones.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            setRecentsScreenshotEnabled(false)
        }
    }
}
