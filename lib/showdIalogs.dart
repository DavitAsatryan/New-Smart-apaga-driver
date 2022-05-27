// ignore: file_names


import 'package:flutter/material.dart';

class ShowDialogs{
  

 Future<dynamic> show(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(159, 205, 79, 1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      minimumSize: const Size(100, 36), //////// HERE
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Լավ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 16,
                        )),
                  )
                ],
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                      color: Color.fromARGB(255, 144, 138, 137)),
                  borderRadius: BorderRadius.circular(10),
                ),
                content: StatefulBuilder(
                  builder: (context, setState) => Container(
                    child: const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                      child: Text("Գործընթացը հաջողվեց"),
                    ),
                  ),
                ));
          });
  }

  Future<dynamic> showFailure(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(159, 205, 79, 1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      minimumSize: const Size(100, 36), //////// HERE
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Լավ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 16,
                        )),
                  )
                ],
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                      color: Color.fromARGB(255, 144, 138, 137)),
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text("Սխալ",
                    style: TextStyle(
                      color: Color.fromRGBO(14, 14, 14, 1),
                      fontSize: 16,
                    )),
                content: StatefulBuilder(
                  builder: (context, setState) => Container(
                    child: const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                      child: Text("վերանայեք տվյալները"),
                    ),
                  ),
                ));
          },
        );
  }
}