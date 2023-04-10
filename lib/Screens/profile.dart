import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Logic/CubitLogic.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isPrivate = false;

  @override
  Widget build(BuildContext context) {
    final userData = context.read<GetUserDataCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontFamily: 'Alkatra')),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            backgroundImage: NetworkImage(userData['photoUrl']),
            radius: 60,
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Name :'),
            trailing: Text(userData['name']),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.card_membership),
            title: const Text('User Name : '),
            trailing: Text(context.read<GetUserName>().state),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email id :'),
            trailing: Text(userData['emailId']),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
              title: const Text('Private : '),
              value: isPrivate,
              onChanged: (bool newValue) {
                setState(() {
                  isPrivate = !isPrivate;
                });
              }),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  context.read<AuthCubit>().authSignout();
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Sign Out'))
        ],
      ),
    );
  }
}
