import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vieu/controller/custom_route_animation.dart';
import 'package:vieu/controller/database_controllers/database_controller.dart';
import 'package:vieu/model/patient_model.dart';
import 'package:vieu/view/doctor_view/MarkFindingsPage.dart';
import 'package:vieu/view/doctor_view/component_widgets/comment_view.dart';

class MarkChanges extends StatefulWidget {
  const MarkChanges(
      {super.key,
      required this.data});

  final Map<String,dynamic> data;

  @override
  State<MarkChanges> createState() => _MarkChangesState();
}

class _MarkChangesState extends State<MarkChanges> {
  final TextEditingController _replyController = TextEditingController();

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
          child: SizedBox(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * .03,
                ),
                CircleAvatar(
                  radius: size.width * .09,
                  backgroundImage: NetworkImage(patients
                      .firstWhere((element) => element.name == widget.data['patientName'])
                      .imageUrl),
                ),
                SizedBox(
                  height: size.height * .01,
                ),
                Text(
                  widget.data['patientName'],
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: size.width * .04),
                ),
                SizedBox(
                  height: size.height * .04,
                ),
                Text(
                  "Defects",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: size.width * .045),
                ),
                SizedBox(
                  height: size.height * .02,
                ),
                Container(
                  height: size.height * .35,
                  width: size.width * .75,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 2),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(widget.data['imagePath'])))),
                ),
                SizedBox(
                  height: size.height * .03,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        SlidePageRoute(
                            page: MarkFindingsPage(
                              data: widget.data,)));
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor, width: 1)),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * .2,
                          vertical: size.height * .02),
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white),
                  label: Text("Mark Findings",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  icon: const Icon(
                    Icons.edit,
                  ),
                ),
                SizedBox(
                  height: size.height * .03,
                ),
                ElevatedButton.icon(
                  onPressed: () async{
                    await submitReport();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor, width: 1)),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * .2,
                          vertical: size.height * .02),
                      foregroundColor: Colors.black,
                      backgroundColor: Theme.of(context).primaryColor),
                  label: Text("Submit Report",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  icon: const Icon(
                    Icons.verified_outlined,
                  ),
                ),
                SizedBox(
                  height: size.height * .03,
                ),
                const Divider(
                  height: 0,
                  thickness: 2,
                  color: Colors.black26,
                ),
                SizedBox(
                  height: size.height * .03,
                ),
               CommentView(comment: widget.data['comment'], replyController: _replyController)
              ],
            ),
          ),
        ));
  }

  Future<void> submitReport() async {
   final database = await DataBaseServices().database;
   await database!.update('request', {'status': 'Accepted','reply': _replyController.text},
       where: 'id = ?', whereArgs: [widget.data['id']]);

  }
}
