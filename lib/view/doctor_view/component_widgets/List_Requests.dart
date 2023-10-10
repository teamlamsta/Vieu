import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../controller/custom_route_animation.dart';
import '../../../model/patient_model.dart';
import '../View_Request.dart';

class ListRequests extends StatelessWidget {
  const ListRequests( {super.key, required this.getRecent});
 final Future<List<Map<String,dynamic>>> getRecent;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: size.height * .03,
        ),
        Center(
          child: SizedBox(
            height: size.height * .08,
            width: size.width * .75,
            child: TextField(

              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: size.width * .05,
                      vertical: size.height * .01),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.black,
                  ),
                  hintText: "Search for particular reports",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: size.width * .03,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
              future: getRecent,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if(snapshot.data!.isEmpty){
                    return Center(child: Text("No Reports Found",style: GoogleFonts.poppins(fontSize: size.width*.05,fontWeight: FontWeight.w600),));
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          onTap: () {
                            log(snapshot.data![index]['imagePath']);
                            Navigator.push(
                                context,
                                SlidePageRoute(
                                    page: MarkChanges(
                                    data: snapshot.data![index],
                                    )));
                          },
                          trailing: Text(DateFormat.MMMd().format(
                              DateTime.parse(
                                  snapshot.data![index]['createdAt']))),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              patients
                                  .firstWhere((element) =>
                              element.name ==
                                  snapshot.data![index]
                                  ['patientName'])
                                  .imageUrl,
                            ),
                          ),
                          title: Text(
                            snapshot.data![index]['patientName'],
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600),
                          ),
                        );
                      });
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        )
      ],
    );
  }
}
