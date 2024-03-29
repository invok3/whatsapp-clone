import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/consts.dart';

class ChatPage extends StatefulWidget {
  final DataSnapshot friend;
  const ChatPage({Key? key, required this.friend}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  List<DataSnapshot> messages = [];
  StreamSubscription<DatabaseEvent>? chatListener;
  @override
  void initState() {
    // TODO: implement initState
    messageController.addListener(() {
      setState(() {});
    });
    chatListener = FirebaseDatabase.instance
        .ref()
        .child(
            "users/${FirebaseAuth.instance.currentUser!.phoneNumber}/messages/${widget.friend.ref.path.split("/").last.replaceAll("%2B", "+")}")
        .onChildAdded
        .listen((event) {
      setState(() {
        messages.add(event.snapshot);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    chatListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leadingWidth: 24,
        // leading: IconButton(
        //     visualDensity: VisualDensity.compact,
        //     onPressed: () => Navigator.of(context).pop,
        //     icon: Icon(Icons.arrow_back)),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/placeholder.png"),
              foregroundImage: widget.friend.child("profileImage").value == null
                  ? null
                  : NetworkImage(
                      widget.friend.child("profileImage").value.toString()),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.friend.child("username").value}"),
                Text(
                  "Last Seen ",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/wbg.jpg"),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: messages
                        .map((e) => BubbleSpecialOne(
                              text: e.child("message").value.toString(),
                              isSender: e.child("sender").value !=
                                  widget.friend.ref.path
                                      .split("/")
                                      .last
                                      .replaceAll("%2B", "+"),
                              color: e.child("sender").value ==
                                      widget.friend.ref.path
                                          .split("/")
                                          .last
                                          .replaceAll("%2B", "+")
                                  ? Colors.white
                                  : Color(0xffd9fdd3),
                              sent: true,
                            ))
                        .toList(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        //maxLines: 10,
                        decoration: InputDecoration(
                            //isCollapsed: true,
                            isDense: true,
                            hintText: "Message",
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_file,
                                  color: Colors.grey,
                                ),
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 12,
                                )
                              ],
                            ),
                            prefixIcon: Icon(Icons.emoji_emotions_outlined),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: .5, color: Colors.black26),
                                borderRadius: BorderRadius.circular(500)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: .5, color: Colors.black26),
                                borderRadius: BorderRadius.circular(500)),
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: .5, color: Colors.black26),
                                borderRadius: BorderRadius.circular(500)),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: .5, color: Colors.black26),
                                borderRadius: BorderRadius.circular(500)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: .5, color: Colors.black26),
                                borderRadius: BorderRadius.circular(500)),
                            fillColor: Colors.white,
                            filled: true),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (messageController.text.isEmpty) {
                          return;
                        }
                        String ts =
                            Timestamp.now().millisecondsSinceEpoch.toString();
                        String sender =
                            FirebaseAuth.instance.currentUser!.phoneNumber!;
                        String receiver = widget.friend.ref.path
                            .split("/")
                            .last
                            .replaceAll("%2B", "+");
                        FirebaseDatabase.instance
                            .ref()
                            .child('users/$receiver/messages/$sender/$ts')
                            .set({
                          "sender": sender,
                          "receiver": receiver,
                          "message": messageController.text,
                          "time": ts
                        });
                        FirebaseDatabase.instance
                            .ref()
                            .child('users/$sender/messages/$receiver/$ts')
                            .set({
                          "sender": sender,
                          "receiver": receiver,
                          "message": messageController.text,
                          "time": ts.toString()
                        });
                        messageController.text = "";
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          messageController.text.isEmpty
                              ? Icons.mic
                              : Icons.send,
                          size: 20,
                        ),
                      ),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          shape: MaterialStateProperty.all(CircleBorder())),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
