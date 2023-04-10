import 'package:chatapp/Logic/LogicMethods.dart';
import 'package:chatapp/auxilaries/Colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chatapp/Logic/CubitLogic.dart';

class Calls extends StatefulWidget {
  const Calls({super.key});

  @override
  State<Calls> createState() => _CallsState();
}

class _CallsState extends State<Calls> {
  List listofChatUsers = [];
  ValueNotifier<Map<String, String>> imagesMap = ValueNotifier(<String, String>{});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GetUserDataCubit>().getSnapshotValue(context.read<GetUserName>().state);
    listofChatUsers = getListOfUsersInMessagesList(context);
  }

  // navigateToChat() {
  //   Navigator.of(context).push(MaterialPageRoute(builder: ((context) => Chat("hello_1"))));
  // }

  @override
  Widget build(BuildContext context) {
    imagesMap.value = getImagesList(listofChatUsers);

    return BlocBuilder<GetUserDataCubit, dynamic>(
      builder: (context, state) {
        listofChatUsers = getListOfUsersInMessagesList(context);
        context.read<GetUserDataCubit>().getSnapshotValue(context.read<GetUserName>().state);

        return Scaffold(
            body: listofChatUsers.isEmpty || context.read<GetUserDataCubit>().state["receivedList"] == null
                ? Container(
                    decoration: backgroundGradient(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(
                          child: Text(
                            "click on Search to find a new friend",
                            style: TextStyle(color: colors1[1]),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 40.0)),
                      ],
                    ),
                  )
                : Container(
                    decoration: backgroundGradient(),
                    child: ListView(
                      children: List.generate(listofChatUsers.length, (index) {
                        listofChatUsers = getListOfUsersInMessagesList(context);

                        // to get latest sent message time:
                        dynamic Smessages = (context.read<GetUserDataCubit>().state["messagesList"][listofChatUsers[index]] as dynamic).keys;
                        List msgSentListKeys = [];
                        Smessages.forEach((element) {
                          msgSentListKeys.add(int.parse(element));
                        });
                        msgSentListKeys.sort();
                        int maxSentTime = msgSentListKeys.last;

                        // to get latest received message time:
                        dynamic Rmessages = (context.read<GetUserDataCubit>().state["receivedList"][listofChatUsers[index]] as dynamic)?.keys;

                        List msgReceivedListKeys = [];
                        int maxReceivedTime = 0;
                        if (Rmessages != null) {
                          Rmessages.forEach((element) {
                            msgReceivedListKeys.add(int.parse(element));
                          });
                          msgReceivedListKeys.sort();
                          maxReceivedTime = msgReceivedListKeys.last;
                        }
                        dynamic dateTime;

                        String lastMessage = "";
                        num notReadcount = 0;
                        if (maxSentTime > maxReceivedTime) {
                          lastMessage = context.read<GetUserDataCubit>().state["messagesList"][listofChatUsers[index]]["$maxSentTime"];
                          dateTime = DateTime.fromMillisecondsSinceEpoch(maxSentTime);
                        } else {
                          lastMessage = context.read<GetUserDataCubit>().state["receivedList"][listofChatUsers[index]]["$maxReceivedTime"];
                          dateTime = DateTime.fromMillisecondsSinceEpoch(maxReceivedTime);

                          if (context.read<GetUserDataCubit>().state["receivedReadPointers"] != null) {
                            if (context.read<GetUserDataCubit>().state["receivedReadPointers"][listofChatUsers[index]] != null &&
                                context.read<GetUserDataCubit>().state["receivedReadPointers"][listofChatUsers[index]] < maxReceivedTime) {
                              notReadcount = msgReceivedListKeys.length - msgReceivedListKeys.indexOf(context.read<GetUserDataCubit>().state["receivedReadPointers"][listofChatUsers[index]]) - 1;
                            }
                          }
                        }
                        return ListTile(
                          leading: ValueListenableBuilder(
                              valueListenable: imagesMap,
                              builder: (context, value, child) {
                                return CircleAvatar(
                                  radius: 30,
                                  foregroundImage: value.isEmpty
                                      ? Image.asset(
                                          'assets/defaultprofile.png',
                                          alignment: Alignment.centerLeft,
                                          fit: BoxFit.contain,
                                        ).image
                                      : value.length <= index
                                          ? Image.asset(
                                              'assets/defaultprofile.png',
                                              alignment: Alignment.centerLeft,
                                              fit: BoxFit.contain,
                                            ).image
                                          : value[listofChatUsers[index]] == null || value[listofChatUsers[index]] == ''
                                              ? Image.asset(
                                                  'assets/defaultprofile.png',
                                                  alignment: Alignment.centerLeft,
                                                  fit: BoxFit.contain,
                                                ).image
                                              : Image.network(
                                                  value[listofChatUsers[index]]!,
                                                  alignment: Alignment.centerLeft,
                                                  fit: BoxFit.contain,
                                                ).image,
                                );
                              }),
                          trailing: SizedBox(
                            width: 100,
                            height: 200,
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.call,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                          title: Text(listofChatUsers[index].toString()),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${dateTime.day}/${dateTime.month}/${dateTime.year}"),
                              Text("${dateTime.hour} : ${dateTime.minute}"),
                            ],
                          ),
                          onTap: () {},
                        );
                      }),
                    )));
      },
    );
  }

  Map<String, String> getImagesList(List chatUsersList) {
    Map<String, String> imageList = {};
    for (var element in chatUsersList) {
      FirebaseDatabase.instance.ref("usersData").child("$element").onValue.listen((DatabaseEvent event) {
        imageList[element] = "${(event.snapshot.value as Map)['photoUrl']}";
      });
    }
    return imageList;
  }
}
