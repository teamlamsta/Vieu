import 'package:shared_preferences/shared_preferences.dart';
import 'package:vieu/model/doctor_model.dart';
import 'package:vieu/model/patient_model.dart';
class AuthenticationController{

   static Future<bool> login(String email,String password,bool isDoctor)async{
     final ref = await SharedPreferences.getInstance();
     String? currentUser;
    if(isDoctor){
      for(int i=0;i<doctors.length;i++){
        if(doctors[i].email==email && doctors[i].password==password){
          currentUser = doctors[i].name;

          ref.setString("userName", currentUser??"");

          return true;
        }
      }
    }else{
      for(int i=0;i<patients.length;i++){
        if(patients[i].email==email && patients[i].password==password){
          currentUser = patients[i].name;
          final ref = await SharedPreferences.getInstance();
          ref.setString("userName", currentUser??"");

          return true;
        }
      }
    }
    return false;
    
  }
  void logout(){
    print('logout');
  }
}