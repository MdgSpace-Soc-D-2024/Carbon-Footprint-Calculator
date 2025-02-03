import 'package:flutter/material.dart';
import 'package:cfpc_frontend/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPage();
}

class _LogoutPage extends State<LogoutPage> {
  bool _isLoading = true;
  bool _loggedIn = true;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _fetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        setState(() {
          _loggedIn = false;
          _isLoading = false;
        });
        return;
      }

      final url = Uri.parse('YOUR_LOGOUT_URL');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'refresh_token': token}),
      );

      if (response.statusCode == 200) {
        await prefs.remove('access_token');
        setState(() {
          _loggedIn = false;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to log out.');
      }
    } catch (e) {
      _showError('Error: $e');
      setState(() {
        _isLoading = false;
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
    
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_loggedIn) {
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
              Text(
                'CARBON FOOTPRINT CALCULATOR',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.035),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.login,
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
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.height * 0.15,
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        "We're sorry to see you go, goodbye!\nKeep using Carbon Footprint Calculator!",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                        ),
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
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }
}
