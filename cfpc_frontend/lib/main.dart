import 'package:flutter/material.dart';

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
        'home': (context) =>
            const MyHomePage(title: 'CARBON FOOTPRINT CALCULATOR'),
        'logout': (context) => const LogoutPage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.shortestSide * 0.005),
                    child: TextField(
                      controller:
                          TextEditingController(), // use controller to read the input and send to backend for validation
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
                          fontSize: MediaQuery.of(context).size.height * 0.05,
                        ),
                        // contentPadding:
                      ),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.05,
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
                      controller: TextEditingController(),
                      obscureText: true, // can later add view password function
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
                            fontSize: MediaQuery.of(context).size.height * 0.05,
                          )),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.05,
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
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyHomePage(
                                          title:
                                              'CARBON FOOTPRINT CALCULATOR')),
                                  (Route route) => false,
                                );
                              },
                              child: Text(
                                'Log me in!',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.03,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))))
                ]),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            Text(widget.title,
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.03)),
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      // Navigation
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height:
                              MediaQuery.of(context).size.shortestSide * 0.15,
                          width:
                              MediaQuery.of(context).size.shortestSide * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.shortestSide *
                                    0.05),
                          ),
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add,
                                size: MediaQuery.of(context).size.shortestSide *
                                    0.1,
                                color: Colors.green,
                              )),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01),
                        Container(
                          height:
                              MediaQuery.of(context).size.shortestSide * 0.15,
                          width:
                              MediaQuery.of(context).size.shortestSide * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.shortestSide *
                                    0.05),
                          ),
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.bar_chart,
                                size: MediaQuery.of(context).size.shortestSide *
                                    0.1,
                                color: Colors.green,
                              )),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01),
                        Container(
                          height:
                              MediaQuery.of(context).size.shortestSide * 0.15,
                          width:
                              MediaQuery.of(context).size.shortestSide * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.shortestSide *
                                    0.05),
                          ),
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.share,
                                size: MediaQuery.of(context).size.shortestSide *
                                    0.1,
                                color: Colors.green,
                              )),
                        ),
                      ],
                    ),
                    Text(
                      // Welcome
                      'Welcome, user!',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.05,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Text(
                        // info
                        'Till now, you have generated {} grams of carbon footprints!\nGo and plant {} trees to mark your contribution!',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.015,
                            color: Colors.black)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.black,
                          width:
                              MediaQuery.of(context).size.shortestSide * 0.005,
                        ),
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.shortestSide * 0.01),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('LEADERBOARD',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.018,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.29,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  color: Colors.green,
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text('user1\n1234',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.005,
                                        ),
                                        Text('user2\n1234',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.005,
                                        ),
                                        Text('user3\n1234',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
        ],
      ),
    );
  }
}

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
