import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:w3_notes/services/notes_services.dart';
import 'package:w3_notes/pages/home.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => NotesServices(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
