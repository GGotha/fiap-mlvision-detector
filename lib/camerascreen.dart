import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class CameraScreen extends StatefulWidget {
  final CameraController _controller;

  const CameraScreen(this._controller, {Key key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  var text = "";

  final FlutterTts flutterTts = FlutterTts();

  startVoice() async {
    await flutterTts.speak('Aplicativo iniciado');
  }

  void initState() {
    super.initState();

    startVoice();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: widget._controller.value.aspectRatio,
          child: CameraPreview(widget._controller),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: LayoutBuilder(
              builder: (_, v) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: v.maxWidth,
                      width: v.maxWidth,
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        try {
                          setState(() {
                            text = "";
                          });

                          final path = await getTemporaryDirectory();
                          final dir = join(path.path, 'photo.jpg');
                          final dirFile = File(dir);

                          if (await dirFile.exists())
                            await dirFile.delete(recursive: true);
                          await widget._controller.takePicture(dir);

                          final FirebaseVisionImage visionImage =
                              FirebaseVisionImage.fromFile(dirFile);

                          final TextRecognizer textRecognizer =
                              FirebaseVision.instance.textRecognizer();
                          final VisionText visionText =
                              await textRecognizer.processImage(visionImage);

                          for (TextBlock block in visionText.blocks) {
                            for (TextLine line in block.lines) {
                              for (TextElement word in line.elements) {
                                setState(() {
                                  text = ('$text ${word.text}');
                                });
                              }
                            }
                          }

                          await flutterTts.speak(text);
                        } catch (e) {
                          print(e);
                        }
                      },
                      backgroundColor: Colors.black,
                      child: Icon(Icons.camera),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
