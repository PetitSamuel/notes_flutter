import 'package:flutter/material.dart';
import 'dart:async';
import 'SQL.dart';
import 'model.dart';

class FormScreen extends StatefulWidget {
  final Note note;
  FormScreen({Key key, @required this.note}) : super(key: key);

  @override
  _FormScreen createState() => _FormScreen();
}

class _FormScreen extends State<FormScreen> {
  final TextEditingController _noteController = new TextEditingController();
  String note = "";
  static final GlobalKey<ScaffoldState> _formKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _setText();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        note = _noteController.text.trim();
        if ((note.isEmpty && widget.note.text.isEmpty)||
            (widget.note.text.isNotEmpty && note == widget.note.text)) {
          return true;
        } else {
          return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Do you want to save the note?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Save"),
                onPressed: () async {
                  await _saveNoteNoPop();
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text("Discard"),
                onPressed: () =>
                  Navigator.pop(context, true),
              ),
               FlatButton(
                child: Text("Cancel"),
                onPressed: () async {
                  Navigator.pop(context, false);
                },
              ),
            ])
          );
        }
      },
      child: Scaffold(
      backgroundColor: Colors.white,
        key: _formKey,
        appBar: AppBar(
          title: Text('Note editor'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.save_alt), onPressed: () async {await _saveNote();})
          ],

        ),
        body: SafeArea(
            child: ListView(
              children: <Widget>[
                 TextField(
                    autofocus: true,
                    autocorrect: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      hintText: "My New Note",
                      filled: true,
                    ),
                    controller: _noteController,
                  ),
              ],
            )
        )
      )
    );
  }

  void _setText () {
    _noteController.text = widget.note.text;
  }

  Future _saveNote() async {
    await _saveNoteNoPop();
    Navigator.pop(context, {'note' : widget.note});
  }

  Future _saveNoteNoPop() async {
    print("hi mark");
    if (widget.note.text != "") {
      widget.note.text =_noteController.text;
      widget.note.date = DateTime.now().toUtc();
      await SQL.db.updateById(widget.note);
    } else {
      Note note = new Note(text: _noteController.text, date: DateTime.now().toUtc());
      await SQL.db.insertNote(note);
    }
  }
}