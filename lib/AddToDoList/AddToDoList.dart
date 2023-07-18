import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToDoList extends StatefulWidget {
  const AddToDoList({super.key});

  @override
  State<AddToDoList> createState() => _AddToDoListState();
}

class _AddToDoListState extends State<AddToDoList> {
  var titleController = TextEditingController();
  var descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("ToDo list",style: TextStyle(fontSize: 20,color: Colors.white)),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20,),
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              hoverColor: Colors.white,
              fillColor: Colors.white,
              focusColor: Colors.white,
              hintText: "title"),
          ),
          TextFormField(
            controller: descController,
            decoration: const InputDecoration(
              hoverColor: Colors.white,
              fillColor: Colors.white,
              focusColor: Colors.white,
              hintText: "desc"),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: submitData, 
            child: const Center(child: Text("Submit",style: TextStyle(fontSize: 20),),))
        ]),
    );

  }
  Future submitData()async{
    //get the data from form
    final title = titleController.text;
    final desc = descController.text;

    final body = {
      'title' : title,
      "description" : desc,
      "is_completed" : false,
    };
    //submit data on server
    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final responce = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json'
      }
      );
    print(responce.statusCode);
    print(responce.body);
  }
}