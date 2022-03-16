import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/consts.dart';
import 'package:whatsappclone/pages/chat_page.dart';
import 'package:whatsappclone/pages/select_contact_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage>
    with SingleTickerProviderStateMixin {
  late TabController mTabBarController;
  DataSnapshot? info;
  StreamSubscription<DatabaseEvent>? convListener;
  StreamSubscription<DatabaseEvent>? newConvListener;
  StreamSubscription<DatabaseEvent>? infoListener;
  DataSnapshot? conversations;
  @override
  void initState() {
    // TODO: implement initState
    convListener = FirebaseDatabase.instance
        .ref()
        .child(
            "users/${FirebaseAuth.instance.currentUser!.phoneNumber}/messages")
        .onChildChanged
        .listen((event) {
      FirebaseDatabase.instance
          .ref()
          .child(
              "users/${FirebaseAuth.instance.currentUser!.phoneNumber}/messages")
          .get()
          .then((value) {
        setState(() {
          conversations = value;
        });
      });
    });
    newConvListener = FirebaseDatabase.instance
        .ref()
        .child(
            "users/${FirebaseAuth.instance.currentUser!.phoneNumber}/messages")
        .onChildAdded
        .listen((event) {
      FirebaseDatabase.instance
          .ref()
          .child(
              "users/${FirebaseAuth.instance.currentUser!.phoneNumber}/messages")
          .get()
          .then((value) {
        setState(() {
          conversations = value;
        });
      });
    });
    infoListener = FirebaseDatabase.instance
        .ref()
        .child("info")
        .onChildChanged
        .listen((event) {
      FirebaseDatabase.instance.ref().child("info").get().then((value) {
        setState(() {
          info = value;
        });
      });
    });

    mTabBarController = TabController(length: 4, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    convListener?.cancel();
    newConvListener!.cancel();
    infoListener!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DataSnapshot? chattoPush = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SelectContactPage()));
          if (chattoPush != null) {
            //debugPrint("Pushing: ${chattoPush.ref.path.split('/').last}");
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatPage(friend: chattoPush)));
            //     .then((value) {
            //   setState(() {});
            // });
          }
        },
        child: Icon(Icons.message),
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
              ],
              bottom: TabBar(
                onTap: (value) => mTabBarController.animateTo(value),
                labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                isScrollable: true,
                tabs: [
                  Tab(icon: Icon(Icons.camera_alt)),
                  Container(
                    width: (MediaQuery.of(context).size.width - 88) / 3,
                    child: Tab(text: "CHATS"),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width - 88) / 3,
                    child: Tab(text: "STATUS"),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width - 88) / 3,
                    child: Tab(text: "CALLS"),
                  ),
                ],
                controller: mTabBarController,
              ),
              title: Text("WhatsApp"),
              floating: true,
              pinned: true,
            ),
          ],
          body: TabBarView(
            children: [
              Center(child: Text("Unavailable")),
              FutureBuilder(
                  future: getConvs(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data.toString().contains("Error: ")) {
                      return Center(child: Text(snapshot.data.toString()));
                    }
                    return ListView(
                      children: conversations!.children.map((conv) {
                        String time = "";
                        var ts = DateTime.fromMillisecondsSinceEpoch(int.parse(
                            conv.children.last.child("time").value.toString()));
                        time = "${ts.day}/${ts.month}/${ts.year}";
                        var yesterday =
                            DateTime.now().subtract(Duration(days: 1));
                        if (ts.year == yesterday.year &&
                            ts.month == yesterday.month &&
                            ts.day == yesterday.day) {
                          time = "Yesterday ${ts.hour}:${ts.minute}";
                        }
                        yesterday = yesterday.add(Duration(days: 1));
                        if (ts.year == yesterday.year &&
                            ts.month == yesterday.month &&
                            ts.day == yesterday.day) {
                          time = "${ts.hour}:${ts.minute}";
                        }
                        return InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.width / 8,
                                  width: MediaQuery.of(context).size.width / 8,
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                          backgroundImage: AssetImage(
                                              "assets/images/placeholder.png"),
                                          foregroundImage: info!
                                                      .child(conv.ref.path
                                                          .split("/")
                                                          .last
                                                          .replaceAll(
                                                              "%2B", "+"))
                                                      .child("profileImage")
                                                      .value ==
                                                  null
                                              ? null
                                              : NetworkImage(info!
                                                  .child(conv.ref.path
                                                      .split("/")
                                                      .last
                                                      .replaceAll("%2B", "+"))
                                                  .child("profileImage")
                                                  .value
                                                  .toString()),
                                          radius: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              16),
                                      1 == 0
                                          ? Positioned(
                                              right: 0,
                                              bottom: 0,
                                              child: Icon(
                                                Icons.check_circle,
                                                color: kPrimaryColor,
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          info!
                                                      .child(conv.ref.path
                                                          .split("/")
                                                          .last)
                                                      .child("username")
                                                      .value ==
                                                  null
                                              ? ""
                                              : info!
                                                  .child(conv.ref.path
                                                      .split("/")
                                                      .last)
                                                  .child("username")
                                                  .value
                                                  .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        Row(
                                          children: [
                                            1 == 1
                                                ? Container()
                                                : Container(
                                                    width: 36,
                                                    height: 24,
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                          child: Icon(
                                                            Icons.check,
                                                            color: Colors.grey,
                                                          ),
                                                          right: 0,
                                                        ),
                                                        Center(
                                                          child: Icon(
                                                            Icons.check,
                                                            color: Colors.grey,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                            Text(
                                              conv.children.last
                                                  .child("message")
                                                  .value
                                                  .toString(),
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  time,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  })),
              Center(child: Text("Unavailable")),
              Center(child: Text("Unavailable")),
            ],
            controller: mTabBarController,
          ),
        ),
      ),
    );
  }

  Future<String?> getConvs() async {
    try {
      conversations = await FirebaseDatabase.instance
          .ref()
          .child(
              "users/${FirebaseAuth.instance.currentUser!.phoneNumber}/messages")
          .get();
      info = await FirebaseDatabase.instance.ref().child("info").get();
    } catch (e) {
      return "Error: ${e.toString()}";
    }
    // return {
    //   for (var i = 0; i < 50; i++) {i}
    // }
    // .map((e) => InkWell(
    //       onTap: () {},
    //       child: Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Row(
    //           children: [
    //             Container(
    //               height: MediaQuery.of(context).size.width / 8,
    //               width: MediaQuery.of(context).size.width / 8,
    //               child: Stack(
    //                 children: [
    //                   CircleAvatar(
    //                       backgroundImage:
    //                           AssetImage("assets/images/placeholder.png"),
    //                       radius: MediaQuery.of(context).size.width / 16),
    //                   Positioned(
    //                     right: 0,
    //                     bottom: 0,
    //                     child: Icon(
    //                       Icons.check_circle,
    //                       color: kPrimaryColor,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Expanded(
    //               child: Padding(
    //                 padding: EdgeInsets.symmetric(horizontal: 8.0),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       "Chat Title ${e.first}",
    //                       style: Theme.of(context)
    //                           .textTheme
    //                           .titleMedium!
    //                           .copyWith(fontWeight: FontWeight.w600),
    //                     ),
    //                     Row(
    //                       children: [
    //                         Container(
    //                           width: 36,
    //                           height: 24,
    //                           child: Stack(
    //                             children: [
    //                               Positioned(
    //                                 child: Icon(
    //                                   Icons.check,
    //                                   color: Colors.grey,
    //                                 ),
    //                                 right: 0,
    //                               ),
    //                               Center(
    //                                 child: Icon(
    //                                   Icons.check,
    //                                   color: Colors.grey,
    //                                 ),
    //                               )
    //                             ],
    //                           ),
    //                         ),
    //                         Text(
    //                           "Last Message Sent!",
    //                           style: TextStyle(color: Colors.grey),
    //                         )
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             Text(
    //               "16:27",
    //               style: TextStyle(color: Colors.grey),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ))
    // .toList();
  }
}
