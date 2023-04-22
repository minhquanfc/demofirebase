import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UpdateScreen extends StatefulWidget {
  final String id_todo;
  final String title;

  UpdateScreen({required this.id_todo, required this.title});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _textController = TextEditingController();
  String get id_todo => widget.id_todo;
  String get title => widget.title;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController.text = title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sửa Todo",style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                      labelText: "Nhập Todo",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: ElevatedButton(
                  onPressed: () {
                    String titles = _textController.text;
                    if (titles.isEmpty) {
                      print("Vui lòng không để trống");
                    } else {
                      Update(id_todo, titles);
                    }
                  },
                  child: Text("Sửa"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    minimumSize:
                    MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
                  ),
                ),
              )
            ],
          )),
    );
  }
  void Update(id,title) async {
    final databaseRef = FirebaseDatabase.instance.ref("Todos");
    var datas = {'title': title};
    await databaseRef.child(id).update(datas);
    Navigator.pop(context);
  }
}
