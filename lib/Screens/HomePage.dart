import 'package:chatapp/Logic/CubitLogic.dart';
import 'package:chatapp/auxilaries/Colors.dart';
import 'package:chatapp/Screens/Calls.dart';
import 'package:chatapp/Screens/MessageList.dart';
import 'package:chatapp/Screens/Stories.dart';
import 'package:chatapp/auxilaries/SearchDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   context.read<MessageCubit>().close();
  //   context.read<MessageListCubit>().close();
  //   context.read<AuthCubit>().close();
  //   context.read<GetUsersListCubit>().close();
  //   context.read<InputSearchCubit>().close();
  // }
//todo: for messages
  // getMessagesList() async {
  //   await context.read<SentMessagesCubit>().getSentMessagesList("hello_3", "hello_1");
  //   await context.read<ReceivedMessagesCubit>().getSentMessagesList("hello_1", "hello_3");
  // }

  @override
  void initState() {
    super.initState();
    InputSearchCubit();
    context.read<GetUsersListCubit>().getSnapshotValue();
    context.read<GetUserDataCubit>().getSnapshotValue('hello_1');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.read<GetUserDataCubit>().state;

    return context.read<GetUsersListCubit>().state == []
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: foregroundGradient(),
              ),
              actions: const [
                CircleAvatar(foregroundImage: AssetImage('assets/logo.png')),
              ],
              title: const Text(
                'Chat-buddy',
                style: TextStyle(fontFamily: 'Alkatra'),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Profile(),
                  )),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(userData['photoUrl']),
                    radius: 30,
                  ),
                ),
              ),
              centerTitle: true,
              elevation: 5.0,
              bottom: const TabBar(tabs: [
                Tab(
                  text: "Messages",
                  icon: Icon(Icons.message),
                ),
                Tab(
                  text: "Stories",
                  icon: Icon(Icons.circle_outlined),
                ),
                Tab(
                  text: "Calls",
                  icon: Icon(Icons.call),
                ),
              ]),
            ),
            floatingActionButton: Ink(
              decoration: foregroundGradient(),
              child: FloatingActionButton(
                hoverElevation: 10.0,
                child: const Icon(
                  size: 35.0,
                  Icons.search,
                  // color: colors1[9],
                ),
                onPressed: () {
                  showSearchDialog(context, context.read<GetUsersListCubit>().state);
                },
              ),
            ),
            body: const TabBarView(children: [
              MessageList(),
              Stories(),
              Calls(),
            ]),
          );
  }
}
