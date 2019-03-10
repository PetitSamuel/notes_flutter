import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'dart:async';
import 'dart:io';
import 'File.dart';

class FormScreen extends StatefulWidget {
  @override
  State createState() => _FormScreen();
}

class _FormScreen extends State<FormScreen> {

  final TextEditingController _noteController = new TextEditingController(text: globals.currentNote);
  String note = "";
  static final GlobalKey<ScaffoldState> _formKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
      backgroundColor: Colors.white,
        key: _formKey,
        appBar: AppBar(
          title: Text('Transaction Details'),
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

  Future _saveNote() async {
    if (globals.currentNote != "") {
      globals.notes = await CounterStorage.removeNote(globals.currentNote);
    }
    await _addReviewToFile();
    Navigator.pop(context);
  }

  Future _saveNoteNoPop() async {
    if (globals.currentNote != "") {
      globals.notes = await CounterStorage.removeNote(globals.currentNote);
    }
    // if current is not set, just do that
    await _addReviewToFile();

    // if current is set then
    // delete from file & from list + add new one
  }

  Future<File> _addReviewToFile() async {
    setState(() {
      note = _noteController.text.trim();
      if(note.isEmpty) {
        Navigator.pop(context);
        return null;
      }
      if (globals.notes == null || globals.notes.isEmpty) {
        globals.notes = <String>[note];
      } else {
        globals.notes.add(note);
      }
    });

    // Write the variable as a string to the file.
    return await CounterStorage.writeNote(note);
  }

  Future<bool> _onBackPressed() {
    note = _noteController.text.trim();
    if ((note.isEmpty && globals.currentNote == "" )||
        (globals.currentNote.isNotEmpty && note == globals.currentNote)) {
      Navigator.pop(context, true);
    }
    else {
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
                onPressed: () => Navigator.pop(context, true),
              )
            ],

          )
      );
    }
  }
}