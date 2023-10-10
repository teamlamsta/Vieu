import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:vieu/controller/file_services.dart';
import 'package:vieu/view/patient_view/Select_Doctor.dart';
import 'package:vieu/view/patient_view/component_widgets/Comment_View.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage(
      {super.key, required this.imagePath, required this.prediction});

  final String imagePath;
  final String prediction;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  bool analyze = false;
  String comment = "";
  String fileName = "";
  File? attachment;
  TextEditingController commentController = TextEditingController();

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
          "Results",
          style: GoogleFonts.poppins(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: size.height * .03,
            ),
            Text(
              widget.prediction,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: size.width * .055,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: size.height * .03,
            ),
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
            SizedBox(
              height: size.height * .06,
            ),
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
                    onPressed: () async {
                      setState(() {
                        analyze = true;
                      });
                      await Future.delayed(const Duration(seconds: 2));
                      setState(() {
                        analyze = false;
                      });
                    },
                    label: Text(
                      "ReScan",
                      style: GoogleFonts.poppins(color: Colors.black),
                    )),
                ElevatedButton.icon(
                    icon: const Icon(Icons.file_upload_outlined),
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
                      String image =
                          await FileServices.storeFile(File(widget.imagePath));
                      String attachmentPath = "";
                      if (attachment != null) {
                        attachmentPath =
                            await FileServices.storeFile(attachment!);
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SelectDoctor(
                                attachmentPath: attachmentPath,
                                imagePath: image,
                                comment: comment,
                              )));
                    },
                    label: Text(
                      "Share",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ))
              ],
            ),
            SizedBox(
              height: size.height * .11,
            ),
            Divider(
              height: 0,
              thickness: 2,
              color: Theme.of(context).primaryColorDark,
            ),
            ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * .04, vertical: size.height * .01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * .03, bottom: size.height * .01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: size.height * .08,
                            width: size.width * .7,
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: size.width * .05,
                                      vertical: size.height * .01),
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        final result =
                                            await FilePicker.platform.pickFiles(
                                          allowMultiple: false,
                                        );
                                        PlatformFile? file =
                                            result?.files.first;
                                        fileName = file!.name;
                                        setState(() {});

                                        attachment = File(file.path!);
                                      },
                                      icon: const Icon(
                                        Icons.attach_file_rounded,
                                        color: Colors.black,
                                      )),
                                  hintText: "Add Comment",
                                  hintStyle: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(size.width * .03),
                              backgroundColor:
                                  Theme.of(context).primaryColorDark,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              )),
                            ),
                            onPressed: () {
                              if (commentController.text.isNotEmpty) {
                                setState(() {
                                  comment = commentController.text;
                                });
                              }
                              commentController.clear();
                            },
                            child: const Icon(Icons.send_rounded,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    comment == ""
                        ? const SizedBox()
                        : CommentView(
                            comment: comment,
                            deleteComment: () {
                              setState(() {
                                comment = "";
                              });
                            }),
                    SizedBox(
                      height: size.height * .02,
                    ),
                    fileName == ""
                        ? const SizedBox()
                        : Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * .03,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  fileName,
                                  style: GoogleFonts.poppins(
                                      fontSize: size.width * .04),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        fileName = "";
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
