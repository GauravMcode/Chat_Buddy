import 'package:chatapp/Screens/Authentication/Signin.dart';
import 'package:chatapp/auxilaries/Colors.dart';
import 'package:chatapp/Screens/HomePage.dart';
import 'package:chatapp/Logic/CubitLogic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MessageCubit>(
          create: (context) => MessageCubit(),
        ),
        BlocProvider<MessageListCubit>(
          create: (context) => MessageListCubit(),
        ),
        BlocProvider<AuthCubit>(
          create: ((context) => AuthCubit()),
        ),
        BlocProvider<GetUsersListCubit>(
          create: ((context) => GetUsersListCubit()),
        ),
        BlocProvider<InputSearchCubit>(
          create: ((context) => InputSearchCubit()),
        ),
        BlocProvider<GetUserDataCubit>(
          create: ((context) => GetUserDataCubit()),
        ),
        BlocProvider<GetUserName>(
          create: ((context) => GetUserName()),
        ),
        BlocProvider<DateTimeCubit>(
          create: ((context) => DateTimeCubit()),
        ),
        BlocProvider<SentMessagesCubit>(
          create: ((context) => SentMessagesCubit()),
        ),
        BlocProvider<ReceivedMessagesCubit>(
          create: ((context) => ReceivedMessagesCubit()),
        ),
        BlocProvider<IsReceivedCubit>(
          create: ((context) => IsReceivedCubit()),
        ),
        BlocProvider<InputIndexPointerCubit>(
          create: ((context) => InputIndexPointerCubit()),
        ),
        BlocProvider<ReceivedIndexPointerCubit>(
          create: ((context) => ReceivedIndexPointerCubit()),
        ),
        BlocProvider<DateCubit>(
          create: ((context) => DateCubit()),
        ),
        BlocProvider<IsDateChangedCubit>(
          create: ((context) => IsDateChangedCubit()),
        ),
      ],
      child: BlocBuilder<AuthCubit, bool>(
        builder: (context, authstate) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "chat app",
            theme: ThemeData(primarySwatch: mycolor),
            home: context.read<AuthCubit>().state
                ? const DefaultTabController(
                    length: 3,
                    child: HomePage(),
                  )
                : const Signin(),
          );
        },
      ),
    );
  }
}
