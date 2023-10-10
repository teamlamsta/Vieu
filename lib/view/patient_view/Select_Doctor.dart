import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vieu/controller/database_controllers/RequestTable.dart';
import 'package:vieu/controller/authentication_controller.dart';
import 'package:vieu/controller/database_controllers/database_controller.dart';

import '../../model/doctor_model.dart';

import 'Share_Confirm_Page.dart';
class SelectDoctor extends StatelessWidget {
   SelectDoctor({super.key, required this.imagePath,required this.comment,required this.attachmentPath});
String imagePath,comment,attachmentPath;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
         padding: EdgeInsets.symmetric(horizontal: size.width * .1,vertical: size.height * .015),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        label: Text("Share",style: GoogleFonts.poppins(fontSize: size.width*.05,color: Colors.black),),
        icon: const Icon(Icons.file_upload_outlined,color: Colors.black,),
      ),
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
          "Select Doctor",
          style: GoogleFonts.poppins(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return ListTile(
            style: ListTileStyle.list,
            leading: CircleAvatar(
              radius: size.width * .05,
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage:  NetworkImage(
                doctors[index].imageUrl,
              )

            ),
            title: Text(doctors[index].name,style: GoogleFonts.poppins(fontWeight: FontWeight.w600),),
            onTap: () async{
              final database = await DataBaseServices().database;
              await database!.insert('request', {"patientName": AuthenticationController.currentUser, "doctorName": doctors[index].name,"createdAt": DateTime.now().toIso8601String(),  "imagePath": imagePath,"attachmentPath":attachmentPath, "status": "pending","comment":comment});

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>  ShareConfirmPage(doctor: doctors[index],)));
            },
          );
        },
      ),
    );
  }
}
