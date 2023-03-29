import 'package:flutter/material.dart';

import 'CubitLogic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Search users Logic

//todo: Try implementing with list of list of chars instead of list of strings

searchForUsers(BuildContext context, List users, List listToBeDisplay) {
  users.remove(context.read<GetUserName>().state);
  var listnew = [];
  List characterList = [];
  var char2List = [];
  bool hasValue = false;

  for (String element in users) {
    for (var rune in element.runes) {
      var character = String.fromCharCode(rune);
      characterList.add(character);
    }

    context.read<InputSearchCubit>().state.runes.forEach((int rune2) {
      var char2 = String.fromCharCode(rune2);
      char2List.add(char2);
    });

    for (var element1 in char2List) {
      if (characterList.contains(element1)) {
        hasValue = true;
      } else if (characterList.contains(element1) == false && listToBeDisplay.contains(element) == true) {
        hasValue = false;
        listToBeDisplay.remove(element);
        break;
      }
    }
    if (hasValue == false) {
      continue;
    }

    if (context.read<InputSearchCubit>().state.length > element.length && listToBeDisplay.contains(element)) {
      listToBeDisplay.remove(element);
    }
    if (context.read<InputSearchCubit>().state == element) {
      listToBeDisplay = [element];
    }

    if (hasValue == true && listToBeDisplay.contains(element) == false && context.read<InputSearchCubit>().state.length <= element.length) {
      listnew.add(element);
    } else if (hasValue == false) {
      listnew.remove(element);
    }
  }

  if (users.contains(context.read<InputSearchCubit>().state)) {
    listToBeDisplay = [context.read<InputSearchCubit>().state];
  }

  if (context.read<InputSearchCubit>().state == "") {
    listnew = [];
    listToBeDisplay = [];
  }

  if (listnew != [] && context.read<InputSearchCubit>().state != "") {
    for (var element in listnew) {
      listToBeDisplay.add(element);
    }
  }
}

//search if chat with user exists
List getListOfUsersInMessagesList(BuildContext context) {
  List usersList = [];
  Map usersTobeSorted = {};

  if (context.read<GetUserDataCubit>().state["messagesList"] != "" && context.read<GetUserDataCubit>().state["messagesList"] != null) {
    for (String element in (context.read<GetUserDataCubit>().state["messagesList"] as dynamic).keys) {
      usersList.add(element);
      // print("user had chat with $element");
    }
    // usersList.forEach((element) { });
    return usersList;
  }
  return [];
}
// .toString().replaceAllMapped(RegExp(r'[(\)]+'), (match) => ""));