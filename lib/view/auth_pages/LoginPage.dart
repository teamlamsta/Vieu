import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/authentication_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(

        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * .06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Login",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.width * .08),
              ),
              Text(
                "Enter your credentials to make use of \nVieu",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width * .04),
              ),
              SizedBox(
                height: size.height * .05,
              ),
              SizedBox(
                  height: size.height * .27,
                  width: size.width,
                  child: Image.asset(
                    "assets/images/img.png",
                    fit: BoxFit.cover,
                  )),
              Padding(
                padding: EdgeInsets.only(right: size.width * .3),
                child: TabBar(

                  indicatorColor: const Color(0xff4A2092),
                  indicatorPadding:
                      EdgeInsets.symmetric(horizontal: size.width * .05),
                  labelColor: const Color(0xff4A2092),
                  controller: controller,
                  tabs: [
                    Tab(
                      child: Text(
                        "Doctor",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize:
                                MediaQuery.of(context).size.width * .04),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Patient",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize:
                                MediaQuery.of(context).size.width * .04),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: size.height * .04,
              ),
              Form(child: Column(children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Email",
                      hintStyle: GoogleFonts.poppins(
                          color: Colors.black, fontWeight: FontWeight.w500),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: size.height * .02,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Password",
                      hintStyle: GoogleFonts.poppins(
                          color: Colors.black, fontWeight: FontWeight.w500),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),

              ],),),

              SizedBox(
                height: size.height * .02,
              ),
              SizedBox(
                width: size.width * .9,
                child: ElevatedButton(
                  onPressed: () async{
                 bool isAuthenticated=   await AuthenticationController.login(emailController.text,
                        passwordController.text, controller.index == 0);

                   //for persisting the login until the user logout
                  final instance= await SharedPreferences.getInstance();
                  instance.setBool("isAuthenticated", true);

                  if(isAuthenticated&&controller.index==1){
                    FocusManager.instance.primaryFocus?.unfocus();
                    instance.setString("user", "patient");
                    Navigator.pushReplacementNamed(context, '/home');}
                  else if(isAuthenticated&&controller.index==0){
                    FocusManager.instance.primaryFocus?.unfocus();
                    instance.setString("user", "doctor");

                    Navigator.pushReplacementNamed(context, '/doctor_homepage');
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(  SnackBar(backgroundColor:Colors.red, content: Text("Invalid Credentials",style: GoogleFonts.poppins(),)));
                  }
                  },

                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(

                        vertical: size.height * .015),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 3,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontSize: size.width * .05),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * .02,
              ),
              Center(
                child: Text(
                  "Forgot Password?",
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width * .04),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
