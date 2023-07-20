import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ToDoList/ToDoList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme : ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: TodoList(),
    );
  }
}

