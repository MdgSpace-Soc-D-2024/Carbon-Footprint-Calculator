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