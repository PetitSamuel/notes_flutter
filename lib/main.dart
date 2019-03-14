import 'package:flutter/material.dart';
import 'Note.dart';
import 'globals.dart' as globals;
import 'File.dart';


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

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    CounterStorage.readNotes().then((List<String> value) {
      setState(() {
        if (value != null) {
          globals.notes = value;
        }
      });
    });
  }

  final _biggerFont = const TextStyle(fontSize: 18.0);
  int count = 0;

  void _addNote() {
    globals.currentNote = "";
    Navigator.pushNamed(context, '/new');
  }
  Widget _getNotes() {
    List<String> _notes = (globals.notes == null) ? null : globals.notes.reversed.toList();
    if (_notes == null || _notes.isEmpty) {
      return null;
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return Divider(); /*2*/

        final index = i ~/ 2; /*3*/
        if (index >= _notes.length) {
          return null;
          //_notes.addAll(generateWordPairs().take(10)); /*4*/
        }
        return _buildRow(_notes[index]);
      }
    );
  }

  // #docregion _buildRow
  Widget _buildRow(String note) {
    if (note.isEmpty) {
      return null;
    }
    return ListTile(
      title: Text(
        note,
        style: _biggerFont,
      ),
      onTap: () => tappedNote(note),
    );
  }

  void tappedNote(String note) {
    globals.currentNote = note;
    Navigator.pushNamed(context, '/new');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _getNotes(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'New note',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
