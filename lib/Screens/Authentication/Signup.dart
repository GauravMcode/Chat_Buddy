import 'package:chatapp/Logic/CubitLogic.dart';
import 'package:chatapp/Model/User.dart';
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
    return {"name": name, "emailId": emailid, "photoUrl": "$photoUrl", "isSignedin": "${true}", "friendsList": "", "messagesList": "", "isPrivate": "${false}", "connectRequests": "", "viewers": ""};
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InputSearchCubit();
    context.read<GetUsersListCubit>().getSnapshotValue();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference _database = FirebaseDatabase.instance.ref().child("usersData");
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  dynamic _userDataL;

  Widget _formField(String field, bool isObscure, TextEditingController controller, String saveTo) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        validator: ((value) {
          if (value == null || value.isEmpty) {
            return "Please enter the $field";
          }
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
      if (newUser != null) {
        await FirebaseAuth.instance.currentUser?.updateDisplayName(_userNameController.text);
        await FirebaseAuth.instance.currentUser?.reload();
        context.read<GetUserDataCubit>().getSnapshotValue(_userNameController.text);

        context.read<GetUserName>().gotUserName(_userNameController.text);
        context.read<AuthCubit>().authSignin();
        Navigator.pop(context);
      }
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
            title: Text("Error"),
            content: Text(errorMessage.toString()),
            actions: <Widget>[
              MaterialButton(
                child: Text("Ok"),
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
            builder: ((context) => DefaultTabController(
                  length: 3,
                  child: HomePage(),
                ))));
  }

  //Text Editing controllers:
  TextEditingController _nameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //Show snackbar:
  SnackBar snackBar = SnackBar(
    duration: Duration(milliseconds: 2100),
    dismissDirection: DismissDirection.up,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Signing In",
          style: TextStyle(color: colors1[5]),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            color: colors1[5],
          ),
        )
      ],
    ),
    backgroundColor: colors1[0],
    elevation: 5.0,
    padding: EdgeInsets.all(5.0),
  );

  @override
  Widget build(BuildContext context) {
    return context.read<GetUsersListCubit>().state == []
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Sign-Up to Chat App"),
            ),
            body: Container(
              constraints: BoxConstraints.expand(),
              decoration: backgroundGradient(),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Form(
                            key: _formkey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(padding: EdgeInsets.all(30)),
                                Container(
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
                                    decoration: InputDecoration(label: Text("Name"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(15)),
                                Container(
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
                                    decoration: InputDecoration(label: Text("Create a unique user Name"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(15)),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: TextFormField(
                                    validator: ((value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter the Email";
                                      }
                                    }),
                                    controller: _emailController,
                                    decoration: InputDecoration(label: Text("Email"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(20)),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: TextFormField(
                                    validator: ((value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter the Password";
                                      }
                                    }),
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(label: Text("Password"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();

                              signUp();
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          },
                          child: Text("Sign-Up")),
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
