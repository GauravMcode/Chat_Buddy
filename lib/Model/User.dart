//Todo:  userName SentMessages[map<time:textmessage>];

import 'package:firebase_database/firebase_database.dart';

class UserData {
  String _userName = "";
  List _sentMessagesList = [];

//getter and setters

  get userName => _userName;

  set userName(value) => _userName = value;

  get sentMessagesList => _sentMessagesList;

  set sentMessagesList(value) => _sentMessagesList = value;

//constructor:
  UserData(this._userName, this._sentMessagesList);

  UserData.fromSnapshot(DataSnapshot dataSnapshot) {
    _userName = dataSnapshot.key.toString();
    _sentMessagesList = (dataSnapshot.value as dynamic)["sentMessagesList"];
  }

  Map toJson() {
    return {"sentMessagesList": _sentMessagesList};
  }
}
