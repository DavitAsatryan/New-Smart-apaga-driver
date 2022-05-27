import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import 'package:new_apaga/bloc/Notification/bloc/notification_bloc.dart';
import 'package:new_apaga/repository.dart';

class NotificationNew extends StatefulWidget {
  const NotificationNew({Key? key}) : super(key: key);
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationNew> {
  var blocNotification;
  int _selectedIndex = 0;
  final key = GlobalKey();
  @override
  void initState() {
    print("initalstate");
    blocNotification = BlocProvider.of<NotificationBloc>(context);
    blocNotification.add(NotificationFetchEvent());
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  double leftPadd = 16;
  bool deletOne = false;
  bool n = false;
  bool hide = false;
  bool deleteAll = false;
  final List<int> listDelete = [];
  // int indexAll = 0;
  final notyBloc = NotificationBloc(
      authenticationBloc: AuthBloc(), repository: UserRepository());
  @override
  Widget build(BuildContext context) {
    if (hide == true) {
      setState(() {
        leftPadd = 0;
      });
    } else {
      setState(() {
        leftPadd = 16;
      });
    }
    return WillPopScope(
      onWillPop: () async {
        if (hide == true) {
          n = false;
        } else {
          n = true;
        }
        setState(() {
          hide = false;
        });
        return n;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(232, 232, 232, 1)),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  elevation: 0,
                  backgroundColor: const Color.fromRGBO(12, 128, 64, 1),
                  pinned: true,
                  primary: true,
                  centerTitle: true,
                  title: const Text(
                    "Ծանուցում",
                    style: TextStyle(
                        color: Color.fromRGBO(235, 235, 232, 1), fontSize: 20),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const <StretchMode>[
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground
                    ],
                    background: Stack(children: [
                      Image.asset(
                        "assets/notificaion.png",
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    ]),
                  ),
                  expandedHeight: MediaQuery.of(context).size.height * 0.155,
                ),
              ];
            },
            body: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state is NotificationErrorState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NotificationInitialState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NotificationLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NotificationDeleeteSuccses) {
                  hide = false;
                  blocNotification = BlocProvider.of<NotificationBloc>(context);
                  blocNotification.add(NotificationFetchEvent());
                } else if (state is NotificationFetchSuccses) {
                  return Container(
                    height: double.infinity,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.notification.length,
                            itemBuilder: (context, index) {
                              return buildItem(context, state, index);
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
        bottomNavigationBar: hide == true
            ? deleteBottom(
                context,
              )
            : null,
      ),
    );
  }

  List<Widget> getList(dynamic state, BuildContext context) {
    return List.generate(state.notification.length, (index) {
      if (deleteAll == true) {
        listDelete.add(state.notification[index].id);
        blocNotification.add(NotificationDelete(id: listDelete));
        print("deleteAll $listDelete");
      }
      return Container(child: buildItem(context, state, index));
    });
  }

  Widget deleteBottom(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Container(
        //height: 90,
        child: BottomNavigationBar(
          elevation: 0.0,
          items: [
            BottomNavigationBarItem(
              label: "delete ",
              icon: IconButton(
                iconSize: 22,
                onPressed: () {
                  showModalDeleteDialog(context, true);
                },
                icon: Icon(Icons.delete),
              ),
            ),
            BottomNavigationBarItem(
              label: "delete all",
              icon: IconButton(
                onPressed: () {
                  showModalDeleteDialog(context, false);
                },
                icon: Icon(Icons.delete),
              ),
            ),
          ],
          backgroundColor: Color.fromARGB(162, 76, 175, 79),
        ),
      ),
    );
  }

