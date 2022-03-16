import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SelectContactPage extends StatefulWidget {
  const SelectContactPage({Key? key}) : super(key: key);

  @override
  State<SelectContactPage> createState() => _SelectContactPageState();
}

class _SelectContactPageState extends State<SelectContactPage> {
  DataSnapshot? docs;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
              body: SafeArea(
                  child: Center(
                child: CircularProgressIndicator(),
              )),
            );
          } else if (snapshot.data.toString().contains("Error: ")) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text("Select Contact"),
              ),
              body: SafeArea(
                  child: Center(
                child: Text("Unknown Error!\nWe're unable to fetch User list!"),
              )),
            );
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select Contact"),
                  Text(
                    (docs!.children.length - 1).toString() + " Contacts",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
              ],
            ),
            body: SafeArea(
              child: ListView(
                children: docs!.children
                    .map((e) => e.child("username").value ==
                            FirebaseAuth.instance.currentUser!.displayName
                        ? Container()
                        : InkWell(
                            onTap: () {
                              Navigator.of(context).pop(e);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.width / 8,
                                    width:
                                        MediaQuery.of(context).size.width / 8,
                                    child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/placeholder.png"),
                                        foregroundImage:
                                            e.child("profileImage").value !=
                                                    null
                                                ? NetworkImage(e
                                                    .child("profileImage")
                                                    .value
                                                    .toString())
                                                : null,
                                        radius:
                                            MediaQuery.of(context).size.width /
                                                16),
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
                                            "${e.child('username').value}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                          e.child('status').value != null
                                              ? Row(
                                                  children: [
                                                    Text(
                                                      e
                                                          .child('status')
                                                          .value
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                    .toList(),
              ),
            ),
          );
        });
  }

  Future<String?> fetchUsers() async {
    if (docs != null) {
      return null;
    } else {
      debugPrint("isNull");
    }
    try {
      DataSnapshot x =
          await FirebaseDatabase.instance.ref().child("info").get();
      //debugPrint(x.children.first.ref.path);
      setState(() {
        docs = x;
      });
      debugPrint("Users found: " + x.children.length.toString());
      return null;
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }
}
