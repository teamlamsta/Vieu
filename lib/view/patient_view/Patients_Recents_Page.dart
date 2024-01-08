import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vieu/controller/authentication_controller.dart';
import 'package:vieu/view/patient_view/component_widgets/List_Reports.dart';

import '../../controller/database_controllers/database_controller.dart';

class PatientRecentsPage extends StatefulWidget {
  const PatientRecentsPage({super.key});

  @override
  State<PatientRecentsPage> createState() => _PatientRecentsPageState();
}

class _PatientRecentsPageState extends State<PatientRecentsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              titleSpacing: .1,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Theme.of(context).backgroundColor,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: const Color(0xff4A2092),
                labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: size.width * .04),
                indicatorPadding:
                    EdgeInsets.symmetric(horizontal: size.width * .05),
                labelColor: const Color(0xff4A2092),
                tabs: const [
                  Tab(
                    child: Text(
                      "Pending",
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Approved",
                    ),
                  ),
                ],
              ),
              leadingWidth: size.width * .2,
              title: Text(
                "Recents",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * .06),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.black,
                ),
              )),
          backgroundColor: Theme.of(context).backgroundColor,
          body: Column(
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
                    // controller: commentController,
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
                        hintText: "Search for particular doctor",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: size.width * .03,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(children: [
                  ListReports(getRecent: getRecent('pending')),
                  ListReports(getRecent: getRecent('Accepted'))
                ]),
              )
            ],
          )),
    );
  }

  Future<List<Map<String, dynamic>>> getRecent(String status) async {
    final database = await DataBaseServices().database;
    final ref = await SharedPreferences.getInstance();

    String? patientName=ref.getString("userName");

    final result = await database!.rawQuery(
        'select * from request where patientName = "$patientName" and status = "$status" order by createdAt desc');



    return result;
  }
}
