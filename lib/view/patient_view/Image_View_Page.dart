import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/src/bindings/tensorflow_lite_bindings_generated.dart';
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
  bool analyze = false;
  String prediction = '';
  late Interpreter interpreter;
  late img.Image image;
  @override
  void initState() {
    super.initState();
    // Load the model and run the prediction when the result screen is initialized.
    loadModel();
  }
  Future<void> loadModel() async {
    final interpreterOptions = InterpreterOptions();
    interpreterOptions.threads = 2;

    interpreter = await Interpreter.fromAsset('assets/models/model.tflite', options: interpreterOptions);

  }

  Future<void> runInference(File imageFile) async {
    // Load the image using the image package
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

    // Resize the image to match the model's input dimensions (320x320)
    image = img.copyResize(image!, width: 320, height: 320);

    // Normalize pixel values to the range [0, 1] and prepare the input data
    Uint8List inputUint8List = Uint8List(320 * 320 * 3);
    int pixelIndex = 0;
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        double r = (pixel & 0xFF) / 255.0;
        double g = ((pixel >> 8) & 0xFF) / 255.0;
        double b = ((pixel >> 16) & 0xFF) / 255.0;
        inputUint8List[pixelIndex++] = (r * 255).toInt();
        inputUint8List[pixelIndex++] = (g * 255).toInt();
        inputUint8List[pixelIndex++] = (b * 255).toInt();
      }
    }

    // Run inference with the TensorFlow Lite model using the Interpreter
    try {
      // Create input and output buffers
      final inputBuffer = inputUint8List.buffer.asUint8List();

      // Determine the number of output tensors
      final outputTensorCount = interpreter.getOutputTensors().length;


      // Create output buffers for all output tensors
      List<Float32List> outputBuffers = [];
      for (int i = 0; i < outputTensorCount; i++) {
        final outputTensorShape = interpreter!.getOutputTensor(i).shape;
        outputBuffers.add(Float32List(outputTensorShape.reduce((a, b) => a * b)));
      }

      // Run inference
      interpreter!.run(inputBuffer, outputBuffers);

      // Process the model's output to get predictions
      log(outputBuffers.toString());
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
