import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/services.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:VeggieBuddie/loginPage.dart';
import 'package:VeggieBuddie/ProfilePage.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/services.dart' show DeviceOrientation, rootBundle;

Future test() async{
  final databaseReference = FirebaseDatabase.instance.reference();
  databaseReference.once().then((DataSnapshot snapshot) {
      values=Map<String,bool>.from(snapshot.value[name]['food']);
    });
}

List<CameraDescription> cameras;

Future<List<String>> getFileData(String path) async {
  var readLines = await rootBundle.loadString(path);
  return readLines.split("\n");
}

class FlutterVisionHome extends StatefulWidget {
  @override
  _FlutterVisionHomeState createState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIOverlays([]);
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
    test();
    print(values);
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
          child:Column(children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height-172),
          FloatingActionButton(
          child: Icon(Icons.camera_alt,color: Colors.black,),
          backgroundColor: Colors.white,
          onPressed: controller != null &&
                  controller.value.isInitialized 
              ? onTakePictureButtonPressed
              : null,
        ),
        ]
          )
        ),
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
    String text="";
    int nvFlag=0;
    int veganFlag = 0;
    int vegFlag = 0;
    int alleFlag=0;
    String newStr;
    String t="Safe to eat for you!";
    var nonVeg=await getFileData("lists/non-veg.txt");
    var vegan = await getFileData("lists/vegan.txt");
    var vegetarian = await getFileData("lists/vegetarian.txt");

    var allergies=["test"];
    if(values["Soybeans"]==true)
    allergies=(await getFileData("lists/allergens/soy.txt"));
    if(values["Crustacean shellfish"]==true)
    allergies=[...allergies, ...(await getFileData("lists/allergens/shellfish.txt"))];
    if(values["Peanuts"]==true)
    allergies=[...allergies, ...(await getFileData("lists/allergens/peanuts.txt"))];
    if(values["Tree nuts"]==true)
    allergies=[...allergies, ...(await getFileData("lists/allergens/treenuts.txt"))];
    if(values["Fish"]==true)
    allergies=[...allergies, ...(await getFileData("lists/allergens/fish.txt"))];
    if(values["Wheat"]==true)
    allergies=[...allergies, ...(await getFileData("lists/allergens/wheat.txt"))];
    if(values["Eggs"]==true)
    allergies=[...allergies, ...(await getFileData("lists/allergens/eggs.txt"))];
    if(values["Milk"]==true)
    allergies=[...allergies, ...(await getFileData("lists/allergens/shellfish.txt"))];

    for (TextBlock block in visionText.blocks)
      for (TextLine line in block.lines){
        for (TextElement element in line.elements){
          for(String nonv in nonVeg){
                  newStr = element.text.replaceAll(",", "").toLowerCase();
                  if(newStr==nonv){
                    print(nonv);
                        nvFlag=1;
                        break;
                    }
          }
          for(String veg in vegetarian) {
                  newStr = element.text.replaceAll(",", "").toLowerCase();
                  if(newStr == veg) {
                    vegFlag = 1;
                    break;
                  }
          }
          for(String vega in vegan) {
                  newStr = element.text.replaceAll(",", "").toLowerCase();
                  if(newStr == vega)  {
                    veganFlag = 1;
                    break;
                  }
          }
          for(String alle in allergies) {
                  newStr = element.text.replaceAll(",", "").toLowerCase();
                  if(newStr == alle)  {
                    alleFlag = 1;
                    break;
                  }
          }
          text=text+newStr+" ";
        }
      text=text+"\n";
      }
    String status = "The ingredients could not be detected!";
      String filegif = "gifs/notfound.gif";
    if (nvFlag==1) {
      status="The product is Non-Vegetarian!";
      filegif = "gifs/nonveg.gif";
    }
    else if(vegFlag == 1){
      status = "The product is Vegetarian!";
      filegif = "gifs/vegetarians.gif"; }
    else if(veganFlag == 1){
      status = "The product is Vegan!";
      filegif = "gifs/veganPower.gif";}

      if(alleFlag==1)
      t="You are allergic to this!";

        showDialog(
          context: context,
            builder: (_) => AssetGiffyDialog(
            image: Image.asset(filegif, fit: BoxFit.cover),
            title: new Text(status+"\n\n"+t,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600),
                ),
            onlyCancelButton: true,
            buttonCancelText: Text("Ok", style: TextStyle(fontSize: 18.0,color: Colors.white)),
            buttonCancelColor: Colors.teal[300],
           ));
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