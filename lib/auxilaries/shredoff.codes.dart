  
  //For getting userslist through json  file 
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   dataAsIterable = {};
  //   getUserData();
  // }

  // Map<String, dynamic>? data;
  // dynamic dataAsIterable;
  // var texts;
  // var length;
  // List dataAsList = [];
  // List<String> users = [];

  // getUserData() async {
  //   var response = await http.get(Uri.parse(
  //       "https://interactive-talks-default-rtdb.firebaseio.com/usersData.json"));

  //   setState(() {
  //     data = json.decode(response.body);
  //     getDataAsList();
  //   });
  // }

  // getDataAsList() {
  //   if (data != null) {
  //     dataAsIterable = data!.values;

  //     to convert Iterable<dynamic> to List
  //     for (var element in dataAsIterable) {
  //       dataAsList.add(element);
  //     }
  //     length = dataAsList.length;
  //     if (length == 2 * dataAsIterable.length && dataAsIterable.length != 1) {
  //       dataAsList.removeRange((length / 2).toInt() - 1, length);
  //     } else if (length == 2 * dataAsIterable.length &&
  //         dataAsIterable.length == 1) {
  //       dataAsList.removeLast();
  //     }

  //     fill list of users
  //     for (var i = 0; i < length; i++) {
  //       users.add(dataAsList[i].keys.toString().replaceAllMapped(
  //           RegExp(r'[(\)]+'),
  //           (match) => "")); // toconvert into string and remove ()
  //     }
  //   }

  

//todo: implement delete the message
// onLongPress: () {
//   final snackBar = SnackBar(
//     content: Text("Do you want to delete this message?"),
//     action: SnackBarAction(
//         label: "Delete message",
//         onPressed: () {
//           context.read<MessageListCubit>().state.remove(context.read<MessageListCubit>().state.reversed.toList()[index]);

//           messages = context.read<MessageListCubit>().state.reversed.toList().reversed.toList();
//           if (context.read<MessageListCubit>().state.length == 0) {
//             context.read<MessageListCubit>().emitList([]);
//           } else {
//             context.read<MessageListCubit>().emitList(messages);
//           }
//         }),
//   );
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// },







