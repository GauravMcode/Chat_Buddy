import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chatapp/Logic/CubitLogic.dart';

class Calls extends StatefulWidget {
  const Calls({super.key});

  @override
  State<Calls> createState() => _CallsState();
}

class _CallsState extends State<Calls> with AutomaticKeepAliveClientMixin {
  // to preserve the state
  @override
  bool get wantKeepAlive => true;

  // bool recieved = false;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  //   if (context.read<MessageCubit>().state == "") {
  //     setState(() {
  //       context.read<MessageCubit>().inputMessage("");
  //       context.read<InputIndexPointerCubit>().isInputIndexPointer(context.read<SentMessagesCubit>().state.length - 1);
  //       context.read<ReceivedIndexPointerCubit>().isReceivedIndexPointer(context.read<ReceivedMessagesCubit>().state.length - 1);
  //     });
  //   }
  // }

  //   // context.read<InputIndexPointerCubit>().state = context.read<SentMessagesCubit>().state.keys.length - 1;
  //   // context.read<ReceivedIndexPointerCubit>().state = context.read<ReceivedMessagesCubit>().state.keys.length - 1;

  // context.read<InputIndexPointerCubit>().isInputIndexPointer(context.read<SentMessagesCubit>().state.length - 1);
  // context.read<ReceivedIndexPointerCubit>().isReceivedIndexPointer(context.read<ReceivedMessagesCubit>().state.length - 1);

  //   // final datetime = DateTime.now();
  //   // context.read<DateTimeCubit>().emit(datetime);
  //   // getdata(context);  //   context.read<DateTimeCubit>().emit(DateTime.now());
  //   // DateTime now = context.read<DateTimeCubit>().state;

  //   // String nowString = "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}";
  //   // Map<String, String> nowTime = {nowString: "hello bro hello_1"};
  //   // sentMessages(nowTime);
  //   // context.read<SentMessagesCubit>().getSentMessagesList("hello_3", "hello_1");
  // }

  // List chatUsers = [];
  // final datetime = DateTime.now();
  // String datetimestring = "1969-07-20 20:18:04";
  // final time = DateTime.parse("1969-07-20 20:18:04");
  // // "'1969-07-20 20:18:04"

  getMessagesList() async {
    await context.read<SentMessagesCubit>().getSentMessagesList("hello_3", "hello_1");
    await context.read<ReceivedMessagesCubit>().getSentMessagesList("hello_1", "hello_3");
  }

  sendtheMessage(String message, String sender, String receiver, String timeasMillisecondsepoch) async {
    await FirebaseDatabase.instance.ref("usersData/$sender/messagesList/$receiver/").update({timeasMillisecondsepoch: message});
  }

