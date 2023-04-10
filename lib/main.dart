import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:chatapp/Logic/CubitLogic.dart';
import 'package:chatapp/Screens/Authentication/Signin.dart';
import 'package:chatapp/Screens/HomePage.dart';

import 'firebase_options.dart';
import 'notifications/notifications.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('logo');
  //'flutter_logo' ->inside the android>app>src>main>res>drawable folder.

  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await notification.initialize(initializationSettings, onDidReceiveNotificationResponse: (details) async {});
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
            theme: ThemeData(fontFamily: 'Alkatra'),
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
