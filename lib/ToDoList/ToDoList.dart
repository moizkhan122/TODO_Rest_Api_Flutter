import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../AddToDoList/AddToDoList.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTODOData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("ToDo list",style: TextStyle(fontSize: 20,color: Colors.white)),
      ),
      body: RefreshIndicator(
        onRefresh: getTODOData,
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index)
             => Padding(
               padding: const EdgeInsets.all(8.0),
               child: Card(
                         child: ListTile(
                title: Text(items[index]['title']),
                subtitle: Text(items[index]['description']),
                         ),
                       ),
             )),
        ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddToDoList(),));
        }, label: const Text("Add ToDo")),
    );
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
       setState(() {
         items = result;
       });
      } else {
        //show error
      }
  }
}