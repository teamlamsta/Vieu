class Doctor{
  Doctor({required this.name,required this.email,required this.password,required this.imageUrl});
  String name;
  String email;
  String password;
  String imageUrl;
}

List<Doctor> doctors = [
  Doctor(name: "Jacob", email: "doctor1@abc.com", password: "doctor1@abc",imageUrl: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cG9ydHJhaXR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60"),
  Doctor(name: "Peter", email: "doctor2@abc.com", password: "doctor2@abc",imageUrl: "https://images.unsplash.com/photo-1521119989659-a83eee488004?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8cG9ydHJhaXR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60"),
  Doctor(name: "Paul", email: "doctor3@abc.com", password: "doctor3@abc",imageUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fHBvcnRyYWl0fGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60"),
  Doctor(name: "Raj", email: "doctor4@abc.com", password: "doctor4@abc",imageUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fHBvcnRyYWl0fGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60"),
  Doctor(name: "Arun", email: "doctor5@abc.com", password: "doctor5@abc",imageUrl: "https://images.unsplash.com/photo-1504257432389-52343af06ae3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fHBvcnRyYWl0fGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60"),
];
