import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../controller/custom_route_animation.dart';
import '../../model/doctor_model.dart';
import 'Report_View_Page.dart';

class ListReports extends StatelessWidget {
  const ListReports({super.key,required this.getRecent});
  final Future<List<Map<String,dynamic>>> getRecent;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getRecent,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (ctx, index) {
                  return ListTile(
                    onTap: (){
                      Navigator.push(context,SlidePageRoute(page:ReportViewPage(data: snapshot.data![index],)));
                    },
                    trailing: Text(DateFormat.MMMd().format(
                        DateTime.parse(
                            snapshot.data![index]['createdAt']))),
                    leading: CircleAvatar(
                      radius: size.width * .06,
                      backgroundColor:
                      Theme.of(context).primaryColor,
                      backgroundImage: NetworkImage(
                        doctors
                            .firstWhere((element) =>
                        element.name ==
                            snapshot.data![index]['doctorName'])
                            .imageUrl,
                      ),
                    ),
                    title: Text(
                      "Dr. ${snapshot.data![index]['doctorName']}",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600),
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
