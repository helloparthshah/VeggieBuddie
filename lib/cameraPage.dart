import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/services.dart';

import 'package:flutter/services.dart' show rootBundle;

List<CameraDescription> cameras;

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

class FlutterVisionHome extends StatefulWidget {
  @override
  _FlutterVisionHomeState createState() {
    return _FlutterVisionHomeState();
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _FlutterVisionHomeState extends State<FlutterVisionHome> {
  CameraController controller;
  String imagePath;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      body: Container(
            child: Container(
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
            ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Container(
        /* height: MediaQuery.of(context).size.height,  */
        /* width: MediaQuery.of(context).size.width/controller.value.aspectRatio, */
      child:AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Container(
          child: Stack(
            children: <Widget>[
              CameraPreview(controller),
        Align(
          alignment: Alignment.bottomCenter,
          child:FloatingActionButton(
          child: Icon(Icons.camera_alt,color: Colors.black,),
          backgroundColor: Colors.white,
          onPressed: controller != null &&
                  controller.value.isInitialized 
              ? onTakePictureButtonPressed
              : null,
        )
        )
            ]
          )
          )
      )
      );
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        if (filePath != null) {
          showInSnackBar('Picture saved to $filePath');

          detectLabels().then((_) { 

          });
        } 
      }
    });
  }

  Future<void> detectLabels() async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFilePath(imagePath);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);
    /* String text = visionText.text; */
    String text="";
    int flag=0;
    String newStr;
    var nv={"lard","pork"};
    var nonVeg=await getFileData("lists/non-veg.txt");
    print(type(nonVeg));
    for (TextBlock block in visionText.blocks) 
    for (TextLine line in block.lines){
    for (TextElement element in line.elements){
      for(String nonv in nv){
        newStr = element.text.replaceAll(",", "").toLowerCase();
      if(newStr==nonv){
        flag=1;
        break;
      }
      }
      text=text+newStr+" ";
      }
      text=text+"\n";
    }
    String status="The product is Vegetarian!";
    if (flag==1)
    status="The product is Non-Vegetarian!";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(status),
          content: new SingleChildScrollView(child: SelectableText(text)),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    /* _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text))); */
    textRecognizer.close();
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/Foodie';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

class FlutterVisionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlutterVisionHome(),
    );
  }
}