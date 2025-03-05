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
    Future.wait([_getCards(), _getFolders()]).then((_) {
      setState(() {
        // Get the card count for each folder
        for (var folder in folders) {
          folder.count =
              cards.where((card) => card.folderId == folder.id).length;
        }

        // Filter out the cards that have already been assigned to a folder
        cards = cards.where((card) => card.folderId == null).toList();
      });
    });
  }

  Future<void> _getCards() async {
    List<Map<String, dynamic>> cardRows =
        await widget.dbHelper.queryAllRows('Cards');
    setState(() {
      cards = cardRows.map(DeckCard.fromMap).toList();
    });
  }

  Future<void> _getFolders() async {
    List<Map<String, dynamic>> folderRows =
        await widget.dbHelper.queryAllRows('Folders');
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
                  builder: (context) => ScreenTwo(
                        dbHelper: widget.dbHelper,
                        folder: Folder(id: 0, name: '', time: DateTime.now()), /* Replace with actual folder*/
                        cards: [], /* Replace with actual card*/
                      )),
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
  final Folder folder;
  final List<DeckCard> cards;

  const ScreenTwo(
      {super.key,
      required this.dbHelper,
      required this.folder,
      required this.cards});

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
      appBar: AppBar(
        title: Text(widget.folder.name),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: ListView.builder(
            itemCount: widget.cards.length,
            itemBuilder: (context, index) {
              final card = widget.cards[index];
              return ListTile(
                title: Text('${card.name} of ${card.suit}'),
                subtitle: Image.network(card.image),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      widget.cards.removeAt(index);
                    });
                    widget.dbHelper
                        .update('Cards', {...card.toMap(), 'folder_id': null});
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DeckCard {
  final String name;
  final String suit;
  final String image;
  final int? folderId;

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
      folderId: map['folder_id'] != null ? map['folder_id'] as int : null,
    );
  }
}

class Folder {
  final int id;
  final String name;
  final DateTime time;

  int count = 0;

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