  Container newMethod(BuildContext context, NotificationFetchSuccses state) {
    return Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 56, 108, 0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: ListTile(
            leading: deleteItem(context, state),
            trailing: deleteAllItem(context),
          ),
        ));
  }

  Widget buildItem(BuildContext context, dynamic state, int index) {
    return Container(
      decoration: BoxDecoration(color: Color.fromRGBO(232, 232, 232, 1)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 21),
        child: Container(
            height: 106,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Row(
              children: [
                hide == true
                    ? Checkbox(
                        activeColor: const Color.fromRGBO(12, 128, 64, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        //state.notification[index].check
                        value: state.notification[index].check,
                        onChanged: (value) {
                          setState(() {
                            state.notification[index].check = value!;
                            if (state.notification[index].check == true) {
                              listDelete.add(state.notification[index].id);
                              print(listDelete);
                            }
                          });
                        })
                    : const Text(""),
                Expanded(
                  child: Padding(
                    //left value
                    padding: EdgeInsets.only(left: leftPadd, right: 16),
                    child: InkWell(
                      onLongPress: () {
                        listDelete.clear();
                        setState(() {
                          hide = true;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 106,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                height: 60,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: Color.fromRGBO(
                                                169, 166, 166, 1)))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 14),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Container(
                                            width: 242,
                                            child: Text(
                                              "${state.notification[index].notification}",
                                              //overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            iconSize: 14,
                                            padding: EdgeInsets.only(left: 100),
                                            alignment: Alignment.centerRight,
                                            onPressed: () {},
                                            icon: SvgPicture.asset(
                                                "assets/icon/see_more.svg"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                height: 46,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 14,
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 6),
                                            child: SvgPicture.asset(
                                              "assets/icon/location.svg",
                                              height: 16,
                                            ),
                                          ),
                                          const Text(
                                            "davtashen",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    154, 154, 154, 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 14),
                                      child: Row(
                                        children: const [
                                          Text("10:55",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      154, 154, 154, 1))),
                                          Text(" - ",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      154, 154, 154, 1))),
                                          Text("15:44",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      154, 154, 154, 1))),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget buildsheet(bool keyBool) => Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          width: double.infinity,
          height: 234,
          decoration: BoxDecoration(color: Color.fromRGBO(38, 38, 38, 1)),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 79,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        "Ցանկանու՞մ եք ջնջել ծանուցումը",
                        style: TextStyle(
                            color: Color.fromRGBO(112, 112, 112, 1),
                            fontSize: 14),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          if (keyBool == true) {
                            blocNotification
                                .add(NotificationDelete(id: listDelete));
                            print(listDelete);
                            Navigator.of(context).pop();

                            setState(() {
                              hide = false;
                            });
                            print(listDelete);
                          } else if (keyBool == false) {
                            blocNotification.add(NotificationDelete(id: []));
                            Navigator.of(context).pop();
                            setState(() {
                              deleteAll = true;
                              hide = false;
                            });
                          }

                          //listDelete.clear();
                        },
                        child: const Text("Ջնջել",
                            style: TextStyle(
                                color: Color.fromRGBO(255, 53, 53, 1),
                                fontSize: 18)))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 13),
                child: Container(
                    width: double.infinity,
                    height: 39,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: TextButton(
                      child: const Text(
                        "Չեղարկել",
                        style: TextStyle(
                            color: Color.fromRGBO(12, 128, 64, 1),
                            fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )),
              ),
            ],
          ),
        ),
      );
  Widget buildMenuItem(BuildContext context) => TextButton(
        onPressed: () {},
        child: const Text("See More"),
      );
  Widget deleteAllItem(BuildContext context) => TextButton(
        child: const Text("Delete All", style: TextStyle(color: Colors.white)),
        onPressed: () {
          showModalDeleteDialog(context, false);
        },
      );
  Widget deleteItem(BuildContext context, NotificationFetchSuccses state) =>
      TextButton(
        child: const Text("Delete", style: TextStyle(color: Colors.white)),
        onPressed: () {
          showModalDeleteDialog(context, true);
        },
      );
  Future<dynamic> showModalDeleteDialog(BuildContext context, bool keyBool) {
    return showModalBottomSheet(
      elevation: 0,
      barrierColor: Color.fromRGBO(38, 38, 38, 1),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => buildsheet(keyBool),
    );
  }
}
