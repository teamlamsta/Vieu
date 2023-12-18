import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vieu/controller/authentication_controller.dart';
import 'package:vieu/view/doctor_view/component_widgets/List_Requests.dart';

import '../../controller/database_controllers/database_controller.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> with SingleTickerProviderStateMixin{
 
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
              indicatorColor: const Color(0xff4A2092),
              indicatorPadding:
                  EdgeInsets.symmetric(horizontal: size.width * .05),
              labelColor: const Color(0xff4A2092),
              tabs: [

                Tab(
                  child: Text(
                    "Pending",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: size.width * .04),
                  ),
                ),
                Tab(
                  child: Text(
                    "Accepted",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: size.width * .04),
                  ),
                ),

              ],
            ),
            title: Text(
              "Vieu",
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: size.width * .06),
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
            actions: [
              PopupMenuButton(itemBuilder: (ctx){
                return [
                  PopupMenuItem(child: Text("Logout"),onTap: ()async{
                    final ref = await SharedPreferences.getInstance();
                    ref.clear();
                    Navigator.pushReplacementNamed(context, '/login');
                  },)
                ];
              })
            ],
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          body: TabBarView(
            children: [
              ListRequests( getRecent: getRecent('pending'),),
              ListRequests(getRecent: getRecent('Accepted'))
            ]
          )),
    );
  }

  Future<List<Map<String, dynamic>>> getRecent(String status) async {
    final database = await DataBaseServices().database;
    String? doctorName = AuthenticationController.currentUser;

    return await database!
        .rawQuery('select * from request where doctorName = "$doctorName" and status = "$status" order by createdAt desc');
  }
}
