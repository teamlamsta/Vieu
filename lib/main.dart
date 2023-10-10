import 'package:flutter/material.dart';
import 'package:vieu/view/patient_view/Patient_HomePage.dart';
import 'package:vieu/view/auth_pages/LoginPage.dart';
import 'package:vieu/view/doctor_view/Doctor_Homepage.dart';

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
      },
      debugShowCheckedModeBanner: false,
      title: 'Vieu App',
      theme: ThemeData(
        primaryColor: const Color(0xff28C39B),
        backgroundColor: const Color(0xffeefefa),
        primaryColorDark: const Color(0xff008758),primaryColorLight: const Color(0xffADE5D4
    ),
      ),
      home:  LoginPage()
    );
  }
}


