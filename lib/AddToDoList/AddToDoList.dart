import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class AddToDoList extends StatefulWidget {
   AddToDoList({super.key,this.todo});

  Map? todo;

  @override
  State<AddToDoList> createState() => _AddToDoListState();
}

class _AddToDoListState extends State<AddToDoList> {

  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todO = widget.todo;
    if (todO != null) {
        isEdit = true;
        final title = todO['title'];
        final desc = todO["description"];
         titleController.text = title;
         descController.text = desc;
      }
  }

  var titleController = TextEditingController();
  var descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: isEdit ? Text("Edit ToDo list",style: TextStyle(fontSize: 20,color: Colors.white))
         :Text("Add ToDo list",style: TextStyle(fontSize: 20,color: Colors.white)),
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
            onPressed:isEdit ? editData :submitData, 
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(child: Text(isEdit ? "Edit" :"Submit",style: TextStyle(fontSize: 20),),),
            ))
        ]),
    );

  }
  ////////////////////////////////////////////

  Future editData()async{
    final todo = widget.todo;
    if (todo == null) {
      print("You can not call update without todo data");
      return;
    }

    final id = todo['_id'];
    final title = titleController.text;
    final desc = descController.text;
    
        final body = {
      'title' : title,
      "description" : desc,
      "is_completed" : false,
    };
    //submit data on server
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final responce = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json'
      }
      );
      if (responce.statusCode == 200) {
          showSuccessMessage("Updated Success");
      } else {
        showErrorMessage("Update Error");
      }
  }

  ////////////////////////////////////////////
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
   if (responce.statusCode == 201) {
          showSuccessMessage("Form Submit Success");
      } else {
        showErrorMessage("Form Not Submit Error");
      }
  }

  void showSuccessMessage(message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 20.0
    );
  }
  void showErrorMessage(message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 20.0
    );
  }
}