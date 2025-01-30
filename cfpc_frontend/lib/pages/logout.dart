import 'package:flutter/material.dart';
import 'package:cfpc_frontend/pages/login.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPage();
}

class _LogoutPage extends State<LogoutPage> {
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
                      fontSize: MediaQuery.of(context).size.width * 0.035)),
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
        body: Column(children: [
          Expanded(
            child: Container(
              color: Colors.green,
              child: Center(
                child: Text(
                    "We're sorry to see you go, goodbye!\nKeep using Carbon Footprint Calculator!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    )),
              ),
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
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ]));
  }
}