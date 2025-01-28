import 'package:flutter/material.dart';
import 'package:cfpc_frontend/pages/main.dart';
import 'package:cfpc_frontend/models/register.dart';

import 'package:cfpc_frontend/constants/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int age = 18;
  Profession profession = Profession.other;
  Purpose purpose = Purpose.other;
  bool _obscurePassword = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // void fetchData() async{
  //   try{
  //     http.Response response = await http.get(Uri.parse(api));
  //     var data = response.body; // String
  //     data = json.decode(response.body); // List
  //     data.forEach((register){
  //       Register u = Register(
  //         name: data['name'],
  //         age: data['age'],
  //         profession: data['profession'],
  //         purpose: data['purpose'],
  //         username: data['username'],
  //         password: data['password']
  //       );
  //     user.add(u);
  //     });
  //   }
  //   catch(e){
  //     print('Error is $e');
  //   }
  // }

  Future<void> sendData(Register user) async {
    try {
      final response = await http.post(
        Uri.parse(registerURL),
        headers: headers,
        body: jsonEncode(user.toJson()),
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User registered successfully!')),);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const MyHomePage(
                      title:
                          'CARBON FOOTPRINT CALCULATOR')),
          (Route route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
    );
    }
  }

  void registerUser() {
    final user = Register(
      name: nameController.text.trim(),
      age: age,
      profession: profession.index + 1,
      purpose: purpose.index + 1,
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );

    sendData(user);
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // @override
  // void initState(){
  //   super.initState();
  //   user = List(Register(name: '', age: 18, profession: Profession.other, purpose: Purpose.other, username: '', password: ''));
  //   sendData(user);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('./assets/images/logo.png',
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.05),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              Text('CARBON FOOTPRINT CALCULATOR',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.03)),
            ],
          ),
          toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        ),
        body: Column(children: [
          Expanded(
              child: Container(
                  color: Colors.green,
                  child: Center(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(children: [
                            Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.shortestSide *
                                        0.01),
                                child: TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 4)),
                                      icon: Icon(
                                        Icons.person,
                                        size: MediaQuery.of(context)
                                                .size
                                                .shortestSide *
                                            0.05,
                                      ),
                                      iconColor: Colors.black,
                                      labelText: 'Name',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.03,
                                      )),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.03,
                                  ),
                                  minLines: 1,
                                  maxLines: 1,
                                  cursorColor:
                                      const Color.fromARGB(255, 192, 96, 96),
                                  cursorErrorColor: Colors.red,
                                )),
                            Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.shortestSide *
                                        0.01),
                                child: Slider(
                                  value: age.toDouble(),
                                  min: 5,
                                  max: 100,
                                  divisions: 100,
                                  label: 'Age $age',
                                  onChanged: (double value) {
                                    setState(() {
                                      age = value.toInt();
                                    });
                                  },
                                )),
                            Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.shortestSide *
                                        0.01),
                                child: DropdownMenu<Purpose>(
                                  initialSelection: purpose,
                                  // controller
                                  requestFocusOnTap: true,
                                  label: const Text('Purpose of Joining',
                                      style: TextStyle(color: Colors.black)),
                                  onSelected: (Purpose? selectedPurpose) {
                                    setState(() {
                                      purpose =
                                          selectedPurpose ?? Purpose.other;
                                    });
                                  },
                                  dropdownMenuEntries: Purpose.values
                                      .map<DropdownMenuEntry<Purpose>>(
                                          (Purpose item) {
                                    return DropdownMenuEntry<Purpose>(
                                      value: item,
                                      label: item.label,
                                    );
                                  }).toList(),
                                )),
                            Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.shortestSide *
                                        0.01),
                                child: DropdownMenu<Profession>(
                                  initialSelection: Profession.other,
                                  // controller
                                  requestFocusOnTap: true,
                                  label: const Text(
                                    'Profession',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onSelected: (Profession? selectedProfession) {
                                    setState(() {
                                      profession = selectedProfession ??
                                          Profession.other;
                                    });
                                  },
                                  dropdownMenuEntries: Profession.values
                                      .map<DropdownMenuEntry<Profession>>(
                                          (Profession item) {
                                    return DropdownMenuEntry<Profession>(
                                      value: item,
                                      label: item.label,
                                    );
                                  }).toList(),
                                )),
                            Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.shortestSide *
                                        0.01),
                                child: TextField(
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 4)),
                                      icon: Icon(
                                        Icons.person_add,
                                        size: MediaQuery.of(context)
                                                .size
                                                .shortestSide *
                                            0.05,
                                      ),
                                      iconColor: Colors.black,
                                      labelText: 'Username',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.03,
                                      )),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.03,
                                  ),
                                  minLines: 1,
                                  maxLines: 1,
                                  cursorColor: Colors.black,
                                  cursorErrorColor: Colors.red,
                                )),
                            Padding(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.shortestSide *
                                      0.005),
                              child: TextField(
                                controller: passwordController,
                                obscureText:
                                    _obscurePassword, // can later add view password function
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 4)),
                                    icon: Icon(
                                      Icons.password,
                                      size: MediaQuery.of(context)
                                              .size
                                              .shortestSide *
                                          0.05,
                                    ),
                                    iconColor: Colors.black,
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    )),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                                minLines: 1,
                                maxLines: 1,
                                cursorColor: Colors.black,
                                cursorErrorColor: Colors.red,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.shortestSide *
                                        0.01),
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          registerUser();
                                        },
                                        child: Text(
                                          'Register Me!',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )))),
                          ]))))),
          // Footer
          Container(
            color: Colors.black,
            width: double.infinity,
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.01,
              right: MediaQuery.of(context).size.width * 0.01,
              top: MediaQuery.of(context).size.height * 0.01,
              bottom: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Text(
              'Carbon Footprint Calculator - © 2025 All Rights Reserved',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ]));
  }
}
