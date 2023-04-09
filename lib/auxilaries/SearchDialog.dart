import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/Logic/CubitLogic.dart';
import 'package:chatapp/Logic/LogicMethods.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'Colors.dart';
import 'package:chatapp/Screens/Chat.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

createMessagesList(BuildContext context, String userName) {
  String Currentuser = context.read<GetUserName>().state;
  FirebaseDatabase.instance.ref("usersData/$Currentuser").child("messagesList/$userName/").set({"123": Currentuser});
  FirebaseDatabase.instance.ref("usersData/$userName").child("receivedList/$Currentuser/").set({"123": Currentuser});
  FirebaseDatabase.instance.ref("usersData/$userName").child("messagesList/$Currentuser/").set({"125": userName});
  FirebaseDatabase.instance.ref("usersData/$Currentuser").child("receivedList/$userName/").set({"125": userName});
  // FirebaseDatabase.instance.ref("usersData/$Currentuser").child("messagesList/$userName/").update({"124": userName});
  // FirebaseDatabase.instance.ref("usersData/$userName").child("messagesList/$Currentuser/").update({"126": Currentuser});
}

getMessagesList(BuildContext context, String currentUser, String receiver) async {
  await context.read<SentMessagesCubit>().getSentMessagesList(currentUser, receiver);
  await context.read<ReceivedMessagesCubit>().getSentMessagesList(receiver, currentUser);
}

//(context.read<GetUserDataCubit>().state["messagesList"] as dynamic) ==null

showSearchDialog(BuildContext context, List users) {
  //transparent AlertDialog
  TextEditingController searchEditingController = TextEditingController();

  showAnimatedDialog(
      barrierDismissible: true,
      animationType: DialogTransitionType.slideFromBottomFade,
      curve: Curves.ease,
      duration: const Duration(milliseconds: 800),
      barrierColor: const Color.fromARGB(192, 0, 0, 0),
      context: context,
      builder: ((context) {
        List listToBeDisplayed = [];
        bool isTyping = false;
        context.read<GetUsersListCubit>().getSnapshotValue();
        Color color = const Color.fromARGB(151, 16, 15, 15);
        context.read<GetUserDataCubit>().getSnapshotValue(context.read<GetUserName>().state);

        return AlertDialog(
            shape: RoundedRectangleBorder(side: BorderSide(color: colors1[9]), borderRadius: BorderRadius.circular(40.0)),
            contentPadding: const EdgeInsets.all(0),
            alignment: Alignment.center,
            elevation: 20.0,
            backgroundColor: color,
            actions: [
              Container(
                color: const Color.fromARGB(0, 229, 221, 221),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(elevation: 10.0),
                        onPressed: () {
                          listToBeDisplayed = [];
                          searchEditingController.text = "";
                          Navigator.pop(context);
                        },
                        child: const Text("Back"),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(4.0),
                    //   child: ElevatedButton(
                    //     onPressed: (() {}),
                    //     child: Text("Search"),
                    //     style: ElevatedButton.styleFrom(elevation: 10.0),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
            content: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const ClampingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(40.0), color: color),
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //input search field
                      TextField(
                        maxLength: 14,
                        autofocus: true,
                        maxLines: 1,

                        onChanged: (value) {
                          isTyping = true;
                          context.read<InputSearchCubit>().startInputing(searchEditingController.text);
                          print(users);
                          print(context.read<InputSearchCubit>().state);
                          print(listToBeDisplayed);

                          searchForUsers(context, users, listToBeDisplayed);
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: colors1[4]),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.all(10.0),
                          hintText: "Search Users",
                          hintStyle: TextStyle(
                            color: colors1[6],
                          ),
                          focusColor: colors1[9],
                        ),
                        style: TextStyle(color: colors1[6]), //inputTextColor
                        controller: searchEditingController,
                      ),
                      BlocBuilder<InputSearchCubit, String>(
                        builder: (context, state) {
                          chatUsers = getListOfUsersInMessagesList(context);

                          print("Chat users: $chatUsers");
                          return SizedBox(
                            height: (context.read<InputSearchCubit>().state == "" || isTyping == false) ? 40 : 400,
                            width: 300,
                            child: context.read<InputSearchCubit>().state == ""
                                ? Container()
                                : SingleChildScrollView(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: listToBeDisplayed.length,
                                        itemBuilder: ((context, index) {
                                          return Container(
                                            height: 50,
                                            width: 300,
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.topCenter,
                                            child: Hero(
                                              tag: "chat",
                                              transitionOnUserGestures: true,
                                              child: GestureDetector(
                                                behavior: HitTestBehavior.translucent, //to detect tap on whole container
                                                onTap: (() {
                                                  Navigator.pop(context);

                                                  if (chatUsers.contains(listToBeDisplayed[index]) == false) {
                                                    createMessagesList(context, listToBeDisplayed[index]);
                                                  }

                                                  //todo: Always open chat like this:-
                                                  context.read<SentMessagesCubit>().getSentMessagesList(context.read<GetUserName>().state, listToBeDisplayed[index]);
                                                  context.read<ReceivedMessagesCubit>().getSentMessagesList(listToBeDisplayed[index], context.read<GetUserName>().state);

                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(builder: ((context) => Chat(listToBeDisplayed[index]))),
                                                  );
                                                }),
                                                child: BlocBuilder<GetUserDataCubit, dynamic>(
                                                  builder: (context, state) {
                                                    return Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        CircleAvatar(
                                                          child: Image.asset(
                                                            "assets/defaultprofile.png",
                                                            alignment: Alignment.centerLeft,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 50,
                                                          width: 30,
                                                        ),
                                                        Text(
                                                          listToBeDisplayed[index],
                                                          style: TextStyle(color: colors1[6], fontSize: 15.0),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        })),
                                  ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ));
      }));
}
