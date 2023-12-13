
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

import 'package:tflite_flutter/tflite_flutter.dart';



import 'package:vieu/controller/custom_route_animation.dart';

import 'ResultsPage.dart';



class ImageViewPage extends StatefulWidget {
   ImageViewPage({super.key, required this.imagePath});

  String imagePath;

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  Interpreter? _interpreter;
  bool _isModelReady = false;
  String _result = '';

  var min_conf_threshold = 0.5;
  String _updatedImagePath = '';
  List<double> scores = [];
  
  
  bool analyze = false;
  String prediction = '';
  late Interpreter interpreter;
  late List<String> labels;
  late img.Image image;
  

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/models/model.tflite');
      setState(() {
        _isModelReady = true;
      });
      print('Model loaded successfully');
    } catch (e) {
      print('Failed to load model.');
      print(e);
    }

  }

  void drawDetectionBox(img.Image image, double yMin, double xMin, double yMax, double xMax) {
    int imageWidth = image.width;
    int imageHeight = image.height;

    // Convert normalized coordinates to image coordinates
    int left = (xMin * imageWidth).toInt();
    int top = (yMin * imageHeight).toInt();
    int right = (xMax * imageWidth).toInt();
    int bottom = (yMax * imageHeight).toInt();

    // Draw detection box on the image
    img.drawLine(image, left, top, right, top, img.getColor(255, 0, 0));
    img.drawLine(image, right, top, right, bottom, img.getColor(255, 0, 0));
    img.drawLine(image, right, bottom, left, bottom, img.getColor(255, 0, 0));
    img.drawLine(image, left, bottom, left, top, img.getColor(255, 0, 0));
  }


  

  Future<void> runInference(File imageFile) async {
    // Load the image using the image package
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

    // Resize the image to match the model's input dimensions (320x320)
    image = img.copyResize(image!, width: 320, height: 320);

    var tensorImage = TensorImage.fromImage(image);

    var output1 = List.filled(10, 0.0).reshape([1, 10]);
    var output2 = List.generate(1, (i) => List.generate(10, (j) => List.filled(4, 0.0))).reshape([1, 10, 4]);
    var output3 = List.filled(1, 0.0);
    var output4 = List.filled(10, 0.0).reshape([1, 10]);
    var outputs = {
      0:output1,
      1:output2,
      2:output3,
      3:output4
    };

    

    // Run inference with the TensorFlow Lite model using the Interpreter
    try {
        // Run the model
      _interpreter!.runForMultipleInputs([tensorImage.buffer], outputs);

      print("Model output :");

    
    // Loop over all detections and draw detection box if confidence is above the minimum threshold
    for (int i = 0; i < outputs[1]?[0].length; i++) {
      double score = outputs[0]?[0][i];
      if (score > min_conf_threshold && score <= 1.0) {
        double yMin = outputs[1]?[0][i][0];
        double xMin = outputs[1]?[0][i][1];
        double yMax = outputs[1]?[0][i][2];
        double xMax = outputs[1]?[0][i][3];

        // Draw detection box
        drawDetectionBox(image, yMin, xMin, yMax, xMax);
      }
    }

    // Save the modified image to the old image path
    final modifiedBytes = img.encodePng(image!);
    final updatedImagePath = widget.imagePath.replaceAll('.png', '_modified.png');
    await File(updatedImagePath).writeAsBytes(modifiedBytes);
    setState(() {
      _updatedImagePath = updatedImagePath;
    });

    displayUpdatedImage();

    // Print each output tensor
    outputs.forEach((key, value) {
      print("Output $key:");
      print(value);
    });
      
      
    } catch (err) {
      print(err.toString());
    }
  }

  void displayUpdatedImage() {
    setState(() {
      // Set the widget's imagePath to the updatedImagePath
      widget.imagePath = _updatedImagePath;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Scan",
          style: GoogleFonts.poppins(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              height: size.height * .4,
              width: size.width * .75,
              child: analyze
                  ? Lottie.asset(
                      'assets/lottie/analyze.json',
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(size.width * .2),
                      child: Image.file(
                        File(_updatedImagePath.isNotEmpty ? _updatedImagePath : widget.imagePath),
                        fit: BoxFit.cover,
                      ))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                  icon: const Icon(
                    Icons.autorenew_rounded,
                    color: Colors.black,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).primaryColorDark,
                            width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * .08,
                        vertical: size.height * .02),
                    backgroundColor: Theme.of(context).backgroundColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: Text(
                    "Retake",
                    style: GoogleFonts.poppins(color: Colors.black),
                  )),
              ElevatedButton.icon(
                  icon: const Icon(Icons.document_scanner_outlined),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 3,
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * .08,
                        vertical: size.height * .02),
                    backgroundColor: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () async {
                    setState(() {
                      analyze = true;
                    });

                    await runInference(File(widget.imagePath));
                   nextPage();
                    setState(() {
                      analyze = false;
                    });
                  },
                  label: Text(
                    "Analyze",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ))
            ],
          ),
        ],
      ),
    );
  }
  Future<String> _resizeImage() async {
  final originalBytes = await File(widget.imagePath).readAsBytes();
  final originalImage = img.decodeImage(Uint8List.fromList(originalBytes));

  if (originalImage != null) {
    final resizedImage = img.copyResize(originalImage, width: 320, height: 320);
    final resizedBytes = img.encodePng(resizedImage);

    final originalDirectory = File(widget.imagePath).parent.path;
    final resizedFilePath = '$originalDirectory/resized_image.png';

    final resizedImageFile = File(resizedFilePath);
    await resizedImageFile.writeAsBytes(resizedBytes);
    return resizedFilePath;
  }
  return "";
}

  void nextPage() async {
  // Resize the image before passing it to the ResultsPage
  String resizedImagePath = await _resizeImage();

  Navigator.push(
    context,
    SlidePageRoute(
      page: ResultsPage(
        imagePath: resizedImagePath,
        prediction: prediction,
      ),
    ),
  );
}

}
