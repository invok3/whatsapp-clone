import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/consts.dart';

class ChatPage extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> friend;

  const ChatPage({Key? key, required this.friend}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
              foregroundImage: widget.friend["profileImage"] == null
                  ? null
                  : NetworkImage(widget.friend["profileImage"]),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.friend['username']}"),
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
                child: Center(
                  child: Text("data"),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
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
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.send,
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
