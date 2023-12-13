
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
  const ImageViewPage({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  Interpreter? _interpreter;
  bool _isModelReady = false;
  String _result = '';
  
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
      // Process and print the outputs
      print(outputs);
      
    } catch (err) {
      print(err.toString());
    }
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
                        File(widget.imagePath),
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
      final resizedBytes = img.encodeJpg(resizedImage); // Change to encodePng if needed

      final directory = await getApplicationDocumentsDirectory();

      final resizedFilePath = '${directory.path}/resized_image.png'; // Change file extension if needed

      final resizedImageFile = File(resizedFilePath);
      await resizedImageFile.writeAsBytes(resizedBytes);
      return resizedFilePath;

    }
    return "";
  }
  void nextPage(){
    Navigator.push(
        context,
        SlidePageRoute(
            page: ResultsPage(
              imagePath: widget.imagePath,
              prediction: prediction,
            )));

  }
}
