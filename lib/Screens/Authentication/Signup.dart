import 'package:chatapp/Logic/CubitLogic.dart';
import 'package:chatapp/Screens/HomePage.dart';
import 'package:chatapp/auxilaries/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Map createUserDetails(String name, String emailid, [String photoUrl = ""]) {
    return {"name": name, "emailId": emailid, "photoUrl": photoUrl, "isSignedin": "${true}", "friendsList": "", "messagesList": "", "isPrivate": "${false}", "connectRequests": "", "viewers": ""};
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InputSearchCubit();
    context.read<GetUsersListCubit>().getSnapshotValue();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child("usersData");
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  dynamic _userDataL;

  Widget _formField(String field, bool isObscure, TextEditingController controller, String saveTo) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        validator: ((value) {
          if (value == null || value.isEmpty) {
            return "Please enter the $field";
          }
          return null;
        }),
        controller: controller,
        onFieldSubmitted: (value) => saveTo = controller.text,
        obscureText: isObscure,
        decoration: InputDecoration(label: Text(field), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      ),
    );
  }

  //save user to database:
  saveUser() async {
    Map userDetails = createUserDetails(_nameController.text, _emailController.text);
    await _database.child(_userNameController.text).set(userDetails);
  }

//Sign Up:
  void signUp() async {
    _formkey.currentState!.save();

    try {
      UserCredential newUser = await _auth.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
      saveUser();
      await FirebaseAuth.instance.currentUser?.updateDisplayName(_userNameController.text);
      await FirebaseAuth.instance.currentUser?.reload();
      context.read<GetUserDataCubit>().getSnapshotValue(_userNameController.text);

      context.read<GetUserName>().gotUserName(_userNameController.text);
      context.read<AuthCubit>().authSignin();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showError(e.message);
    }
  }

  //Show error:
  showError(String? errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(errorMessage.toString()),
            actions: <Widget>[
              MaterialButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  //Navigators:
  navigateToHomeScreen() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: ((context) => const DefaultTabController(
                  length: 3,
                  child: HomePage(),
                ))));
  }

  //Text Editing controllers:
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Show snackbar:
  SnackBar snackBar = SnackBar(
    duration: const Duration(milliseconds: 2100),
    dismissDirection: DismissDirection.up,
    content: Container(
      decoration: foregroundGradient(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Signing In",
            style: TextStyle(color: colors1[5], fontSize: 25),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(
              color: colors1[5],
            ),
          )
        ],
      ),
    ),
    elevation: 5.0,
    padding: const EdgeInsets.all(5.0),
  );

  @override
  Widget build(BuildContext context) {
    return context.read<GetUsersListCubit>().state == []
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: foregroundGradient(),
              ),
              title: const Text("Sign-Up to Chat-buddy", style: TextStyle(fontFamily: 'Alkatra')),
              actions: const [Icon(Icons.chat_bubble_rounded), SizedBox(width: 20)],
            ),
            body: Container(
              constraints: const BoxConstraints.expand(),
              decoration: backgroundGradient(),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                            key: _formkey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(padding: EdgeInsets.all(30)),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: TextFormField(
                                    maxLength: 20,
                                    validator: ((value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your name";
                                      }

                                      if (6 > value.length && value.length < 20) {
                                        return " The name must be between 6 to 20 characters";
                                      }
                                      return null;
                                    }),
                                    controller: _nameController,
                                    decoration: InputDecoration(label: const Text("Name"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(15)),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: TextFormField(
                                    maxLength: 14,
                                    validator: ((value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please create a user name";
                                      }
                                      if (context.read<GetUsersListCubit>().state.contains(value)) {
                                        return "The user name already exists";
                                      }
                                      if (6 > value.length && value.length < 14) {
                                        return " The user name must be between 6 to 14 characters";
                                      }
                                      return null;
                                    }),
                                    controller: _userNameController,
                                    decoration: InputDecoration(label: const Text("Create a unique user Name"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(15)),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: TextFormField(
                                    validator: ((value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter the Email";
                                      }
                                      return null;
                                    }),
                                    controller: _emailController,
                                    decoration: InputDecoration(label: const Text("Email"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(20)),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: TextFormField(
                                    validator: ((value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter the Password";
                                      }
                                      return null;
                                    }),
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(label: const Text("Password"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20.0)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0.0),
                          elevation: 5,
                        ),
                        child: Ink(
                          decoration: foregroundGradient(),
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              constraints: const BoxConstraints(minWidth: 88.0),
                              child: const Text(
                                "Sign-Up",
                                textAlign: TextAlign.center,
                              )),
                        ),
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            FocusManager.instance.primaryFocus?.unfocus();

                            signUp();
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                      ),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       setState(() {
                      //         _userDataL =
                      //             _database.pa
                      //       });
                      //       for (final Match m in _userDataL) {
                      //         String match = m[0]!;
                      //         print(match);
                      //       }
                      //       ;
                      //     },
                      //     child: Text("Sign-In")),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
