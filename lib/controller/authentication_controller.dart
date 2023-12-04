import 'package:vieu/model/doctor_model.dart';
import 'package:vieu/model/patient_model.dart';
class AuthenticationController{
  static String? currentUser;
   static bool login(String email,String password,bool isDoctor){
    if(isDoctor){
      for(int i=0;i<doctors.length;i++){
        if(doctors[i].email==email && doctors[i].password==password){
          currentUser = doctors[i].name;
          return true;
        }
      }
    }else{
      for(int i=0;i<patients.length;i++){
        if(patients[i].email==email && patients[i].password==password){
          currentUser = patients[i].name;
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