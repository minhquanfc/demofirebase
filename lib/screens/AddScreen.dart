import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddScreen extends StatefulWidget {
  const AddScreen( {Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm Todo",style: TextStyle(color: Colors.black),),
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
                String title = _textController.text;
                inSert(title);
              },
              child: Text("Thêm"),
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

  void inSert(title) async {
    if (title.isEmpty) {
      return showToast("Vui lòng không để trống");
    }
    final idUser = FirebaseAuth.instance.currentUser?.uid;
    final databaseRef = FirebaseDatabase.instance.ref().child("Todos");
    String keyid = databaseRef.push().key!;
    var datas = {'id': keyid, 'title': title,'createdAt':ServerValue.timestamp,};
    await databaseRef.child(idUser!).child(keyid).set(datas);
    Navigator.pop(context);
  }
  void showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[600],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
