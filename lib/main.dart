import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vieu/view/patient_view/Image_View_Page.dart';
import 'package:vieu/view/patient_view/Patient_HomePage.dart';
import 'package:vieu/view/auth_pages/LoginPage.dart';
import 'package:vieu/view/doctor_view/Doctor_Homepage.dart';
import 'package:vieu/view/patient_view/Patients_Recents_Page.dart';

void main() {
  runApp(const VieuApp());
}
class VieuApp extends StatelessWidget {
  const VieuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home':(context)=>const HomePage(),
        '/login':(context)=>const LoginPage(),
        "/doctor_homepage":(context)=>const DoctorHomePage(),
        "/imageview_page":(context)=> ImageViewPage(imagePath: ""),
        "/patient_recents":(context)=>const PatientRecentsPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Vieu App',
      theme: ThemeData(
        primaryColor: const Color(0xff28C39B),
        backgroundColor: const Color(0xffeefefa),
        primaryColorDark: const Color(0xff008758),primaryColorLight: const Color(0xffADE5D4
    ),
      ),
      home:  FutureBuilder(
        future: dataFetch(),
        builder: (ctx,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Scaffold(body: Center(child: CircularProgressIndicator(),),);
          }
          if(!snapshot.data!["isAuthenticated"]) {
            return const LoginPage();
          } else if(snapshot.data!["user"]=="patient"){
            return const HomePage();
          }
          else{
            return const DoctorHomePage();
          }
        },
      )
    );
  }
  //to fetch authentication status and user
  Future<Map> dataFetch()async{
    final inf = await SharedPreferences.getInstance();
    Map<String,dynamic> data={};
    data.addAll({
      "isAuthenticated": inf.getBool("isAuthenticated")??false,
      "user":inf.getString("user")??""

    });
    return data;

  }
}


