import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_device_id/firebase_device_id.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:new_apaga/Cubit/Internet/cubit/internet_cubit.dart';
import 'package:new_apaga/repository.dart';
import 'package:new_apaga/splash.dart';
import 'bloc/Auth_Bloc/bloc/auth_bloc.dart';
import 'bloc/Order_bloc/order_bloc.dart';
import 'package:http/http.dart' as http;

// class SimpleBlocDelegate extends BlocDelegate {
//   @override
//   void onEvent(Bloc bloc, Object event) {
//     super.onEvent(bloc, event);
//     print(event);
//   }
//   @override
//   void onTransition(Bloc bloc, Transition transition) {
//     super.onTransition(bloc, transition);
//     print(transition);
//   }
//   @override
//   void onError(Bloc bloc, Object error, StackTrace stacktrace) {
//     super.onError(bloc, error, stacktrace);
//     print(error);
//   }
// }

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onMessage
  //getToken();

  FirebaseMessaging.instance
      .getToken()
      .then((value) => UserRepository.tokenF = value);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, 
    badge: true,
    sound: true,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //await UserPrafrence.init();
  // BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();
  // final internetCubit = InternetCubit(connectivity: Connectivity());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) {
            return AuthBloc();
          },
        ),
        
      ],
      child: MyApp(
        userRepository: userRepository,
        connectivity: Connectivity(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  //getToken()

  final Connectivity connectivity;
  final UserRepository userRepository;
  const MyApp(
      {Key? key, required this.connectivity, required this.userRepository})
      : super(key: key);
      
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InternetCubit>(
      create: (context) => InternetCubit(connectivity: connectivity),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: Splash(userRepository: userRepository),
        // home: BlocBuilder<InternetCubit, InternetState>(
        //   builder: (context, state) {
        //     if (state is InternetConnected &&
        //         state.connectionTYpe == ConnectionType.Wifi) {
        //       print("wifi");
        //       return Splash(userRepository: userRepository);
        //     } else if (state is InternetConnected &&
        //         state.connectionTYpe == ConnectionType.Mobile) {
        //       print("mobile");
        //       return Splash(userRepository: userRepository);
        //     } else if (state is InternetDisconnected) {
        //       print("No connaction");
        //       return disconnected();
        //     }
        //     return const CircularProgressIndicator();
        //   },
        // )
        //authBlocBuildMetod(context),
      ),
    );
  }
}
