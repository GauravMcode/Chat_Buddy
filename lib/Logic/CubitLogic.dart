import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:collection';

//Cubits for chat page UI
//1
class MessageListCubit extends Cubit<List> {
  MessageListCubit() : super([]);

  deleteMessageFromList(List list, int index) {
    list.removeAt(index);
    emit(list);
  }

  addMessageToList(List list, String message) {
    list.add(message);
    emit(list);
  }

  emitList(List list) {
    emit(list);
  }
}

//2
class MessageCubit extends Cubit<String> {
  MessageCubit() : super("");

  inputMessage(message) {
    emit(message);
  }
}

//Cubit for checking authentication
class AuthCubit extends Cubit<bool> {
  AuthCubit() : super(false);

  authSignin() => emit(true);
  authSignout() => emit(false);
}

//users search input cubit
class InputSearchCubit extends Cubit<String> {
  InputSearchCubit() : super("");

  startInputing(String text) {
    emit(text);
  }

  stopInputing() => emit("");
}

//Get userData of a specific user from firebase
class GetUserDataCubit extends Cubit<dynamic> {
  GetUserDataCubit() : super({});
  getSnapshotValue(user) async {
    FirebaseDatabase.instance.ref("usersData").child("$user").onValue.listen((DatabaseEvent event) {
      dynamic Event = event.snapshot.value;
      emit(Event);
    });
  }

  resetCubit() {
    emit({});
  }
}

//get list of all users
class GetUsersListCubit extends Cubit<List> {
  GetUsersListCubit() : super([]);
  List usersList = [];

  getSnapshotValue() async {
    FirebaseDatabase.instance.ref("usersData").onValue.listen((DatabaseEvent event) {
      dynamic Event = event.snapshot.value;
      // to convert Iterable<dynamic> to List
      if (Event != null) {
        for (var element in Event.keys) {
          usersList.add(element.toString().replaceAllMapped(RegExp(r'[(\)]+'), (match) => ""));
        }
      }
      //fill list of users
      // for (var i = 0; i < length; i++) {
      //   users.add(dataAsList[i].keys.); // toconvert into string and remove ()
      // }
      emit(usersList);
      usersList = [];
    });
  }
}

//current user
class GetUserName extends Cubit<String> {
  GetUserName() : super("");

  gotUserName(String userName) {
    emit(userName);
  }
}

//cubits for sent and receive messages list
class SentMessagesCubit extends Cubit<Map> {
  SentMessagesCubit() : super({});

  getSentMessagesList(sender, receiver) async {
    FirebaseDatabase.instance.ref("usersData").child("$sender/messagesList/$receiver").onValue.listen((DatabaseEvent event) {
      dynamic Event = event.snapshot.value;
      Map toBeSorted = {};
      for (dynamic element in Event.keys) {
        toBeSorted[int.parse(element)] = Event[element];
      }
      //to sort the map
      var sortedByKeyMap = SplayTreeMap<int, String>.from(toBeSorted, (k1, k2) => k1.compareTo(k2));
      emit(sortedByKeyMap);
    });
  }

  emptySentMessages() {
    emit({});
  }
}

class ReceivedMessagesCubit extends Cubit<Map> {
  ReceivedMessagesCubit() : super({});

  getSentMessagesList(sender, receiver) async {
    FirebaseDatabase.instance.ref("usersData").child("$sender/messagesList/$receiver").onValue.listen((DatabaseEvent event) {
      dynamic Event = event.snapshot.value;
      Map toBeSorted = {};
      for (dynamic element in Event.keys) {
        toBeSorted[int.parse(element)] = Event[element];
      }
      //to sort the map
      var sortedByKeyMap = SplayTreeMap<int, String>.from(toBeSorted, (k1, k2) => k1.compareTo(k2));
      emit(sortedByKeyMap);
    });
  }

  emptyRecievedMessages() {
    emit({});
  }
}

//bool state cubit to determine direction of text
class IsReceivedCubit extends Cubit<bool> {
  IsReceivedCubit() : super(false);

  messageIsSentOne() {
    emit(false);
  }

  messageIsReceivedOne() {
    emit(true);
  }
}

//to point to the index of each list individually
class InputIndexPointerCubit extends Cubit<int> {
  InputIndexPointerCubit() : super(0);

  isInputIndexPointer(int index) {
    emit(index);
  }
}

class ReceivedIndexPointerCubit extends Cubit<int> {
  ReceivedIndexPointerCubit() : super(0);

  isReceivedIndexPointer(int index) {
    emit(index);
  }
}

//to get date and time from key value of messages
class DateTimeCubit extends Cubit<DateTime> {
  DateTimeCubit() : super(DateTime.now());

  setDateTime(milliseconds) {
    emit(DateTime.fromMillisecondsSinceEpoch(milliseconds));
  }
}

//to keeep track of date
class DateCubit extends Cubit<String> {
  DateCubit() : super("");

  checkDateChange(DateTime dateTime, BuildContext context) {
    String date = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
    if (date != state) {
      context.read<IsDateChangedCubit>().dateHasChanged(true);
      emit(date);
    } else {
      context.read<IsDateChangedCubit>().dateHasChanged(false);
    }
  }
}

class IsDateChangedCubit extends Cubit<bool> {
  IsDateChangedCubit() : super(false);

  dateHasChanged(bool isChanged) {
    emit(isChanged);
  }
}










//Cubit for getting userList from firebase

// class GetUsersListCubit extends Cubit<List> {
//   GetUsersListCubit() : super([]);

//   getUserData() async {
//     List<String> users = [];
//     List dataAsList = [];
//     Map<String, dynamic>? data;
//     dynamic dataAsIterable;
//     var texts;
//     var length;

//     var response = await http.get(Uri.parse(
//         "https://interactive-talks-default-rtdb.firebaseio.com/usersData.json"));

//     data = await json.decode(response.body);

//     if (data != null) {
//       dataAsIterable = data.values;

//       //to convert Iterable<dynamic> to List
//       for (var element in dataAsIterable) {
//         dataAsList.add(element);
//       }
//       length = dataAsList.length;
//       if (length == 2 * dataAsIterable.length && dataAsIterable.length != 1) {
//         dataAsList.removeRange((length / 2).toInt() - 1, length);
//       } else if (length == 2 * dataAsIterable.length &&
//           dataAsIterable.length == 1) {
//         dataAsList.removeLast();
//       }

//fill list of users
//       for (var i = 0; i < length; i++) {
//         users.add(dataAsList[i].keys.toString().replaceAllMapped(
//             RegExp(r'[(\)]+'),
//             (match) => "")); // toconvert into string and remove ()
//       }
//       emit(users);
//     }
//   }
// }
