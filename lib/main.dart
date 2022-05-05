import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teste1/models/myuser.dart';
import 'package:teste1/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:teste1/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA-Z0WPWzBa1iGKdT9zTd8tV3tO7L3bo2o",
      appId: "1:684208197278:android:9593b6437c1ae38a97758f",
      messagingSenderId: "project-684208197278",
      projectId: "teste1-eb631",
    ),
  );
  runApp( const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);


  @override
  Widget build(BuildContext context) {

    GoogleSignInAccount? user = _googleSignIn.currentUser;

    return  StreamProvider<MyUser?>.value(

      catchError: (_,__) {},
        initialData: null,
        value: AuthService().user,
        child: MaterialApp(debugShowCheckedModeBanner: false,
          home: const Wrapper(

          ),
        ),

    );
  }
}
