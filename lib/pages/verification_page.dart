import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsappclone/components/otp_text_field.dart';
import 'package:whatsappclone/consts.dart';
import 'package:whatsappclone/main.dart';

class VerificationPage extends StatefulWidget {
  final String phoneNumber;
  final ConfirmationResult? confirmationResult;
  final String? vID;

  const VerificationPage(
      {Key? key, this.confirmationResult, this.vID, required this.phoneNumber})
      : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController masterTextEditingController = TextEditingController();
  bool canResend = false;
  int counter = 60;

  bool isBusy = false;
  Stream<int> x = Stream.periodic(Duration(seconds: 1), (xx) => xx);
  StreamSubscription<int>? y;
  @override
  void initState() {
    // TODO: implement initState
    masterTextEditingController.addListener(() {
      if (masterTextEditingController.text.length > 5) {
        //debugPrint("6");
        showVerificationDialog();
      }
    });
    y = x.listen((event) {
      if (counter == 0) {
        setState(() {
          canResend = true;
        });
      } else {
        setState(() {
          counter--;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    y?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<UserProvider>(context).currentUser != null) {
      //Navigator.of(context).pushReplacementNamed("/");
    }
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
          "Verifying your number",
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
                    text: "Waiting to automatically detect an SMS sent to ",
                    children: [
                      TextSpan(
                          text: widget.phoneNumber,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ". "),
                      TextSpan(
                          text: "Wrong number?",
                          style: TextStyle(color: Colors.blue)),
                    ])),
          ),
          OtpTextField(
              masterTextEditingController: masterTextEditingController),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Enter 6-digit code.",
              style:
                  Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),
            ),
          ),
          ListTile(
            enabled: canResend,
            leading: Icon(Icons.sms),
            title: Text("Resend SMS"),
            trailing: Text(counter < 10 ? "0:0${counter}" : "0:${counter}"),
            onTap: () async {
              if (isBusy) {
                return;
              }
              isBusy = true;
              if (kIsWeb) {
                FirebaseAuthException? cError;
                ConfirmationResult? confirmationResult;
                try {
                  confirmationResult = await FirebaseAuth.instance
                      .signInWithPhoneNumber(widget.phoneNumber);
                } catch (e) {
                  debugPrint(e.toString());
                  isBusy = false;
                  return;
                }
                Provider.of<UserProvider>(context, listen: false).provided(
                    phoneNumber: widget.phoneNumber,
                    confirmationResult: confirmationResult);
                setState(() {
                  canResend = false;
                  counter = 60;
                });
              } else {
                try {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: widget.phoneNumber,
                      verificationCompleted: (phoneAuthCreds) async {
                        await FirebaseAuth.instance
                            .signInWithCredential(phoneAuthCreds);
                      },
                      verificationFailed: (ex) {
                        debugPrint("verificationFailed" + ex.toString());
                      },
                      codeSent: (vID, resendToken) {
                        setState(() {
                          canResend = false;
                          counter = 60;
                        });
                      },
                      timeout: Duration(minutes: 1),
                      codeAutoRetrievalTimeout: (vID) {});
                } catch (e) {
                  debugPrint(e.toString());
                }
              }
              isBusy = false;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Divider(color: Colors.black45),
          ),
          ListTile(
            enabled: false,
            leading: Icon(Icons.call),
            title: Text("Call me"),
            trailing: Text("0:00"),
          ),
        ],
      )),
    );
  }

  showVerificationDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: FutureBuilder(
                future: verifyCode(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Row(
                      children: [
                        CircularProgressIndicator(),
                        Container(height: 16, width: 16),
                        Text("Verifying..")
                      ],
                    );
                  } else if (snapshot.data.toString().contains("Error: ")) {
                    return Text(snapshot.data.toString());
                  } else {
                    Navigator.of(context).pop();
                    return Text(
                        FirebaseAuth.instance.currentUser?.phoneNumber ?? "x");
                  }
                },
              ),
            ));
  }

  Future<String?> verifyCode() async {
    try {
      if (kIsWeb) {
        await widget.confirmationResult!
            .confirm(masterTextEditingController.text);
      } else {
        PhoneAuthCredential x = PhoneAuthProvider.credential(
            verificationId: widget.vID!,
            smsCode: masterTextEditingController.text);
        await FirebaseAuth.instance.signInWithCredential(x);
      }
    } catch (e) {
      return "Error: ${e.toString().split("]").last}";
    }
  }
}