  @override
  Widget build(BuildContext context) {
    context.read<SentMessagesCubit>().state;
    context.read<ReceivedMessagesCubit>().state;
    print("lengthInput: ${context.read<SentMessagesCubit>().state.keys.length - 1}");
    print("receivedInput: ${context.read<ReceivedMessagesCubit>().state.keys.length - 1}");
    // sendtheMessage("hello bhai", "hello_1", "hello_3", nowString);

    return BlocBuilder<SentMessagesCubit, Map>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return BlocBuilder<ReceivedMessagesCubit, Map>(
          buildWhen: (previous, current) => current != previous,
          builder: (context, recstate) {
            super.build(context);

            context.read<MessageCubit>().inputMessage("");
            context.read<InputIndexPointerCubit>().isInputIndexPointer(context.read<SentMessagesCubit>().state.length - 1);
            context.read<ReceivedIndexPointerCubit>().isReceivedIndexPointer(context.read<ReceivedMessagesCubit>().state.length - 1);
            return ListView(
              children: listofWidgets(context),

              // addAutomaticKeepAlives: true,
              // itemCount: (context.read<ReceivedMessagesCubit>().state.keys.length + context.read<SentMessagesCubit>().state.keys.length),
              // itemBuilder: ((context, index) {
              //   if (context.read<ReceivedIndexPointerCubit>().state >= 0 && context.read<InputIndexPointerCubit>().state >= 0) {
              //     if (((context.read<ReceivedMessagesCubit>().state.keys.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1) <
              //         context.read<SentMessagesCubit>().state.keys.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1)))) {
              //       context.read<MessageCubit>().inputMessage(
              //           context.read<ReceivedMessagesCubit>().state.values.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1));
              //       print(index);
              //       print("block 3");
              //       print(
              //           "Message text No: ${context.read<ReceivedMessagesCubit>().state.values.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1)}");
              //       print(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1);
              //       //  context.read<ReceivedIndexPointerCubit>().state = context.read<ReceivedIndexPointerCubit>().state - 1;
              //       context.read<ReceivedIndexPointerCubit>().isReceivedIndexPointer(context.read<ReceivedIndexPointerCubit>().state - 1);
              //       context.read<IsReceivedCubit>().messageIsReceivedOne();
              //     }

              //     // if (context.read<InputIndexPointerCubit>().state >= 0 && context.read<ReceivedIndexPointerCubit>().state >= 0)
              //     else if (context.read<SentMessagesCubit>().state.keys.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1) <=
              //         context.read<ReceivedMessagesCubit>().state.keys.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1)) {
              //       List Msg = context.read<SentMessagesCubit>().state.values.toList();
              //       context.read<MessageCubit>().inputMessage(Msg[context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1]);
              //       print("block 4");
              //       print("Message text No: ${Msg[context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1]}");
              //       print(index);
              //       print(context.read<InputIndexPointerCubit>().state);

              //       context.read<InputIndexPointerCubit>().isInputIndexPointer(context.read<InputIndexPointerCubit>().state - 1);
              //       context.read<IsReceivedCubit>().messageIsSentOne();
              //       print(context.read<InputIndexPointerCubit>().state);
              //     }
              //   } else if (context.read<InputIndexPointerCubit>().state < 0 || context.read<ReceivedIndexPointerCubit>().state < 0) {
              //     if (context.read<InputIndexPointerCubit>().state >= 0 && context.read<ReceivedIndexPointerCubit>().state < 0) {
              //       print("block 1");
              //       context
              //           .read<MessageCubit>()
              //           .inputMessage(context.read<SentMessagesCubit>().state.values.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1));
              //       print(
              //           "Message text no: ${context.read<SentMessagesCubit>().state.values.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1)}");
              //       context.read<InputIndexPointerCubit>().isInputIndexPointer(context.read<InputIndexPointerCubit>().state - 1);
              //       context.read<IsReceivedCubit>().messageIsSentOne();
              //       print(index);

              //       print(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1);
              //     } else if (context.read<ReceivedIndexPointerCubit>().state >= 0 && context.read<InputIndexPointerCubit>().state < 0) {
              //       print("block 2");
              //       print(context.read<ReceivedMessagesCubit>().state.values.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1));

              //       List Msg = context.read<ReceivedMessagesCubit>().state.values.toList();
              //       context.read<MessageCubit>().inputMessage(Msg[context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1]);

              //       print("Message text no: ${Msg[context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1]}");
              //       print(index);
              //       print(context.read<ReceivedIndexPointerCubit>().state);
              //       print(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1);
              //       context.read<ReceivedIndexPointerCubit>().isReceivedIndexPointer(context.read<ReceivedIndexPointerCubit>().state - 1);
              //       context.read<IsReceivedCubit>().messageIsReceivedOne();
              //       print(context.read<ReceivedIndexPointerCubit>().state);
              //     }
              //   }

              //   return Container(
              //     alignment: Alignment.centerRight,
              //     width: 300,
              //     height: 40,
              //     child: ListView(
              //       scrollDirection: Axis.horizontal,
              //       reverse: context.read<IsReceivedCubit>().state,
              //       children: [
              //         SizedBox(
              //           width: 300,
              //         ),
              //         Text(context.read<MessageCubit>().state),
              //       ],
              //     ),
              //   );
              // }),
            );
          },
        );
      },
    );
  }
}

