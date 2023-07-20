
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../AddToDoList/AddToDoList.dart';

class ToDoApiServicesController extends GetxController{
  
  static void showSuccessMessage(message){
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
  static void showErrorMessage(message){
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

  ////////////Submit data to server / Api

   Future submitData(titlee,desct)async{
    //get the data from form
    final title = titlee;
    final desc = desct;

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

   ////////////////////////////////////////////

   Future editData(titlee,desct,todoo)async{
    final todo = todoo;
    if (todo == null) {
      print("You can not call update without todo data");
      return;
    }

    final id = todo['_id'];
    final title = titlee;
    final desc = desct;
    
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

//////////////////////////////////////////////////////////////////////Home page Get data and Delete Data
  
     var isloading = true.obs;
     var items = [].obs;

     /////////////////////////////Edit page
  Future<void> navigateToEditPage(Map item,context)async{
       await Navigator.push(context, MaterialPageRoute(builder: (context) =>  AddToDoList(todo : item),));
      isloading(true);
       getTODOData();
  }

  /////////////////////////////Add page
  Future<void> navigateToAddPage(context)async{
       await Navigator.push(context, MaterialPageRoute(builder: (context) =>  AddToDoList(),));
       isloading(true);
       getTODOData();
  }

  //////////////////////APi Get
  Future getTODOData()async{
    //get data from server
    const url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final responce = await http.get(
      uri);
      if (responce.statusCode == 200) {
        final json =  jsonDecode(responce.body) as Map;
        final result = json['items'] as List;

         items.value = result;
      }
      isloading(false);
  }

   /////////////////////////Delete Items form list and APi
     Future<void> deleteId(String id)async{
       //delete item from server
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final responce = await http.delete(
      uri);
      if (responce.statusCode == 200) {
       //remove item from list
       final filterd = items.where((element) => element['_id'] != id).toList(); 
      
         items.value = filterd;
      } else {
        //show error
      }
     }
}