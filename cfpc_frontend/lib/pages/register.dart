import 'package:flutter/material.dart';

import 'package:cfpc_frontend/pages/login.dart';
import 'package:cfpc_frontend/models/register.dart';

import 'package:cfpc_frontend/constants/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _age = 18;
  Profession _profession = Profession.other;
  Purpose _purpose = Purpose.other;
  bool _obscurePassword = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
                  const LoginPage()),
          (Route route) => false,
        );
      } else {
        _showError('Error: ${response.body}');
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Error: $e');
    }
  }

  void registerUser() {
    final user = Register(
      name: _nameController.text.trim(),
      age: _age,
      profession: _profession.index + 1,
      purpose: _purpose.index + 1,
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );

    sendData(user);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                                        0.005),
                                child: TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 4)),
                                      icon: Icon(
                                        Icons.person,
                                        size: MediaQuery.of(context)
                                                .size
                                                .shortestSide *
                                            0.04,
                                      ),
                                      iconColor: Colors.black,
                                      labelText: 'Name',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      )),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
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
                                        0.005),
                                child: Slider(
                                  value: _age.toDouble(),
                                  min: 5,
                                  max: 100,
                                  divisions: 100,
                                  label: 'Age $_age',
                                  onChanged: (double value) {
                                    setState(() {
                                      _age = value.toInt();
                                    });
                                  },
                                )),
                            Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.shortestSide *
                                        0.005),
                                child: DropdownMenu<Purpose>(
                                  initialSelection: _purpose,
                                  requestFocusOnTap: true,
                                  label: const Text('Purpose of Joining',
                                      style: TextStyle(color: Colors.black)),
                                  onSelected: (Purpose? selectedPurpose) {
                                    setState(() {
                                      _purpose =
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
                                        0.005),
                                child: DropdownMenu<Profession>(
                                  initialSelection: _profession,
                                  requestFocusOnTap: true,
                                  label: const Text(
                                    'Profession',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onSelected: (Profession? selectedProfession) {
                                    setState(() {
                                      _profession = selectedProfession ??
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
                                        0.005),
                                child: TextField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 4)),
                                      icon: Icon(
                                        Icons.person_add,
                                        size: MediaQuery.of(context)
                                                .size
                                                .shortestSide *
                                            0.04,
                                      ),
                                      iconColor: Colors.black,
                                      labelText: 'Username',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      )),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
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
                                controller: _passwordController,
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
                                          0.04,
                                    ),
                                    iconColor: Colors.black,
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.black,
                                        size: MediaQuery.of(context)
                                            .size
                                            .shortestSide *
                                            0.04,
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
                                      MediaQuery.of(context).size.height * 0.02,
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
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
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
                                                0.02,
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
              style: TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          ),
        ]));
  }
}
