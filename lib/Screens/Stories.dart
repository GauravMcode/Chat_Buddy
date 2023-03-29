import 'package:chatapp/Model/User.dart';
import 'package:chatapp/Screens/Chat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/Logic/CubitLogic.dart';

class Stories extends StatefulWidget {
  const Stories({super.key});

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GetUsersListCubit>().getSnapshotValue();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement buil
    // print(data);
// context.read<DateTimeCubit>().state
    return context.read<GetUsersListCubit>().state == {}
        ? const Center(child: CircularProgressIndicator())
        : BlocBuilder<GetUsersListCubit, dynamic>(
            builder: (context, state) {
              return Container(
                  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(""),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      // child: Text("${users}"),
                    ),
                  ],
                ),
              ));
            },
          );
  }
}
