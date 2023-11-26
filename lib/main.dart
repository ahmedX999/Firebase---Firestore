import 'package:atelier4_a_aittaleb_iir5g6/ListeProduits.dart';
import 'package:atelier4_a_aittaleb_iir5g6/firebase_options.dart';
import 'package:atelier4_a_aittaleb_iir5g6/login_ecran.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListeProduits(),
      ),
    );
  }
}