// To generate list of widgets of text
List<Widget> listofWidgets(BuildContext context) {
  int length = context.read<ReceivedMessagesCubit>().state.keys.length + context.read<SentMessagesCubit>().state.keys.length;
  List<Widget> list = List.generate(
    length,
    (index) {
      if (context.read<ReceivedIndexPointerCubit>().state >= 0 && context.read<InputIndexPointerCubit>().state >= 0) {
        if (((context.read<ReceivedMessagesCubit>().state.keys.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1) <
            context.read<SentMessagesCubit>().state.keys.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1)))) {
          context
              .read<MessageCubit>()
              .inputMessage(context.read<ReceivedMessagesCubit>().state.values.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1));
          print(index);
          print("block 3");
          print(
              "Message text No: ${context.read<ReceivedMessagesCubit>().state.values.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1)}");
          print(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1);
          //  context.read<ReceivedIndexPointerCubit>().state = context.read<ReceivedIndexPointerCubit>().state - 1;
          context.read<ReceivedIndexPointerCubit>().isReceivedIndexPointer(context.read<ReceivedIndexPointerCubit>().state - 1);
          context.read<IsReceivedCubit>().messageIsReceivedOne();
        }

        // if (context.read<InputIndexPointerCubit>().state >= 0 && context.read<ReceivedIndexPointerCubit>().state >= 0)
        else if (context.read<SentMessagesCubit>().state.keys.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1) <=
            context.read<ReceivedMessagesCubit>().state.keys.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1)) {
          List Msg = context.read<SentMessagesCubit>().state.values.toList();
          context.read<MessageCubit>().inputMessage(Msg[context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1]);
          print("block 4");
          print("Message text No: ${Msg[context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1]}");
          print(index);
          print(context.read<InputIndexPointerCubit>().state);

          context.read<InputIndexPointerCubit>().isInputIndexPointer(context.read<InputIndexPointerCubit>().state - 1);
          context.read<IsReceivedCubit>().messageIsSentOne();
          print(context.read<InputIndexPointerCubit>().state);
        }
      } else if (context.read<InputIndexPointerCubit>().state < 0 || context.read<ReceivedIndexPointerCubit>().state < 0) {
        if (context.read<InputIndexPointerCubit>().state >= 0 && context.read<ReceivedIndexPointerCubit>().state < 0) {
          print("block 1");
          context
              .read<MessageCubit>()
              .inputMessage(context.read<SentMessagesCubit>().state.values.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1));
          print("Message text no: ${context.read<SentMessagesCubit>().state.values.elementAt(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1)}");
          context.read<InputIndexPointerCubit>().isInputIndexPointer(context.read<InputIndexPointerCubit>().state - 1);
          context.read<IsReceivedCubit>().messageIsSentOne();
          print(index);

          print(context.read<SentMessagesCubit>().state.length - context.read<InputIndexPointerCubit>().state - 1);
        } else if (context.read<ReceivedIndexPointerCubit>().state >= 0 && context.read<InputIndexPointerCubit>().state < 0) {
          print("block 2");
          print(context.read<ReceivedMessagesCubit>().state.values.elementAt(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1));

          List Msg = context.read<ReceivedMessagesCubit>().state.values.toList();
          context.read<MessageCubit>().inputMessage(Msg[context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1]);

          print("Message text no: ${Msg[context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1]}");
          print(index);
          print(context.read<ReceivedIndexPointerCubit>().state);
          print(context.read<ReceivedMessagesCubit>().state.length - context.read<ReceivedIndexPointerCubit>().state - 1);
          context.read<ReceivedIndexPointerCubit>().isReceivedIndexPointer(context.read<ReceivedIndexPointerCubit>().state - 1);
          context.read<IsReceivedCubit>().messageIsReceivedOne();
          print(context.read<ReceivedIndexPointerCubit>().state);
        }
      }

      return Container(
        alignment: Alignment.centerRight,
        width: 300,
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          reverse: context.read<IsReceivedCubit>().state,
          children: [
            const SizedBox(
              width: 300,
            ),
            Text(context.read<MessageCubit>().state),
          ],
        ),
      );
    },
  );
  return list;
}
