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
  List<DeckCard> cards = [];
  List<Folder> folders = [];

  @override
  void initState() {
    super.initState();
    widget.dbHelper.init();
    _getCards();
    _getFolders();
  }

  void _getCards() async {
    List<Map<String, dynamic>> cardRows = await widget.dbHelper.queryAllRows('Cards');
    setState(() {
      cards = cardRows.map(DeckCard.fromMap).toList();
    });
  }

  void _getFolders() async {
    List<Map<String, dynamic>> folderRows = await widget.dbHelper.queryAllRows('Folders');
    setState(() {
      folders = folderRows.map(Folder.fromMap).toList();
    });
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

class DeckCard {
  final String name;
  final String suit;
  final String image;
  final int folderId;

  DeckCard({
    required this.name,
    required this.suit,
    required this.image,
    required this.folderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'suit': suit,
      'image': image,
      'folder_id': folderId,
    };
  }

  factory DeckCard.fromMap(Map<String, dynamic> map) {
    return DeckCard(
      name: map['name'],
      suit: map['suit'],
      image: map['image'],
      folderId: map['folder_id'],
    );
  }
}

class Folder {
  final int id;
  final String name;
  final DateTime time;

  Folder({
    required this.id,
    required this.name,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'time': time,
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'],
      name: map['name'],
      time: map['time'],
    );
  }
}
