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
  bool isloading = true;
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
      body: Visibility(
        visible: isloading,
        child: const Center(child: CircularProgressIndicator(color: Colors.white,)),
        replacement: RefreshIndicator(
          onRefresh: getTODOData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement:  Center(child: Text("No Items In TODO",
            style: Theme.of(context).textTheme.headlineMedium,),),
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index)
                 => Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Card(
                         child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Text((index+1).toString(),style: TextStyle(fontSize: 18,color: Colors.white),),
                            ),
                            title: Text(items[index]['title']),
                            subtitle: Text(items[index]['description']),
                            trailing: PopupMenuButton(
                              onSelected: (value){
                                // on press method
                                if (value == 'edit') {
                                  //perform edit task
                                  navigateToEditPage(items[index]);
                                } else if (value == 'delete'){
                                  //perform delete task
                                    deleteId(items[index]['_id']);
                                }
                              },
                              itemBuilder: (context){
                                return [
                                  PopupMenuItem(
                                    value: "edit",
                                    child: const Text("Edit")),
                                    PopupMenuItem(
                                    value: "delete",
                                    child: const Text("Delete"))
                                ];
                              },),
                             ),
                           ),
                 )),
          ),
          ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage, label: const Text("Add ToDo")),
    );
  }
  
  /////////////////////////////Add page
  Future<void> navigateToEditPage(Map item)async{
       await Navigator.push(context, MaterialPageRoute(builder: (context) =>  AddToDoList(todo : item),));
      setState(() {
         isloading = true;
       });
       getTODOData();
  }

  /////////////////////////////Add page
  Future<void> navigateToAddPage()async{
       await Navigator.push(context, MaterialPageRoute(builder: (context) =>  AddToDoList(),));
       setState(() {
         isloading = true;
       });
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
       setState(() {
         items = result;
       });
      }
      setState(() {
      isloading = false;
    });
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
       setState(() {
         items = filterd;
       });
      } else {
        //show error
      }
     }
}