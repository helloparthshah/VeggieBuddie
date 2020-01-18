import 'dart:async';

import 'package:flutter/material.dart';
import 'package:VeggieBuddie/loginPage.dart';
import 'package:camera/camera.dart';
import 'package:VeggieBuddie/cameraPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(LoginPage());
}