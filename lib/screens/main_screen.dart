import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_apaga/Cubit/Internet/cubit/internet_cubit.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import 'package:new_apaga/bloc/Confirm/bloc/confirm_bloc.dart';
import 'package:new_apaga/bloc/SeeMorde/bloc/see_more_bloc.dart';
import 'package:new_apaga/bloc/profileEdit_send/Password_Bloc/bloc/password_change_bloc.dart';
import 'package:new_apaga/bloc/profileEdit_send/Password_Bloc/bloc/profile_edit_bloc.dart';
import 'package:new_apaga/bloc/profileEdit_send/profileEdit_/bloc/profile_get_data_bloc.dart';
import 'package:new_apaga/repository.dart';
import 'package:new_apaga/screens/Menu/myPickup/mypickup.dart';
import 'package:new_apaga/screens/QR_code/qr_code.dart';
import '../bloc/Order_bloc/order_bloc.dart';
import 'Menu/Home/home.dart';
import 'Menu/Profile/profile.dart';

bool colorOne = false;
bool colorTwo = false;
bool colorThree = false;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() =>
      _MainScreenState(userRepository: UserRepository());
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  UserRepository userRepository;
  _MainScreenState({required this.userRepository});
  // BlocProvider<SeeMoreBloc>(
  //   create: (context) => SeeMoreBloc(
  //       authenticationBloc:
  //           BlocProvider.of<AuthBloc>(context),
  //       repository: UserRepository()),
  // ),
  final Tabs = [
    MultiBlocProvider(
      providers: [
        BlocProvider<ListBloc>(
          create: (context) => ListBloc(
            authenticationBloc: AuthBloc()..add(AppStarted()),
            repository: UserRepository(),
          ),
        ),
        BlocProvider<SeeMoreBloc>(
          create: (context) => SeeMoreBloc(
              authenticationBloc: BlocProvider.of<AuthBloc>(context),
              repository: UserRepository()),
        ),
        BlocProvider<ConfirmBloc>(
          create: (context) => ConfirmBloc(
              authenticationBloc: BlocProvider.of<AuthBloc>(context),
              userRepository: UserRepository()),
        ),
      ],
      child: const Home(),
    ),
    MultiBlocProvider(
      providers: [
        BlocProvider<ProfileEditBloc>(
          create: (context) => ProfileEditBloc(
              internetCubit: BlocProvider.of<InternetCubit>(context),
              authenticationBloc: BlocProvider.of<AuthBloc>(context),
              userRepository: UserRepository()),
        ),
        BlocProvider<ProfileGetDataBloc>(
          create: (context) => ProfileGetDataBloc(
              auth: BlocProvider.of<AuthBloc>(context),
              repository: UserRepository()),
        ),
        BlocProvider<PasswordChangeBloc>(
          create: (context) => PasswordChangeBloc(
              authenticationBloc: BlocProvider.of<AuthBloc>(context),
              userRepository: UserRepository()),
        ),
      ],
      child: const Profile(),
    ),
    BlocProvider<ListBloc>(
      create: (context) => ListBloc(
          authenticationBloc: BlocProvider.of<AuthBloc>(context),
          repository: UserRepository()),
      child: MyPickUp(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Tabs[_currentIndex],
        //Bottom
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
          currentIndex: _currentIndex,
          unselectedFontSize: 11,
          selectedFontSize: 11,
          unselectedItemColor: const Color.fromRGBO(255, 255, 255, 1),
          items: [
            BottomNavigationBarItem(
              icon: homeIcon,
              activeIcon: SvgPicture.asset('assets/icon/iconHome.svg',
                  color: const Color.fromRGBO(159, 205, 79, 1)),
              label: "Օրվա հավաք",
            ),
            BottomNavigationBarItem(
                icon: pickupIcon,
                activeIcon: SvgPicture.asset('assets/icon/profilIcon.svg',
                    color: const Color.fromRGBO(159, 205, 79, 1)),
                label: "Անձնական էջ"),
            BottomNavigationBarItem(
                icon: profilIcon,
                activeIcon: SvgPicture.asset('assets/icon/im.havaq.svg',
                    color: const Color.fromRGBO(159, 205, 79, 1)),
                label: "Իմ հավաքները"),
          ],
          selectedItemColor: const Color.fromRGBO(159, 205, 79, 1),
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
        ));
  }

  Widget homeIcon = SvgPicture.asset('assets/icon/iconHome.svg',
      color: const Color.fromRGBO(255, 255, 255, 1));
  Widget pickupIcon = SvgPicture.asset('assets/icon/profilIcon.svg',
      color: const Color.fromRGBO(255, 255, 255, 1));
  Widget profilIcon = SvgPicture.asset('assets/icon/im.havaq.svg',
      color: const Color.fromRGBO(255, 255, 255, 1));
}
