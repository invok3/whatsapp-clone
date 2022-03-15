import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsappclone/consts.dart';
import 'package:whatsappclone/main.dart';
import 'package:whatsappclone/pages/register_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to WhatsApp",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: kPrimaryColor),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: MediaQuery.of(context).size.width >
                          MediaQuery.of(context).size.height
                      ? MediaQuery.of(context).size.height / 4
                      : MediaQuery.of(context).size.width / 4,
                  foregroundImage: AssetImage('assets/images/wbg.jpg'),
                )
              ],
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 12,
                  vertical: 16),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontSize: 14),
                      text: "Read our ",
                      children: [
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                debugPrint("Show Privacy Policy");
                              },
                            text: "Privacy Policy",
                            style: TextStyle(color: Colors.blue)),
                        TextSpan(
                            text:
                                ". Tap \"Agree and continue\" to accept the "),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                debugPrint("Show Terms of Service");
                              },
                            text: "Terms of Service",
                            style: TextStyle(color: Colors.blue)),
                        TextSpan(text: ".")
                      ])),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2))))),
                onPressed: () {
                  Provider.of<UserProvider>(context, listen: false).accepted();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 10,
                      vertical: 10),
                  child: Text("AGREE AND CONTINUE"),
                )),
            Container(height: 48),
          ],
        ),
      ),
    );
  }
}
