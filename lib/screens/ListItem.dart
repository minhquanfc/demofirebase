import 'package:demofirebase/screens/UpdateScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ListTodo extends StatefulWidget {
  const ListTodo({Key? key}) : super(key: key);

  @override
  State<ListTodo> createState() => _ListTodoState();
}

class _ListTodoState extends State<ListTodo> {
  final databaseRef = FirebaseDatabase.instance.ref("Todos");
  late List<dynamic> _todos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text("Todo List", style: TextStyle(color: Colors.black)),
        ),
        body: Container(
          child: StreamBuilder(
            stream: databaseRef.orderByChild('createdAt').onValue,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }else
              // Get the data from the snapshot
              // _todos = (snapshot.data!.snapshot.value as Map<dynamic, dynamic>)
              //     .values
              //     .toList();
              if(snapshot.data!.snapshot.value==null){
                return Center(child: Text("No data"));
              }
              Map<dynamic, dynamic> values = snapshot.data!.snapshot.value;
              _todos = values.values.toList();
              // Sort the list by createdAt in descending order
              _todos.sort((a, b) => a["createdAt"].compareTo(b["createdAt"])); // Sort the list in descending order based on timestamp

              return ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (BuildContext context, int index) {
                  // Build a ListTile for each item in the list
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 15, left: 15),
                    child: ListTile(
                      title: Text(_todos[index]['title']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateScreen(
                                            id_todo: _todos[index]['id'],
                                            title: _todos[index]['title'])));
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Bạn có muốn xóa không?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          handleDelete(_todos[index]["id"]);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      tileColor: Colors.white,
                    ),
                  );
                },
              );
            },
          ),
        ));
  }

  Future<void> getData() async {
    // databaseRef.onValue.listen((event) {
    //   // final data = event.snapshot.value;
    //   // final data = Map<String, dynamic>.from(
    //   //   event.snapshot.value as Map,
    //   // );
    //   // data.forEach((key, value) {
    //   //   _todos.add(value);
    //   // });
    //
    // }, onError: (eror) {});

    DatabaseEvent event = await databaseRef.once();
    // print(event.snapshot.value);
  }

  void handleDelete(id) async {
    print(id);
    await databaseRef.child(id).remove();
  }
}
