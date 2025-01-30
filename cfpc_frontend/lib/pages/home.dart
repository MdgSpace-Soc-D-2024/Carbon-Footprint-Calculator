import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cfpc_frontend/constants/api.dart';
import 'package:cfpc_frontend/main.dart';
import 'package:cfpc_frontend/pages/login.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String _username = 'Anonymous';
  double _carbonFootprints = 0.0;
  int _numberOfTrees = 0;
  bool _isLoading = true;
  bool _loggedIn = false;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _fetchData() async {
    final String? token = await storage.read(key: "auth_token");

    if (token == null) {
      setState(() {
        _loggedIn = false;
        _isLoading = false;
      });
      return;
    }

    final url = Uri.parse(homeURL);

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _username = data['username'] ?? 'Anonymous';
          _carbonFootprints = (data['carbon_footprints'] ?? 0.0).toDouble();
          _numberOfTrees = (data['number_of_trees'] ?? 0).toInt();
          _isLoading = false;
          _loggedIn = true;
        });
      } else {
        _showError(
            'Failed to load data! Error: ${response.statusCode} ${response.body}');
        setState(() {
          _isLoading = false;
          _loggedIn = false;
        });
      }
    } catch (e) {
      _showError('Failed to connect to the server!');
      setState(() {
        _isLoading = false;
        _loggedIn = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              './assets/images/logo.png',
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            Text(
              widget.title,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.03,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LogoutPage()),
                  (Route route) => false,
                );
              },
              icon: Icon(
                Icons.logout,
                size: MediaQuery.of(context).size.shortestSide * 0.07,
                color: Colors.green,
              ),
            ),
          ],
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.green,
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.black))
                  : _loggedIn
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Welcome, $_username!',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.05,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Text(
                                'Till now, you have generated $_carbonFootprints grams of carbon footprints!\nGo and plant $_numberOfTrees trees to mark your contribution!',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.015,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (Route route) => false,
                              );
                            },
                            child: Text(
                              'Please login to view this page!',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
            ),
          ),
          Container(
            color: Colors.black,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01,
              horizontal: MediaQuery.of(context).size.width * 0.01,
            ),
            child: Text(
              'Carbon Footprint Calculator - © 2025 All Rights Reserved',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
