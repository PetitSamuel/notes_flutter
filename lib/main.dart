import 'package:flutter/material.dart';
import 'Note.dart';
import 'SQL.dart';
import 'model.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Notes Keeper'),
      routes: <String, WidgetBuilder> {
        '/home': (BuildContext context) => new MyHomePage(),
        '/new' : (BuildContext context) => new FormScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  List<Note> notes = <Note>[];
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Note> notes;
  Widget bodyWidget;

  @override
  void initState() {
    super.initState();
    bodyWidget = new FutureBuilder(
        future: SQL.db.loadAllNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==ConnectionState.done) {
            notes =snapshot.data;
            return _getNotes();
          } else {
            return CircularProgressIndicator();
          }
        }
      );
  }
  final _biggerFont = const TextStyle(fontSize: 18.0);
  int count = 0;

  static final GlobalKey<ScaffoldState> _scaffKey = new GlobalKey<ScaffoldState>();

  Future<List<Note>> _loadNotes () async {
    notes = await SQL.db.loadAllNotes();
    return notes;
  }
  void _addNote() async  {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => new FormScreen(note: new Note(text: '', date:DateTime.now().toUtc())))).then((value) async {
        await _loadNotes();
        setState(() {
          bodyWidget = _getNotes();
        });
    });
  }
  Widget _getNotes() {
    if (notes == null || notes.isEmpty) {
      return ListView();
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return Divider(); /*2*/

        final index = i ~/ 2; /*3*/
        if (index >= notes.length) {
          return null;
          //_notes.addAll(generateWordPairs().take(10)); /*4*/
        }
        return _buildRow(notes[index]);
      }
    );
  }

  // #docregion _buildRow
  Widget _buildRow(Note note) {
    return ListTile(
      title: Text(
        note.text,
        style: _biggerFont,
      ),
      onTap: () => tappedNote(note),
      onLongPress: () => _handleLongPress(),
    );
  }

  void _handleLongPress () {
    print("long pressed stuff");
  }

  void tappedNote(Note note) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => new FormScreen(note: note))).then((value) async {
        await _loadNotes();
        setState(() {
          bodyWidget = _getNotes();
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: bodyWidget == null ? ListView() :bodyWidget,
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'New note',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
