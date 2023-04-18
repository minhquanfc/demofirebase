import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeOk extends StatelessWidget {
  final inSert;
  final _textController = TextEditingController();

  HomeOk({Key? key, this.inSert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Enter text',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String text = _textController.text;
                inSert(text);
                _textController.clear();
              },
              child: Text('Insert'),
            ),
          ],
        ));
  }
}
