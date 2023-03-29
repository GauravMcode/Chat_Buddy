// import 'package:chatapp/auxilaries/Colors.dart';
// import 'package:chatapp/Logic/CubitLogic.dart';
// import 'package:chatapp/Screens/messageList.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// List messages = [];
// String Message = "";
// String deletedMessage = "";

// class Chat extends StatefulWidget {
//   String userName;
//   Chat(this.userName);

//   @override
//   State<Chat> createState() => _ChatState(this.userName);
// }

// class _ChatState extends State<Chat> {
//   String userName;
//   _ChatState(this.userName);
//   List<Color> heartColorList = [Colors.white, Colors.red];
//   var heartColor = Colors.white;
//   TextEditingController inputMessage = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MessageCubit, String>(
//       builder: (context, Messagestate) {
//         return BlocBuilder<MessageListCubit, List>(
//           builder: (context, state) {
//             return Scaffold(
//               appBar: AppBar(
//                 actions: [
//                   CircleAvatar(
//                     maxRadius: 14,
//                     child: Image.asset(
//                       "assets/defaultprofile.png",
//                       alignment: Alignment.centerLeft,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Padding(padding: EdgeInsets.only(left: 8.0)),
//                   IconButton(
//                     onPressed: (() {
//                       setState(() {
//                         heartColor = heartColor == heartColorList[0]
//                             ? heartColorList[1]
//                             : heartColorList[0];
//                       });
//                     }),
//                     iconSize: 28,
//                     icon: const Icon(Icons.favorite),
//                     color: heartColor,
//                   ),
//                 ],
//                 title: Text(userName),
//                 elevation: 5.0,
//               ),
//               body: Container(
//                 decoration: backgroundGradient(),
//                 child: Column(
//                   children: [
//                     Flexible(
//                       fit: FlexFit.loose,
//                       flex: 15,
//                       child: Container(
//                         padding: const EdgeInsets.all(20.0),
//                         child: ListView.builder(
//                           keyboardDismissBehavior:
//                               ScrollViewKeyboardDismissBehavior.onDrag,
//                           reverse: true, //to move to bottom of the chat
//                           dragStartBehavior: DragStartBehavior.down,
//                           itemCount: messages.length,
//                           itemBuilder: (context, index) {
//                             return Container(
//                               padding: const EdgeInsets.only(bottom: 10.0),
//                               child: Row(
//                                 children: [
//                                   //padding before Text

//                                   Flexible(
//                                     fit: FlexFit.loose,
//                                     flex: 5,
//                                     child: SizedBox(
//                                       child: Container(),
//                                     ),
//                                   ),

//                                   //display message

//                                   Flexible(
//                                     fit: FlexFit.tight,
//                                     flex: 6,
//                                     child: Container(
//                                       alignment: Alignment.centerRight,
//                                       child: GestureDetector(
//                                         onLongPress: () {
//                                           final snackBar = SnackBar(
//                                             content: Text(
//                                                 "Do you want to delete this message?"),
//                                             action: SnackBarAction(
//                                                 label: "Delete message",
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     context
//                                                         .read<
//                                                             MessageListCubit>()
//                                                         .state
//                                                         .remove(context
//                                                             .read<
//                                                                 MessageListCubit>()
//                                                             .state
//                                                             .reversed
//                                                             .toList()[index]);
//                                                   });
//                                                   messages = context
//                                                       .read<MessageListCubit>()
//                                                       .state
//                                                       .reversed
//                                                       .toList()
//                                                       .reversed
//                                                       .toList();
//                                                   if (context
//                                                           .read<
//                                                               MessageListCubit>()
//                                                           .state
//                                                           .length ==
//                                                       0) {
//                                                     context
//                                                         .read<
//                                                             MessageListCubit>()
//                                                         .emitList([]);
//                                                   } else {
//                                                     context
//                                                         .read<
//                                                             MessageListCubit>()
//                                                         .emitList(messages);
//                                                   }
//                                                 }),
//                                           );
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(snackBar);
//                                         },
//                                         child: Card(
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10.0)),
//                                           elevation: 5.0,
//                                           surfaceTintColor: Colors.amberAccent,
//                                           color: const Color.fromARGB(
//                                               255, 245, 137, 137),
//                                           child: Padding(
//                                             padding: EdgeInsets.all(10.0),
//                                             child: Text(
//                                               context
//                                                   .read<MessageListCubit>()
//                                                   .state
//                                                   .reversed
//                                                   .toList()[index],
//                                               style: const TextStyle(
//                                                   fontSize: 18.0),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     Flexible(
//                       // ignore: sort_child_properties_last
//                       child: Row(
//                         children: [
//                           const Flexible(
//                               flex: 1,
//                               fit: FlexFit.loose,
//                               child: Padding(padding: EdgeInsets.all(40.0))),
//                           Flexible(
//                             flex: 8,
//                             fit: FlexFit.tight,
//                             child: SizedBox(
//                               width: 200.0,
//                               height: 200.0,
//                               child: TextField(
//                                 keyboardType: TextInputType.multiline,
//                                 minLines: 1,
//                                 maxLines: 10,
//                                 onChanged: (value) {
//                                   Message = inputMessage.text;
//                                 },
//                                 dragStartBehavior: DragStartBehavior.start,
//                                 controller: inputMessage,
//                                 enableInteractiveSelection: true,
//                                 decoration: InputDecoration(
//                                     constraints:
//                                         BoxConstraints.expand(height: 500),
//                                     contentPadding: EdgeInsets.all(10.0),
//                                     label: Text("Type message"),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(30.0),
//                                     )),
//                               ),
//                             ),
//                           ),

//                           //Send  Button

//                           Container(
//                             alignment: Alignment.topRight,
//                             child: RawMaterialButton(
//                               padding: const EdgeInsets.all(10.0),
//                               fillColor: colors1[0],
//                               onPressed: () {
//                                 if (Message != "") {
//                                   context
//                                       .read<MessageListCubit>()
//                                       .addMessageToList(messages, Message);

//                                   context
//                                       .read<MessageCubit>()
//                                       .inputMessage(Message);
//                                   inputMessage.clear();
//                                   Message = "";
//                                 }
//                               },
//                               shape: const CircleBorder(),
//                               elevation: 5.0,
//                               child: Padding(
//                                 padding: EdgeInsets.only(left: 4.0),
//                                 child: Icon(
//                                   Icons.send,
//                                   size: 30.0,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       flex: 2,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
