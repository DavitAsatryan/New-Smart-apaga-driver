import 'package:flutter/material.dart';

class Disconnected extends StatelessWidget {
  const Disconnected({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("dav jan Disconnected Screen ");
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/disConnnected.png",
          width: MediaQuery.of(context).size.width - 200,
          height: 120,
        ),
      ),
    );
  }
}
