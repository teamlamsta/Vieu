class PatientRequest{
  String patientName;
  DateTime createdAt;
  String status;
  String doctorName;
  String imagePath;
  PatientRequest({required this.patientName,required this.createdAt,required this.status,required this.doctorName,required this.imagePath});
}