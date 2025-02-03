class Register{
  
  String name;
  int age;
  int profession;
  int purpose;
  String username;
  String password;

  Register({required this.name, required this.age, required this.profession, required this.purpose, required this.username, required this.password});
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'profession': profession,
      'purpose_of_joining': purpose,
      'username': username,
      'password': password,
    };
  }

}

enum Profession {
  educator('Educator (Teacher/Professor)'),
  engineer('Engineer/Technician'),
  healthcare('Healthcare Professional'),
  corporate('Corporate/Office Worker'),
  service('Service Industry (Retail/Hospitality)'),
  agriculture('Agriculture/Fisheries'),
  selfemp('Self-Employed'),
  other('Other');

  const Profession(this.label);
  final String label;
}

enum Purpose {
  personal('Personal'),
  research('Research/Academic Purposes'),
  business('Business/Commercial'),
  other('Other');

  const Purpose(this.label);
  final String label;
}