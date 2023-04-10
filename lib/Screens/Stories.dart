import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/Logic/CubitLogic.dart';

class Stories extends StatefulWidget {
  const Stories({super.key});

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  @override
  Widget build(BuildContext context) {
    final userData = context.read<GetUserDataCubit>().state;

    return Scaffold(
        body: Column(
      children: [
        PhysicalModel(
          elevation: 40,
          color: Colors.grey,
          child: ListTile(
            tileColor: Colors.grey,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userData['photoUrl']),
              radius: 30,
              child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: Icon(
                    Icons.add_a_photo_rounded,
                    size: 20,
                    color: Colors.blueGrey,
                  )),
            ),
            title: const Text('Add Story to share with friends'),
            trailing: const Icon(Icons.add_a_photo_sharp),
          ),
        ),
        const SizedBox(height: 20),
        const Divider(
          height: 10,
          thickness: 10,
        ),
        const Spacer(flex: 1),
        const Center(
          child: Text('No Stories available', style: TextStyle(fontStyle: FontStyle.italic)),
        ),
        const Spacer(flex: 1),
      ],
    ));
  }
}
