import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsappclone/main.dart';
import 'package:whatsappclone/pages/chats_page.dart';
import 'package:whatsappclone/pages/chosename_page.dart';
import 'package:whatsappclone/pages/register_page.dart';
import 'package:whatsappclone/pages/verification_page.dart';
import 'package:whatsappclone/pages/welcome_page.dart';

class StateManager extends StatelessWidget {
  const StateManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.of<UserProvider>(context).loadingUser == true
        ? Scaffold(
            body: SafeArea(
                child: Center(
              child: CircularProgressIndicator(),
            )),
          )
        : Provider.of<UserProvider>(context).currentUser != null
            ? Provider.of<UserProvider>(context).currentUser!.displayName ==
                    null
                ? ChoseNamePage()
                : ChatsPage()
            : Provider.of<UserProvider>(context).acceptedU == false
                ? WelcomePage()
                : Provider.of<UserProvider>(context).phoneNumberU == null
                    ? RegisterPage()
                    : VerificationPage(
                        phoneNumber:
                            Provider.of<UserProvider>(context).phoneNumberU!,
                        confirmationResult: Provider.of<UserProvider>(context)
                            .confirmationResultU,
                        vID: Provider.of<UserProvider>(context).vIDU,
                      );
  }
}
