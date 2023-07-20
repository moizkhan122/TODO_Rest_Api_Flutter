import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ToDoApiServices/ToDoApiServices.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var contro = Get.put(ToDoApiServicesController());
    contro.getTODOData();
  }
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ToDoApiServicesController>();
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("ToDo list",style: TextStyle(fontSize: 20,color: Colors.white)),
      ),
      body: Obx(
        ()=> Visibility(
          visible: controller.isloading.value,
          child: const Center(child: CircularProgressIndicator(color: Colors.white,)),
          replacement: RefreshIndicator(
            onRefresh: controller.getTODOData,
            child: Visibility(
              visible: controller.items.isNotEmpty,
              replacement:  Center(child: Text("No Items In TODO",
              style: Theme.of(context).textTheme.headlineMedium,),),
              child: ListView.builder(
                  itemCount: controller.items.length,
                  itemBuilder: (context, index)
                   => Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Card(
                           child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Text((index+1).toString(),style: const TextStyle(fontSize: 18,color: Colors.white),),
                              ),
                              title: Text(controller.items[index]['title']),
                              subtitle: Text(controller.items[index]['description']),
                              trailing: PopupMenuButton(
                                onSelected: (value){
                                  // on press method
                                  if (value == 'edit') {
                                    //perform edit task
                                    controller.navigateToEditPage(controller.items[index],context);
                                  } else if (value == 'delete'){
                                    //perform delete task
                                      controller.deleteId(controller.items[index]['_id']);
                                  }
                                },
                                itemBuilder: (context){
                                  return [
                                    const PopupMenuItem(
                                      value: "edit",
                                      child: Text("Edit")),
                                      const PopupMenuItem(
                                      value: "delete",
                                      child: Text("Delete"))
                                  ];
                                },),
                               ),
                             ),
                   )),
            ),
            ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){controller.navigateToAddPage(context);}, label: const Text("Add ToDo")),
    );
  }
  
  
  
  
 
}