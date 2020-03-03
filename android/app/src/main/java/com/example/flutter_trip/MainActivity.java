package com.example.flutter_trip;

import androidx.annotation.NonNull;

import org.devio.flutter.splashscreen.SplashScreen;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    SplashScreen.show(this, true);
    GeneratedPluginRegistrant.registerWith(flutterEngine);
  }
}
