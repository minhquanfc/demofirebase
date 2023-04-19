import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeOk extends StatelessWidget {
  final inSert;
  final _textController = TextEditingController();

  HomeOk({Key? key, this.inSert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Enter text',
                ),
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
