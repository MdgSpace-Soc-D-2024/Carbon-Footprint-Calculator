import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cfpc_frontend/constants/api.dart';

import 'package:cfpc_frontend/pages/register.dart';
import 'package:cfpc_frontend/pages/home.dart';

Future<String?> refreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  String? refreshToken = prefs.getString('refresh_token');

  if (refreshToken == null) {
    return null; // No refresh token, force logout
  }

  final url = Uri.parse(refreshURL);

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('access')) {
        await prefs.setString('access_token', data['access']); // Store new access token
        return data['access'];
      }
    }
  } catch (e) {
    print("Error refreshing token: $e");
  }

  return null; // Return null on failure
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _login() async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();
    
    final FlutterSecureStorage storage = FlutterSecureStorage();

    if (username.isEmpty || password.isEmpty) {
      if (!mounted) return;
      _showError('Username or password can not be empty!');
      return;
    }

    final url = Uri.parse(loginURL);
    try {
      
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(
            <String, String>{'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        
        final data = jsonDecode(response.body);
        
        if (data.containsKey('access')) {
          
          await storage.write(key: 'jwt_token', value: data['access']);
          
          final prefs = await SharedPreferences.getInstance(); // save token to shared preferences for easy access
          
          await prefs.setString('access_token', data['access']);
          
          if (!mounted) return;
          
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const MyHomePage(title: 'CARBON FOOTPRINT CALCULATOR')),
            (Route route) => false,
          );
        } 
        
        else {
          if (!mounted) return;
          _showError('Error: Token not found in response!');
        }
      }
      
      else {
        if (!mounted) return;
        _showError('Error: ${response.body}');
      }
    } 
    
    catch (e) {
      if (!mounted) return;
      _showError('Error: $e');
    }
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
                        MediaQuery.of(context).size.shortestSide * 0.005),
                    child: TextField(
                      controller:
                          _usernameController, // use controller to read the input and send to backend for validation
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          size: MediaQuery.of(context).size.shortestSide * 0.05,
                        ),
                        iconColor: Colors.black,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black,
                              width: MediaQuery.of(context).size.shortestSide *
                                  0.001),
                          gapPadding: MediaQuery.of(context).size.height * 0.02,
                        ),
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                        ),
                        // contentPadding:
                      ),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      minLines: 1,
                      cursorColor: Colors.black,
                      cursorErrorColor: Colors.red,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.shortestSide * 0.005),
                    child: TextField(
                      controller: _passwordController,
                      obscureText:
                          _obscurePassword, // can later add view password function
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 4)),
                          icon: Icon(
                            Icons.password,
                            size:
                                MediaQuery.of(context).size.shortestSide * 0.05,
                          ),
                          iconColor: Colors.black,
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.height * 0.03,
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
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                      ),
                      minLines: 1,
                      maxLines: 1,
                      cursorColor: Colors.black,
                      cursorErrorColor: Colors.red,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.shortestSide * 0.01),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Column(children: [
                            ElevatedButton(
                                onPressed: () {
                                  _login();
                                },
                                child: Text(
                                  'Log me in!',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterPage()));
                                },
                                child: Text(
                                  'I\'m a new user, register me!',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.clip,
                                ))
                          ])))
                ]),
              )),
            ),
          ),
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
