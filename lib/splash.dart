import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_apaga/Cubit/Internet/cubit/internet_cubit.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import 'package:new_apaga/disconnected.dart';
import 'package:new_apaga/main.dart';
import 'package:new_apaga/repository.dart';
import 'package:new_apaga/screens/login_form.dart';
import 'package:new_apaga/screens/login_screen.dart';
import 'package:new_apaga/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Enum/internetEnum.dart';

class Splash extends StatefulWidget {
  final UserRepository userRepository;
  Splash({Key? key, required this.userRepository}) : super(key: key);
  @override
  State<Splash> createState() => SplashState(userRepository: userRepository);
}

//bool isLOggedIN = LoginFormState.isLoggedIn;

class SplashState extends State<Splash> {
  UserRepository userRepository;
  SplashState({required this.userRepository});

  //late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification? android = message.notification.android!;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                color: Colors.amber,
                playSound: true,
                icon: '@mipmap/ic_launcher'),
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification? android = message.notification.android!;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body)],
                  ),
                ),
              );
            });
      }
    });

    _navigatetHome();
    //autoLogin();
  }

  // Future<void> autoLogin() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   final String? userId = await pref.getString('token_auth');
  //   print(" _------------------------------------------------------   $userId");
  //   if (userId != null) {
  //     setState(() {
  //       isLOggedIN = true;
  //     });
  //     return;
  //   } else if (userId == null || userId == "") {
  //     setState(() {
  //       isLOggedIN = false;
  //     });
  //     return;
  //   }
  // }

  void _navigatetHome() async {
    await Future.delayed(Duration(milliseconds: 2500), () {});
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => internetMetod(context)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color.fromRGBO(255, 255, 255, 1),
      child: Stack(alignment: Alignment.topRight, children: [
        Stack(
          children: [Image.asset("assets/Frame.png")],
        ),
        Center(
            child: Container(
          child: Image.asset("assets/SmartApaga-logo-Finish.png"),
        )),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 200),
            child: Text(
              "Together for a Smarter Future",
              style: TextStyle(
                  color: Color.fromRGBO(12, 128, 64, 1), fontSize: 20),
            ),
          ),
        ),
      ]),
    ));
  }
}

BlocBuilder<InternetCubit, InternetState> internetMetod(BuildContext context) {
  return BlocBuilder<InternetCubit, InternetState>(builder: (contex, state) {
    if (state is InternetConnected &&
        state.connectionTYpe == ConnectionType.Wifi) {
      return authBlocBuildMetod(context, true);
    } else if (state is InternetConnected &&
        state.connectionTYpe == ConnectionType.Mobile) {
      return authBlocBuildMetod(context, true);
    } else if (state is InternetDisconnected) {
      return authBlocBuildMetod(context, false);
    }
    return const Disconnected();
  });
}

//hhhhh
authBlocBuildMetod(BuildContext context, bool dataB) {
  return dataB == true
      ? BlocListener<AuthBloc, AuthenticationState>(
          listener: (context, state) {},
          child: BlocBuilder<AuthBloc, AuthenticationState>(
              builder: (contex, state) {
            if (state is AuthenticationLoading) {
              print("mssssssdddddn");
              return Scaffold(
                body: Container(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      SizedBox(
                        height: 25.0,
                        width: 25.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 4.0,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            return LoginScreen(
              userRepository: UserRepository(),
              auth: AuthBloc(),
            );
          }),
        )
      : Text("");
}
