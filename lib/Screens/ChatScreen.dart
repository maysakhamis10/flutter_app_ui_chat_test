import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_ui_chat/Utils/Message.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class MyChatScreen extends StatefulWidget {
  const MyChatScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyChatState createState() => new _MyChatState();
}

class _MyChatState extends State<MyChatScreen> {

  final List<Message> _messages = <Message>[];
  var width ;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    DateTime time = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(time);
    return  Scaffold(
      appBar: AppBar(
        actions: [
          buildAppABar()
        ],
      ),
        body:  Container(
            width: double.infinity,
            height: double.infinity,
            color: Color(0xff11386B),
            child: new Container(
              child: new Column(
                children: <Widget>[
                  new Flexible(
                    child: new ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) => _messages[index],
                      itemCount: _messages.length,
                    ),
                  ),
                  new Divider(height: 1.0),
                  new Container(
                      decoration:
                          new BoxDecoration(color: Theme.of(context).cardColor),
                      child: new IconTheme(
                          data: new IconThemeData(
                              color: Theme.of(context).accentColor),
                          child: new Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: new Row(
                              children: <Widget>[
                                //left send button
                                new Container(
                                  width: 48.0,
                                  height: 48.0,
                                  child: new IconButton(
                                      icon: Image.asset(
                                          "assets/images/send_in.png"),
                                      onPressed: () => _sendMsg(
                                          _textController.text,
                                          'left',
                                          formattedDate)),
                                ),

                                //Enter Text message here
                                new Flexible(
                                  child: new TextField(
                                    controller: _textController,
                                    decoration: new InputDecoration.collapsed(
                                        hintText: "Enter message"),
                                  ),
                                ),

                                //right send button

                                new Container(
                                  margin:
                                      new EdgeInsets.symmetric(horizontal: 2.0),
                                  width: 48.0,
                                  height: 48.0,
                                  child: new IconButton(
                                      icon: Image.asset(
                                          "assets/images/send_out.png"),
                                      onPressed: () => _sendMsg(
                                          _textController.text,
                                          'right',
                                          formattedDate)),
                                ),
                              ],
                            ),
                          ))),
                ],
              ),
            )));
  }

  void _sendMsg(String msg, String messageDirection, String date) {
    if (msg.length == 0) {
      Fluttertoast.showToast(
          msg: "Please Enter Message",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue);
    } else {
      _textController.clear();
      Message message = new Message(
        msg: msg,
        direction: messageDirection,
        dateTime: date,
      );
      setState(() {
        _messages.insert(0, message);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    // Clean up the controller when the Widget is disposed
    _textController.dispose();
    super.dispose();
  }


  Widget buildAppABar(){
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Image.asset('assets/images/backbtn.png'),
              //iconSize: 50,
              onPressed: () {},
            ),
            CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/profile.png')
            ),
            Text("Gbemiosla Adegbite" , style: TextStyle(color: Colors.black),),
            IconButton(
              icon: Image.asset('assets/images/greenbtn.png'),
              //iconSize: 50,
              onPressed: () {},
            ),
            IconButton(
              icon: Image.asset('assets/images/btnmoney.png'),
             // iconSize: 50,
              onPressed: () {},
            )

          ],
        ),
    );
  }
}
