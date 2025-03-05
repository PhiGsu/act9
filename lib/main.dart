import 'package:flutter/material.dart';
import 'helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Organizer App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ScreenOne(dbHelper: dbHelper),
    );
  }
}

class ScreenOne extends StatefulWidget {
  final DatabaseHelper dbHelper;

  const ScreenOne({super.key, required this.dbHelper});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  @override
  void initState() {
    super.initState();
    widget.dbHelper.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Folders Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the second screen
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScreenTwo(dbHelper: widget.dbHelper)),
            );
          },
          child: Text('Go to Cards Screen for Each Folder'),
        ),
      ),
    );
  }
}

class ScreenTwo extends StatefulWidget {
  final DatabaseHelper dbHelper;

  const ScreenTwo({super.key, required this.dbHelper});

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  @override
  void initState() {
    super.initState();
    widget.dbHelper.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cards Screen for Each Folder')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Back to Folders Screen'),
        ),
      ),
    );
  }
}
