import 'dart:convert';

Note noteFromJson(String str) {
    final jsonData = json.decode(str);
    return Note.fromJson(jsonData);
}

String noteToJson(Note data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

class Note {
    int id;
    String text;
    DateTime date;

    Note({
        this.id,
        this.text,
        this.date
    });

    factory Note.fromJson(Map<String, dynamic> json) => new Note(
        id: json["id"],
        text: json["note"],
        date: new DateTime.fromMillisecondsSinceEpoch(json["date"] * 1000)
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date": (date.millisecondsSinceEpoch / 1000).round(),
        "note": text,
    };
}