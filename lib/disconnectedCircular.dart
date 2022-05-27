import 'package:flutter/material.dart';

class DisconnectedCircular extends StatefulWidget {
  const DisconnectedCircular({Key? key}) : super(key: key);
  @override
  State<DisconnectedCircular> createState() => _DisconnectedCircularState();
}

class _DisconnectedCircularState extends State<DisconnectedCircular> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