//list.generate implementation:
// itemCount: (context.read<ReceivedMessagesCubit>().state.length + context.read<SentMessagesCubit>().state.length),
                              // itemBuilder: (context, index) {
                              // if (context.read<ReceivedIndexPointerCubit>().state >= 0 && context.read<InputIndexPointerCubit>().state >= 0) {
                              //   if (((context
                              //           .read<ReceivedMessagesCubit>()
                              //           .state
                              //           .keys
                              //           .elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1) <
                              //       context.read<SentMessagesCubit>().state.keys.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1)))) {
                              //     context.read<MessageCubit>().inputMessage(context
                              //         .read<ReceivedMessagesCubit>()
                              //         .state
                              //         .values
                              //         .elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1));
                              //     print(index);
                              //     print("block 3");
                              //     print(context
                              //         .read<ReceivedMessagesCubit>()
                              //         .state
                              //         .values
                              //         .elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1));
                              //     print(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1);
                              //     //  context.read<ReceivedIndexPointerCubit>().state = context.read<ReceivedIndexPointerCubit>().state - 1;
                              //     context.read<ReceivedIndexPointerCubit>().isReceivedIndexPointer(context.read<ReceivedIndexPointerCubit>().state - 1);
                              //     context.read<IsReceivedCubit>().messageIsReceivedOne();
                              //   }

                              //   // if (context.read<InputIndexPointerCubit>().state >= 0 && context.read<ReceivedIndexPointerCubit>().state >= 0)
                              //   else if (context.read<SentMessagesCubit>().state.keys.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1) <=
                              //       context
                              //           .read<ReceivedMessagesCubit>()
                              //           .state
                              //           .keys
                              //           .elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1)) {
                              //     List Msg = context.read<SentMessagesCubit>().state.values.toList();
                              //     context.read<MessageCubit>().inputMessage(Msg[context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1]);
                              //     print("block 4");
                              //     print(Msg);
                              //     print(index);
                              //     print(context.read<InputIndexPointerCubit>().state);
                              //     print(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1);

                              //     context.read<InputIndexPointerCubit>().isInputIndexPointer(context.read<InputIndexPointerCubit>().state - 1);
                              //     context.read<IsReceivedCubit>().messageIsSentOne();
                              //     print(context.read<InputIndexPointerCubit>().state);
                              //   }
                              // } else if (context.read<InputIndexPointerCubit>().state < 0 || context.read<ReceivedIndexPointerCubit>().state < 0) {
                              //   if (context.read<InputIndexPointerCubit>().state >= 0 && context.read<ReceivedIndexPointerCubit>().state < 0) {
                              //     print("block 1");
                              //     context.read<MessageCubit>().inputMessage(
                              //         context.read<SentMessagesCubit>().state.values.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1));
                              //     context.read<InputIndexPointerCubit>().isInputIndexPointer(context.read<InputIndexPointerCubit>().state - 1);
                              //     context.read<IsReceivedCubit>().messageIsSentOne();
                              //     print(index);

                              //     print(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1);
                              //   } else if (context.read<ReceivedIndexPointerCubit>().state >= 0 && context.read<InputIndexPointerCubit>().state < 0) {
                              //     print("block 2");
                              //     print(context
                              //         .read<ReceivedMessagesCubit>()
                              //         .state
                              //         .values
                              //         .elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1));

                              //     List Msg = context.read<ReceivedMessagesCubit>().state.values.toList();
                              //     context.read<MessageCubit>().inputMessage(Msg[context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1]);

                              //     print(index);
                              //     print(context.read<ReceivedIndexPointerCubit>().state);
                              //     print(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1);
                              //     context.read<ReceivedIndexPointerCubit>().isReceivedIndexPointer(context.read<ReceivedIndexPointerCubit>().state - 1);
                              //     context.read<IsReceivedCubit>().messageIsReceivedOne();
                              //     print(context.read<ReceivedIndexPointerCubit>().state);
                              //   }
                              // }

                              // return Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   padding: const EdgeInsets.only(bottom: 10.0),
                              //   height: 100,
                              //   child: ListView(
                              //     reverse: context.read<IsReceivedCubit>().state,
                              //     scrollDirection: Axis.horizontal,
                              //     children: [
                              //       //padding before Text

                              //       SizedBox(
                              //         width: 100,
                              //       ),

                              //       //todo: display message

                              //       Container(
                              //         alignment: Alignment.centerRight,
                              //         //gesture detector for snackbar
                              //         child: GestureDetector(
                              //           //todo: implement delete the message
                              //           // onLongPress: () {
                              //           //   final snackBar = SnackBar(
                              //           //     content: Text("Do you want to delete this message?"),
                              //           //     action: SnackBarAction(
                              //           //         label: "Delete message",
                              //           //         onPressed: () {
                              //           //           context.read<MessageListCubit>().state.remove(context.read<MessageListCubit>().state.reversed.toList()[index]);

                              //           //           messages = context.read<MessageListCubit>().state.reversed.toList().reversed.toList();
                              //           //           if (context.read<MessageListCubit>().state.length == 0) {
                              //           //             context.read<MessageListCubit>().emitList([]);
                              //           //           } else {
                              //           //             context.read<MessageListCubit>().emitList(messages);
                              //           //           }
                              //           //         }),
                              //           //   );
                              //           //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              //           // },
                              //           child: Card(
                              //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              //             elevation: 5.0,
                              //             surfaceTintColor: Colors.amberAccent,
                              //             color: const Color.fromARGB(255, 245, 137, 137),
                              //             child: Padding(
                              //               padding: EdgeInsets.all(10.0),
                              //               child: context.read<MessageCubit>().state == ""
                              //                   ? Container(
                              //                       width: 1,
                              //                       height: 1,
                              //                       decoration: backgroundGradient(),
                              //                     )
                              //                   : Text(
                              //                       context.read<MessageCubit>().state,
                              //                       style: const TextStyle(fontSize: 18.0),
                              //                     ),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // );
                              // },