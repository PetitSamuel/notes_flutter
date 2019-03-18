import 'package:flutter/material.dart';
import 'Note.dart';
import 'SQL.dart';
import 'model.dart';
import 'theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share/share.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes Keeper',
      theme: myAppTheme,
      home: MyHomePage(title: 'Notes Keeper'),
      routes: <String, WidgetBuilder> {
        '/home': (BuildContext context) => new MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final List<Note> notes = <Note>[];
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
          if (snapshot.connectionState == ConnectionState.done) {
            notes =snapshot.data;
            return _getNotes();
          } else {
            return CircularProgressIndicator();
          }
        }
      );
  }

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
      itemCount: (notes.length * 2) - 1,
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return Divider(
          color: Theme.of(context).splashColor,
        ); /*2*/

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
  return new Slidable(
  delegate: new SlidableDrawerDelegate(),
  actionExtentRatio: 0.25,
  child: ListTile(
        title: Text(
          note.text,
          style: Theme.of(context).textTheme.body1  ,
          ),
          onTap: () => tappedNote(note),
      ),
  actions: <Widget>[
    new IconSlideAction(
      caption: 'Share',
      color: Colors.indigo,
      icon: Icons.share,
      onTap: () => _slidingButton('share', note),
    ),
    new IconSlideAction(
      caption: 'Delete',
      color: Colors.red,
      icon: Icons.delete,
      onTap: () => _slidingButton('delete', note),
    ),
  ],
  secondaryActions: <Widget>[
    new IconSlideAction(
      caption: 'Share',
      color: Colors.indigo,
      icon: Icons.share,
      onTap: () => _slidingButton('share', note),
    ),
    new IconSlideAction(
      caption: 'Delete',
      color: Colors.red,
      icon: Icons.delete,
      onTap: () => _slidingButton('delete', note),
    )]);
  }

void _slidingButton(String action, Note note) async {
  switch (action) {
    case 'share':
      Share.share(note.text);
      break;
    case 'delete':
      SQL.db.deleteNote(note);
      await _loadNotes();
      setState(() {
        bodyWidget =_getNotes();
      });
      break;
    default:
  }
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
      body: bodyWidget,
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'New note',
        child: Icon(Icons.add),
        foregroundColor: Theme.of(context).buttonColor,
      ),
    );
  }
}
