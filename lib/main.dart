import 'package:camera/camera.dart';
import 'package:fiap/camerascreen.dart';
import 'package:fiap/loading.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  CameraController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_init);
    WidgetsBinding.instance.addObserver(this);
  }

  void _init(_) async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(
        cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
            orElse: () => cameras.first),
        ResolutionPreset.high,
      );
      await _controller.initialize();
    } catch (e) {
      print(e);
    }
    if (mounted) setState(() {});
  }

  void _dispose() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      _dispose();
    } else if (state == AppLifecycleState.resumed) {
      _init(null);
    }
  }

  @override
  void dispose() {
    _dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: _controller != null ? CameraScreen(_controller) : Container());
  }
}
