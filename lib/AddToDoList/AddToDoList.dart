import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ToDoApiServices/ToDoApiServices.dart';

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
    var controller = Get.find<ToDoApiServicesController>();
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
            onPressed:()async{
              await isEdit ? controller.editData(
              titleController.text,descController.text, widget.todo)
              : controller.submitData(titleController.text, descController.text);
            }, 
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(child: Text(isEdit ? "Edit" :"Submit",style: TextStyle(fontSize: 20),),),
            ))
        ]),
    );

  }
 
}