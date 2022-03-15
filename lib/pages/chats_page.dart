import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupic;
import 'package:whatsappclone/consts.dart';
import 'package:whatsappclone/pages/chat_page.dart';
import 'package:whatsappclone/pages/select_contact_page.dart';
import 'package:whatsappclone/pages/welcome_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage>
    with SingleTickerProviderStateMixin {
  late TabController mTabBarController;
  @override
  void initState() {
    // TODO: implement initState
    mTabBarController = TabController(length: 4, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          QueryDocumentSnapshot<Map<String, dynamic>>? chattoPush =
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SelectContactPage()));
          if (chattoPush != null) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatPage(friend: chattoPush)));
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
              ListView(
                children: defaultListTiles(),
              ),
              Center(child: Text("Unavailable")),
              Center(child: Text("Unavailable")),
            ],
            controller: mTabBarController,
          ),
        ),
      ),
    );
  }

  defaultListTiles() {
    return {
      for (var i = 0; i < 50; i++) {i}
    }
        .map((e) => InkWell(
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
                              backgroundImage:
                                  AssetImage("assets/images/placeholder.png"),
                              radius: MediaQuery.of(context).size.width / 16),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Icon(
                              Icons.check_circle,
                              color: kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Chat Title ${e.first}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                Container(
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
                                  "Last Message Sent!",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "16:27",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ))
        .toList();
  }
}
