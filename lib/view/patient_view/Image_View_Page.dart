import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:lottie/lottie.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';
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

  var min_conf_threshold = 0.5;

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
      _interpreter = await Interpreter.fromAsset('assets/models/detect_quant.tflite');


    } catch (e) {
      print('Failed to load model.');

    }
  }

  img.Image drawDetectionBox(
      img.Image image, double yMin, double xMin, double yMax, double xMax) {
    int imageWidth = image.width;
    int imageHeight = image.height;

    // Convert normalized coordinates to image coordinates
    int left = (xMin * imageWidth).toInt();
    int top = (yMin * imageHeight).toInt();
    int right = (xMax * imageWidth).toInt();
    int bottom = (yMax * imageHeight).toInt();

    // Draw detection box on the image
    image = img.drawLine(image, left, top, right, top, img.getColor(255, 0, 0));
    image =
        img.drawLine(image, right, top, right, bottom, img.getColor(255, 0, 0));
    image = img.drawLine(
        image, right, bottom, left, bottom, img.getColor(255, 0, 0));
    image =
        img.drawLine(image, left, bottom, left, top, img.getColor(255, 0, 0));
    return image;
  }

  Future<String> runInference(File imageFile) async {
    // Load the image using the image package
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

    // Resize the image to match the model's input dimensions (320x320)
    image = img.copyResizeCropSquare(image!, image.width);
    image = img.copyResize(image, width: 320, height: 320);

    var tensorImage = TensorImage.fromImage(image);

    var output1 = List.filled(10, 0.0).reshape([1, 10]);
    var output2 =
        List.generate(1, (i) => List.generate(10, (j) => List.filled(4, 0.0)))
            .reshape([1, 10, 4]);
    var output3 = List.filled(1, 0.0);
    var output4 = List.filled(10, 0.0).reshape([1, 10]);
    var outputs = {0: output1, 1: output2, 2: output3, 3: output4};

    // Run inference with the TensorFlow Lite model using the Interpreter
    try {
      // Run the model
      _interpreter!.runForMultipleInputs([tensorImage.buffer], outputs);

      // Loop over all detections and draw detection box if confidence is above the minimum threshold

      for (int i = 0; i < outputs[1]?[0].length; i++) {
        double score = outputs[0]?[0][i];
        if (score > min_conf_threshold && score <= 1.0) {
          double yMin = outputs[1]?[0][i][0];
          double xMin = outputs[1]?[0][i][1];
          double yMax = outputs[1]?[0][i][2];
          double xMax = outputs[1]?[0][i][3];

          // Draw detection box

          image = drawDetectionBox(image!, yMin, xMin, yMax, xMax);
        }
      }

      // Save the modified image to the old image path
      final modifiedBytes = img.encodePng(image!);
      final updatedImagePath =
          widget.imagePath.replaceAll('.jpg', 'modified.png');
      await File(updatedImagePath).writeAsBytes(modifiedBytes);


      return updatedImagePath;

      // Print each output tensor
    } catch (err) {

      return "";
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


                    final updatedImagePath = await runInference(File(widget.imagePath));
                    nextPage(updatedImagePath);

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

  Future<String> _resizeImage(String path) async {

    final originalBytes = await File(path).readAsBytes();
    final originalImage = img.decodeImage(Uint8List.fromList(originalBytes));

    if (originalImage != null) {
      Size size = ImageSizeGetter.getSize(FileInput(File(path)));
      int start = (size.height - size.width) ~/ 2;
      image = img.copyCrop(originalImage, 0, start, size.width, size.height);

      final resizedImage =
          img.copyResize(originalImage, width: 320, height: 320);
      final resizedBytes = img.encodePng(resizedImage);

      final originalDirectory = File(path).parent.path;
      final resizedFilePath = '$originalDirectory/resized_image.png';

      final resizedImageFile = File(resizedFilePath);
      await resizedImageFile.writeAsBytes(resizedBytes);
      return path;
    }
    return "";
  }

  void nextPage(String path) async {
    // Resize the image before passing it to the ResultsPage
    String resizedImagePath = await _resizeImage(path);
    if (!context.mounted) return;
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
