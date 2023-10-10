class Patient {
  Patient({required this.name, required this.email, required this.password, required this.imageUrl});
  String name;
  String email;
  String password;
  String imageUrl;
}

List<Patient> patients = [
  Patient(name: "Rahul", email: "patient1@abc.com", password: "patient1@abc", imageUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fHBvcnRyYWl0fGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60"),
  Patient(name: "Gokul", email: "patient2@abc.com", password: "patient2@abc", imageUrl: "https://images.unsplash.com/photo-1504257432389-52343af06ae3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fHBvcnRyYWl0fGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60"),
  Patient(name: "Sunith", email: "patient3@abc.com", password: "patient3@abc", imageUrl: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cG9ydHJhaXR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60"),
  Patient(name: "Naaji", email: "patient4@abc.com", password: "patient4@abc",imageUrl:  "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cG9ydHJhaXR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60" ),];