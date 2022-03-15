import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whatsappclone/consts.dart';
import 'package:whatsappclone/firebase_api.dart';
import 'package:whatsappclone/main.dart';

class ChoseNamePage extends StatefulWidget {
  const ChoseNamePage({Key? key}) : super(key: key);

  @override
  State<ChoseNamePage> createState() => _ChoseNamePageState();
}

class _ChoseNamePageState extends State<ChoseNamePage> {
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Profile info",
          style: TextStyle(color: kPrimaryColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(fontSize: 14),
                        text:
                            "Please provide your name and an optional profile photo",
                      )),
                ),
              ],
            ),
            // Container(
            //   clipBehavior: Clip.hardEdge,
            //   decoration: BoxDecoration(
            //       shape: BoxShape.rectangle,
            //       borderRadius: BorderRadius.circular(500)),
            //   width: MediaQuery.of(context).size.width / 3,
            //   height: MediaQuery.of(context).size.width / 3,
            //   child: Stack(
            //     children: [
            //       CircleAvatar(
            //         radius: MediaQuery.of(context).size.width / 3,
            //       ),
            //       Align(
            //         alignment: Alignment.bottomCenter,
            //         child: Container(
            //           width: MediaQuery.of(context).size.width / 3,
            //           color: Colors.red.withOpacity(.5),
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Icon(
            //               Icons.camera_alt,
            //               color: Colors.white,
            //             ),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // )
            Container(clipBehavior: Clip.hardEdge, decoration: BoxDecoration(shape: BoxShape.circle),
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.width / 4,
              child: Stack(
                children: [
                  CircleAvatar(
                    foregroundImage: Provider.of<UserProvider>(context)
                                .currentUser!
                                .photoURL ==
                            null
                        ? null
                        : NetworkImage(Provider.of<UserProvider>(context)
                            .currentUser!
                            .photoURL!),
                    backgroundColor: Colors.grey.withOpacity(.2),
                    radius: MediaQuery.of(context).size.width / 4,
                  ),
                  Provider.of<UserProvider>(context).currentUser!.photoURL ==
                          null
                      ? Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            iconSize: 36,
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Theme.of(context).textTheme.caption!.color,
                            ),
                            onPressed: () => changeProfilePhoto(),
                          ),
                        )
                      :
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            color: Colors.grey.withOpacity(.2),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: IconButton(
                                icon: Icon(Icons.camera_alt),
                                color: Colors.white.withOpacity(.5),
                                onPressed: () => changeProfilePhoto(),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: usernameController,
                      decoration:
                          InputDecoration(hintText: "Type your name here"),
                    ),
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Theme.of(context).textTheme.caption!.color,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2))))),
                onPressed: () async {
                  if (usernameController.text.isEmpty ||
                      usernameController.text.length < 4) {
                    //
                    return;
                  }
                 try {
                    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.phoneNumber)
                  .set({"username" : usernameController.text, "profileImage" : FirebaseAuth.instance.currentUser!.photoURL});
                 } catch (e) {
                   return;
                 }
                  await FirebaseAuth.instance.currentUser!
                      .updateDisplayName(usernameController.text);
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("NEXT"),
                )),
            Container(height: 48),
          ],
        ),
      ),
    );
  }

  changeProfilePhoto() async {
                              ImagePicker a = ImagePicker();
                              XFile? xFile = await a.pickImage(
                                  source: ImageSource.gallery);
                              if (xFile == null) {
                                debugPrint("Aborted!");
                                return;
                              }
                              debugPrint(
                                  "${FirebaseAuth.instance.currentUser?.phoneNumber}.${xFile.name.split('.').last}");
                              //return;
                              var xBytes = await xFile.readAsBytes();
                              String? xLink = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        content: FutureBuilder(
                                          future: FirebaseAPI.uploadPhoto(
                                              fileName:
                                                  "${FirebaseAuth.instance.currentUser?.phoneNumber}.${xFile.name.split('.').last}",
                                              fileData: xBytes),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState !=
                                                ConnectionState.done) {return Column(mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Row(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator()],),
                                                  ],
                                                ) }else{
                                                  Navigator.of(context).pop(snapshot.data);
                                                  return Container();
                                                }
                                          },
                                        ),
                                      ));
                                      debugPrint(xLink);
                                      await FirebaseAuth.instance.currentUser?.updatePhotoURL(xLink);
                                      }
}
