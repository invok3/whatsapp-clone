//0597022364

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whatsappclone/consts.dart';
import 'package:whatsappclone/main.dart';
import 'package:whatsappclone/pages/verification_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController ccTEC = TextEditingController(text: " ");
  TextEditingController pnTEC = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: Colors.black38,
              ))
        ],
        title: Text(
          "Enter your phone number",
          style: TextStyle(color: kPrimaryColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
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
                      text: "WhatsApp will need to verify your phone number. ",
                      children: [
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                debugPrint("show my number hint");
                              },
                            text: "What's my number?",
                            style: TextStyle(color: Colors.blue)),
                      ])),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .66,
              constraints: BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  TextField(
                    textAlign: TextAlign.center,
                    readOnly: true,
                    decoration: InputDecoration(
                      // suffix: Icon(Icons.arrow_drop_down),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      prefixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.transparent,
                      ),
                    ),
                    controller: TextEditingController(text: "Select Country"),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Focus(
                          onFocusChange: ((value) {
                            if (!value) {
                              if (ccTEC.text.length == 0) {
                                ccTEC.text = " ";
                              }
                            }
                          }),
                          child: TextField(
                            onTap: () {
                              if (ccTEC.text == " ") {
                                ccTEC.text = "";
                              }
                            },
                            maxLength: 3,
                            controller: ccTEC,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              counterText: "",
                              prefixText: "+",
                            ),
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 11,
                        child: TextField(
                          controller: pnTEC,
                          decoration: InputDecoration(hintText: "phone number"),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Carrier charges may apply",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  //
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2))))),
                onPressed: () {
                  var pn = "+${ccTEC.text}${pnTEC.text}";
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: FutureBuilder(
                              future: sendOTP(pn),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      Container(
                                        width: 16,
                                        height: 16,
                                      ),
                                      Text("Connecting..")
                                    ],
                                  );
                                } else if (snapshot.data
                                    .toString()
                                    .contains("Error: ")) {
                                  return Text(snapshot.data.toString());
                                } else {
                                  Navigator.of(context).pop();
                                  return Text("Message Sent!");
                                }
                              },
                            ),
                          ));
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

  Future sendOTP(String pn) async {
    if (kIsWeb) {
      FirebaseAuthException? cError;
      ConfirmationResult? confirmationResult;
      try {
        confirmationResult =
            await FirebaseAuth.instance.signInWithPhoneNumber(pn);
      } catch (e) {
        debugPrint(e.toString());
        return "Error: ${e.toString().split("]").last}";
      }
      Provider.of<UserProvider>(context, listen: false)
          .provided(phoneNumber: pn, confirmationResult: confirmationResult);

      //await confirmationResult.confirm("verificationCode");
    } else {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: pn,
            verificationCompleted: (phoneAuthCreds) async {
              await FirebaseAuth.instance.signInWithCredential(phoneAuthCreds);
            },
            verificationFailed: (ex) {
              debugPrint("FBVFEX" + ex.toString());
            },
            codeSent: (vID, resendToken) {
              Provider.of<UserProvider>(context, listen: false)
                  .provided(phoneNumber: pn, vID: vID);
            },
            timeout: Duration(minutes: 1),
            codeAutoRetrievalTimeout: (vID) {});
      } catch (e) {
        debugPrint("FBAEX" + e.toString());
        return "Error: ${e.toString().split("]").last}";
      }
    }
  }
}
