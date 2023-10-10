import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vieu/controller/custom_route_animation.dart';
import 'package:vieu/controller/database_controllers/database_controller.dart';
import 'package:vieu/controller/file_services.dart';
import 'package:vieu/view/doctor_view/View_Request.dart';

class MarkFindingsPage extends StatefulWidget {
   MarkFindingsPage(
      {super.key,
      required this.data});

   Map<String,dynamic> data;

  @override
  State<MarkFindingsPage> createState() => _MarkFindingsPageState();
}

class _MarkFindingsPageState extends State<MarkFindingsPage> {
  final _imageKey = GlobalKey<ImagePainterState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
            "Mark Findings",
            style: GoogleFonts.poppins(color: Colors.black),
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImagePainter.file(
                File(widget.data['imagePath']),
                controlsBackgroundColor: Theme.of(context).backgroundColor,
                initialStrokeWidth: 2,
                undoIcon: const Icon(Icons.undo_rounded),
                clearAllIcon: const Icon(Icons.clear_rounded),
                initialPaintMode: PaintMode.freeStyle,
                key: _imageKey,
                optionColor: Colors.black,
                width: size.width,
                height: size.height * .7,
                brushIcon: const Icon(Icons.brush_outlined),
                scalable: true,
              ),
              SizedBox(
                height: size.height * .05,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor, width: 1)),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * .15,
                          vertical: size.height * .015),
                      foregroundColor: Colors.black,
                      backgroundColor: Theme.of(context).primaryColor),
                  onPressed: () async {
                    final imagePath = await saveImage();
                    nextPage(imagePath);
                  },
                  child: Text(
                    "Save",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: size.width * .04),
                  )),
            ],
          ),
        ));
  }

  void nextPage(String imagePath) {
    Navigator.popUntil(context, ModalRoute.withName('/doctor_homepage'));
    widget.data['imagePath'] = imagePath;
    Navigator.push(
        context,
        SlidePageRoute(
            page: MarkChanges(
        data: widget.data,
        )));
  }

  Future<String> saveImage() async {
    final image = await _imageKey.currentState!.exportImage();
    final directory = await getApplicationDocumentsDirectory();
    String imagePath = '${directory.path}/image.png';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(image!);
    imagePath = await FileServices.storeFile(imageFile);
    final database = await DataBaseServices().database;
    await database!.update('request', {'imagePath': imagePath},
        where: 'id = ?', whereArgs: [widget.data['id']]);
    return imagePath;
  }
}
