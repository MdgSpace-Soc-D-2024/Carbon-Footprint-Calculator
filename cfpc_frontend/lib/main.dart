import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carbon Footprint Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CARBON FOOTPRINT CALCULATOR'),
    );
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('./assets/images/logo.png', height: MediaQuery.of(context).size.height * 0.05, width: MediaQuery.of(context).size.width * 0.05),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            Text(widget.title, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.03),
            overflow: TextOverflow.ellipsis,
            ),
          ],
          ),
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: (){}, icon: Icon(Icons.add, size: MediaQuery.of(context).size.shortestSide * 0.1, color: Colors.green,)),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                IconButton(onPressed: (){}, icon: Icon(Icons.bar_chart, size: MediaQuery.of(context).size.shortestSide * 0.1, color: Colors.green,)),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                IconButton(onPressed: (){}, icon: Icon(Icons.share, size: MediaQuery.of(context).size.shortestSide * 0.1, color: Colors.green)),                
              ],
            ),
            Text(
              'Welcome, user!',
              style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.05),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              'Till now, you have generated {} grams of carbon footprints!\nGo and plant {} trees to mark your contribution!',
              style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02)
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Container(
              color: Colors.green,
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LEADERBOARD',
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.05, color: Colors.black)
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'user1\ncarbonfootprints', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.01, color: Colors.black)
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      Text(
                        'user2\ncarbonfootprints', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.01, color: Colors.black)
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      Text(
                        'user3\ncarbonfootprints', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.01, color: Colors.black)
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
