import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsappclone/consts.dart';
import 'package:whatsappclone/state_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAcucych5rrcv5meCNYut4nDxVIjP-DIAU",
            appId: "whatsapp-clone-46892.firebaseapp.com",
            messagingSenderId: "441530631491",
            storageBucket: "whatsapp-clone-46892.appspot.com",
            projectId: "whatsapp-clone-46892"));
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider())
    ],
    child: MyApp(),
  ));
}

class UserProvider extends ChangeNotifier {
  bool loadingUser = true;
  bool acceptedU = false;
  User? currentUser;
  String? phoneNumberU;
  String? vIDU;
  ConfirmationResult? confirmationResultU;
  UserProvider() {
    FirebaseAuth.instance.userChanges().listen((event) {
      currentUser = event;
      loadingUser = false;
      notifyListeners();
    });
    //currentUser = FirebaseAuth.instance.currentUser
  }

  void accepted() {
    acceptedU = true;
    notifyListeners();
  }

  void provided(
      {required String phoneNumber,
      String? vID,
      ConfirmationResult? confirmationResult}) {
    phoneNumberU = phoneNumber;
    vIDU = vID;
    confirmationResultU = confirmationResult;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: kPrimaryColor),
      title: 'Whatsapp Clone',
      routes: {"/": (context) => StateManager()},
      initialRoute: "/",
    );
  }
}
