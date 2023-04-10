import 'package:chatapp/auxilaries/Colors.dart';
import 'package:chatapp/Logic/CubitLogic.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chatapp/Logic/LogicMethods.dart';

String currentUser = "";
List chatUsers = [];
bool isDateChanged = false;

class Chat extends StatefulWidget {
  String receiverName;
  String image;
  Chat(this.receiverName, this.image, {super.key});

  @override
  State<Chat> createState() => _ChatState(receiverName, image);
}

//todo: the current user will save the typed messaged into its own sentList(messagesList) & then access it as well as the sentList of Receiver

class _ChatState extends State<Chat> with AutomaticKeepAliveClientMixin {
  String receiverName;
  String image;
  _ChatState(this.receiverName, this.image);
  List<Color> heartColorList = [Colors.white, Colors.red];
  var heartColor = Colors.white;
  TextEditingController inputMessage = TextEditingController();
  ValueNotifier<String> imageString = ValueNotifier('');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<InputSearchCubit>().stopInputing();
    currentUser = context.read<GetUserName>().state;
    if (image == '') {
      getImage();
    }
  }

  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    context.read<GetUserDataCubit>().getSnapshotValue(context.read<GetUserName>().state);
    chatUsers = getListOfUsersInMessagesList(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          ValueListenableBuilder(
              valueListenable: imageString,
              builder: (context, value, child) {
                print(value);
                return CircleAvatar(
                  maxRadius: 14,
                  foregroundImage: image != ''
                      ? Image.network(image).image
                      : value == ''
                          ? Image.asset(
                              "assets/defaultprofile.png",
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.cover,
                            ).image
                          : Image.network(value).image,
                );
              }),
          const Padding(padding: EdgeInsets.only(left: 8.0)),
          IconButton(
            onPressed: (() {
              setState(() {
                heartColor = heartColor == heartColorList[0] ? heartColorList[1] : heartColorList[0];
              });
            }),
            iconSize: 28,
            icon: const Icon(Icons.favorite),
            color: heartColor,
          ),
        ],
        title: Text(receiverName),
        elevation: 5.0,
      ),
      body: Hero(
        tag: "chat",
        transitionOnUserGestures: true,
        child: Container(
          decoration: backgroundGradient(),
          child: Column(
            children: [
              BlocBuilder<SentMessagesCubit, Map>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  return BlocBuilder<ReceivedMessagesCubit, Map>(
                    buildWhen: (previous, current) => current != previous,
                    builder: (context, state) {
                      return Flexible(
                        // fit: FlexFit.loose,
                        flex: 15,
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Builder(builder: (context) {
                            super.build(context);

                            if (context.read<ReceivedMessagesCubit>().state.keys.isNotEmpty) {
                              FirebaseDatabase.instance.ref("usersData/$currentUser").child("receivedReadPointers/$receiverName").set(context.read<ReceivedMessagesCubit>().state.keys.last);
                            } //to set the pointer to read message
                            isDateChanged = false;
                            context.read<MessageCubit>().inputMessage("");
                            context.read<InputIndexPointerCubit>().isInputIndexPointer(context.read<SentMessagesCubit>().state.length - 1);
                            context.read<ReceivedIndexPointerCubit>().isReceivedIndexPointer(context.read<ReceivedMessagesCubit>().state.length - 1);
                            return ListView(
                              controller: _scrollController1,
                              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

                              // reverse: true, //to move to bottom of the chat
                              dragStartBehavior: DragStartBehavior.down,
                              children: listofWidgets(context, currentUser, receiverName),
                            );
                          }),
                        ),
                      );
                    },
                  );
                },
              ),
              Flexible(
                fit: FlexFit.loose,
                // ignore: sort_child_properties_last
                child: Row(
                  children: [
                    const Flexible(flex: 1, fit: FlexFit.loose, child: Padding(padding: EdgeInsets.all(40.0))),
                    //todo: Writing bloc for msg:
                    Flexible(
                      flex: 8,
                      fit: FlexFit.tight,
                      child: SizedBox(
                        width: 200.0,
                        height: 200.0,
                        child: TextField(
                          // autofocus: true,
                          clipBehavior: Clip.antiAlias,
                          scrollController: _scrollController2,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 10,
                          onTap: () {
                            _scrollController1.animateTo(_scrollController1.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
                          },
                          onChanged: (value) {
                            _scrollController2.animateTo(_scrollController1.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);

                            context.read<InputSearchCubit>().startInputing(inputMessage.text);
                          },
                          showCursor: true,
                          dragStartBehavior: DragStartBehavior.down,
                          controller: inputMessage,
                          enableInteractiveSelection: true,
                          decoration: InputDecoration(
                              constraints: const BoxConstraints.expand(height: 500),
                              contentPadding: const EdgeInsets.all(10.0),
                              label: const Text("Type message"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              )),
                        ),
                      ),
                    ),

                    //todo: Send  Button

                    Builder(builder: (context) {
                      //to move to bottom as soon as chat opens:
                      WidgetsBinding.instance.addPostFrameCallback((_) => {_scrollController1.jumpTo(_scrollController1.position.maxScrollExtent)});
                      return Container(
                        color: const Color.fromARGB(0, 255, 255, 255),
                        alignment: Alignment.topRight,
                        child: RawMaterialButton(
                          padding: const EdgeInsets.all(10.0),
                          fillColor: colors1[0],
                          onPressed: () {
                            DateTime dateTime = DateTime.now();
                            String sendTime = "${dateTime.millisecondsSinceEpoch}";
                            if (context.read<InputSearchCubit>().state != "") {
                              //TO DISMISS KEYBOARD
                              FocusManager.instance.primaryFocus?.unfocus();
                              //To scroll to bottom
                              _scrollController1.animateTo(_scrollController1.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);

                              //   // context.read<MessageListCubit>().addMessageToList(messages, Message);
                              sendtheMessage(context.read<InputSearchCubit>().state, context.read<GetUserName>().state, receiverName, sendTime);

                              // // context.read<MessageCubit>().inputMessage(Message);
                              //TO CLEAR TEXTCONTROLLER
                              inputMessage.clear();

                              context.read<InputSearchCubit>().stopInputing();

                              // // Message = "";
                            }
                          },
                          shape: const CircleBorder(),
                          elevation: 5.0,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Icon(
                              Icons.send,
                              size: 30.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    })
                  ],
                ),
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
  // function to send message to messagesList of current user of app

  sendtheMessage(String message, String sender, String receiver, String timeasMillisecondsepoch) async {
    FirebaseDatabase.instance.ref("usersData/$sender/messagesList/$receiver/").update({timeasMillisecondsepoch: message});
    FirebaseDatabase.instance.ref("usersData/$receiver/receivedList/$sender/").update({timeasMillisecondsepoch: message});
  }

  createMessagesList(BuildContext context, String userName) {
    String currentUser = context.read<GetUserName>().state;
    FirebaseDatabase.instance.ref("usersData/$currentUser").child("messagesList/$userName/").set({"123": "Say hii to $userName"});
    FirebaseDatabase.instance.ref("usersData/$userName").child("messagesList/$currentUser/").set({"125": "Say hii to $currentUser"});
  }

  getMessagesList(BuildContext context, String currentUser, String receiver) async {
    await context.read<SentMessagesCubit>().getSentMessagesList(currentUser, receiver);
    await context.read<ReceivedMessagesCubit>().getSentMessagesList(receiver, currentUser);
  }

  getImage() {
    String image = '';
    FirebaseDatabase.instance.ref("usersData").child(receiverName).onValue.listen((DatabaseEvent event) {
      imageString.value = (event.snapshot.value as Map)['photoUrl'];
    });
  }
}

// To generate list of widgets of text
List<Widget> listofWidgets(BuildContext context, userName, receiverName) {
  int length = context.read<ReceivedMessagesCubit>().state.length + context.read<SentMessagesCubit>().state.length;
  List<Widget> list = List.generate(
    length,
    (index) {
      if (context.read<ReceivedIndexPointerCubit>().state >= 0 && context.read<InputIndexPointerCubit>().state >= 0) {
        if (((context.read<ReceivedMessagesCubit>().state.keys.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1) <
            context.read<SentMessagesCubit>().state.keys.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1)))) {
          context
              .read<MessageCubit>()
              .inputMessage(context.read<ReceivedMessagesCubit>().state.values.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1));
          if (context.read<ReceivedMessagesCubit>().state.keys.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1) > 1000) {
            context
                .read<DateTimeCubit>()
                .setDateTime(context.read<ReceivedMessagesCubit>().state.keys.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1));
          }

          //  context.read<ReceivedIndexPointerCubit>().state = context.read<ReceivedIndexPointerCubit>().state - 1;
          context.read<ReceivedIndexPointerCubit>().isReceivedIndexPointer(context.read<ReceivedIndexPointerCubit>().state - 1);
          context.read<IsReceivedCubit>().messageIsReceivedOne();
        }

        // if (context.read<InputIndexPointerCubit>().state >= 0 && context.read<ReceivedIndexPointerCubit>().state >= 0)
        else if (context.read<SentMessagesCubit>().state.keys.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1) <=
            context.read<ReceivedMessagesCubit>().state.keys.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1)) {
          List Msg = context.read<SentMessagesCubit>().state.values.toList();
          context.read<MessageCubit>().inputMessage(Msg[context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1]);
          if (context.read<SentMessagesCubit>().state.keys.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1) > 1000) {
            context
                .read<DateTimeCubit>()
                .setDateTime(context.read<SentMessagesCubit>().state.keys.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1));
          }

          context.read<InputIndexPointerCubit>().isInputIndexPointer(context.read<InputIndexPointerCubit>().state - 1);
          context.read<IsReceivedCubit>().messageIsSentOne();
        }
      } else if (context.read<InputIndexPointerCubit>().state < 0 || context.read<ReceivedIndexPointerCubit>().state < 0) {
        if (context.read<InputIndexPointerCubit>().state >= 0 && context.read<ReceivedIndexPointerCubit>().state < 0) {
          context
              .read<MessageCubit>()
              .inputMessage(context.read<SentMessagesCubit>().state.values.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1));
          if (context.read<SentMessagesCubit>().state.keys.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1) > 1000) {
            context
                .read<DateTimeCubit>()
                .setDateTime(context.read<SentMessagesCubit>().state.keys.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1));
          }
          context.read<InputIndexPointerCubit>().isInputIndexPointer(context.read<InputIndexPointerCubit>().state - 1);
          context.read<IsReceivedCubit>().messageIsSentOne();
        } else if (context.read<ReceivedIndexPointerCubit>().state >= 0 && context.read<InputIndexPointerCubit>().state < 0) {
          List Msg = context.read<ReceivedMessagesCubit>().state.values.toList();
          context.read<MessageCubit>().inputMessage(Msg[context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1]);
          if (context.read<ReceivedMessagesCubit>().state.keys.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1) > 1000) {
            context
                .read<DateTimeCubit>()
                .setDateTime(context.read<ReceivedMessagesCubit>().state.keys.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1));
          }

          context.read<ReceivedIndexPointerCubit>().isReceivedIndexPointer(context.read<ReceivedIndexPointerCubit>().state - 1);
          context.read<IsReceivedCubit>().messageIsReceivedOne();
        }
      }
      context.read<DateCubit>().checkDateChange(context.read<DateTimeCubit>().state, context);

      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            context.read<IsDateChangedCubit>().state
                ? Container(
                    child: Text(
                      context.read<DateCubit>().state,
                      style: TextStyle(color: colors1[0], fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(),
            Row(
              children: context.read<IsReceivedCubit>().state
                  ? [
                      //todo: display message
                      Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          elevation: 5.0,
                          surfaceTintColor: Colors.amberAccent,
                          color: const Color.fromARGB(255, 185, 182, 182),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: context.read<MessageCubit>().state != currentUser && context.read<MessageCubit>().state != receiverName
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.read<MessageCubit>().state,
                                        style: const TextStyle(fontSize: 20.0),
                                      ),
                                      const Padding(padding: EdgeInsets.only(bottom: 5.0)),
                                      Text(
                                        "${context.read<DateTimeCubit>().state.hour} : ${context.read<DateTimeCubit>().state.minute}",
                                        style: TextStyle(fontSize: 12.0, color: colors1[1]),
                                        textAlign: TextAlign.end,
                                      )
                                    ],
                                  )
                                : Text(
                                    context.read<MessageCubit>().state,
                                    style: const TextStyle(fontSize: 18.0),
                                  ),
                          ),
                        ),
                      ),
                      //padding after Text
                      const Flexible(
                        fit: FlexFit.tight,
                        child: SizedBox(),
                      ),
                    ]
                  : [
                      //padding before Text
                      const Flexible(
                        fit: FlexFit.tight,
                        child: SizedBox(),
                      ),
                      //todo: display message
                      Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          elevation: 5.0,
                          surfaceTintColor: Colors.amberAccent,
                          color: const Color.fromARGB(255, 15, 156, 226),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: context.read<MessageCubit>().state != currentUser && context.read<MessageCubit>().state != receiverName
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.read<MessageCubit>().state,
                                        style: const TextStyle(fontSize: 20.0),
                                      ),
                                      const Padding(padding: EdgeInsets.only(bottom: 5.0)),
                                      Text(
                                        "${context.read<DateTimeCubit>().state.hour} : ${context.read<DateTimeCubit>().state.minute}",
                                        style: TextStyle(fontSize: 12.0, color: colors1[1]),
                                        textAlign: TextAlign.end,
                                      )
                                    ],
                                  )
                                : Text(
                                    context.read<MessageCubit>().state,
                                    style: const TextStyle(fontSize: 18.0),
                                  ),
                          ),
                        ),
                      ),
                    ],
            ),
          ],
        ),
      );
    },
  );
  return list;
}
