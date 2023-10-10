import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/custom_route_animation.dart';
import '../../model/doctor_model.dart';

class ReportViewPage extends StatelessWidget {
  const ReportViewPage({super.key,required this.data});
 final Map<String,dynamic> data;

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
                  height: size.height * .01,
                ),
                Text("Issued by",style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: size.width * .045),),
                SizedBox(
                  height: size.height * .03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: size.width * .1,
                      backgroundImage: NetworkImage(doctors
                          .firstWhere((element) => element.name == data["doctorName"])
                          .imageUrl),
                    ),
                    SizedBox(
                      width: size.width * .05,
                    ),

                    Text(
                      "Dr. ${data['doctorName']}",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: size.width * .045),
                    ),

                  ],
                ),

                SizedBox(
                  height: size.height * .04,
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
                          image: FileImage(File(data["imagePath"])))),
                ),


                SizedBox(
                  height: size.height * .03,
                ),
                ElevatedButton.icon(
                  onPressed: () async{

                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor, width: 1)),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * .15,
                          vertical: size.height * .02),
                      foregroundColor: Colors.black,
                      backgroundColor: Theme.of(context).primaryColor),
                  label: Text("Download Report",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: size.width*.04)),
                  icon: const Icon(
                    Icons.file_download_outlined
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

                Container(
                  width: size.width,
                  color: Colors.white,


                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * .1,

                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * .02,
                      ),
                      Text(
                        "Comments",
                        style: GoogleFonts.poppins(
                            fontSize: size.width * .05,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: size.height * .01,
                      ),
                      Text(
                        data["comment"],
                        style: GoogleFonts.poppins(
                            fontSize: size.width * .04,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: size.height * .02,
                      ),
                      data["reply"]!=""?
                      Container(
                        width: size.width*.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).backgroundColor,
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1
                            )
                          ),
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * .05,
                          vertical: size.height * .01,
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "-> Reply",
                              style: GoogleFonts.poppins(
                                  fontSize: size.width * .03,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: size.height * .01,
                            ),
                            Text(
                              data["reply"],
                              style: GoogleFonts.poppins(
                                  fontSize: size.width * .035,
                                  fontWeight: FontWeight.w400),
                            ),

                          ],
                        ),
                      ):SizedBox(),
                      SizedBox(
                        height: size.height * .02,
                      ),


                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
