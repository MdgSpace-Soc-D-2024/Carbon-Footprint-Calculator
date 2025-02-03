// Material App
import 'package:flutter/material.dart';

// Pages
import 'package:cfpc_frontend/pages/home.dart';
import 'package:cfpc_frontend/pages/register.dart';
import 'package:cfpc_frontend/pages/login.dart';
import 'package:cfpc_frontend/pages/logout.dart';
import 'package:cfpc_frontend/pages/insertfootprints.dart';
import 'package:cfpc_frontend/pages/viewfootprints.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carbon Footprint Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        'register': (context) => const RegisterPage(),
        'home': (context) =>
            const MyHomePage(title: 'CARBON FOOTPRINT CALCULATOR'),
        'logout': (context) => const LogoutPage(),
        'insertfootprints': (context) => const InsertFootprintsPage(),
        'viewfootprints': (context) => const ViewFootprintsPage(),
      },
    );
  }
}