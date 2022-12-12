import 'package:flutter/material.dart';
import 'package:apps_5_crud_firestore/drivers/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:apps_5_crud_firestore/presentations/todo/screens/todo_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Flutter',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const TodoScreen(),
    );
  }
}
