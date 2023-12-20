import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/doctor_model.dart';
class ShareConfirmPage extends StatelessWidget {
   ShareConfirmPage({super.key,required this. doctor});
  Doctor doctor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Card(
            child: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width*.05),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width*.8,
              height: MediaQuery.of(context).size.height*.3,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   CircleAvatar(
                    radius: MediaQuery.of(context).size.width * .1,
                    backgroundImage: NetworkImage(
                     doctor.imageUrl,
                    )
                  ),
                  Text("Your report has been shared with ",style: GoogleFonts.poppins(fontSize: 15),),
                  Text("Dr. ${doctor.name}",style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w600),),
                ],
              ),
            ),
          ),),
           SizedBox(height: MediaQuery.of(context).size.height*.05,),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .1,vertical: MediaQuery.of(context).size.height * .015),
            ),
            onPressed: () {

              Navigator.pushNamedAndRemoveUntil(context, '/home',ModalRoute.withName('/'));
            },
            label: Text("Done",style: GoogleFonts.poppins(fontSize: MediaQuery.of(context).size.width*.05,color: Colors.black,fontWeight: FontWeight.w600),),
            icon: const Icon(Icons.done_outline_rounded,color: Colors.black,),
          ),
        ],
      )
      );

  }
}
