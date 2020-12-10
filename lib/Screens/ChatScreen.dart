import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_ui_chat/Utils/Message.dart';
import 'package:intl/intl.dart';

class MyChatScreen extends StatefulWidget {
  const MyChatScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyChatState createState() => new _MyChatState();
}

class _MyChatState extends State<MyChatScreen> {

  final List<Message> _messages = <Message>[];
  var width ,height;
  final _textController = TextEditingController();
  bool isSendMoney = false ;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height= MediaQuery.of(context).size.height;
    DateTime time = DateTime.now();
    String formattedDate = DateFormat('hh:mm').format(time);
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
                  buildListOfMessages(),
                  new Divider(height: 1.0),
                  buildBottomBar(formattedDate),
                ],
              ),
            )));
  }

  Widget buildListOfMessages(){
    return Flexible(
      child: new ListView.builder(
        padding: new EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (_, int index) => _messages[index],
        itemCount: _messages.length,
      ),
    );
  }

  void _sendMsg(String msg, String messageDirection, String date) {
    if (msg.length == 0) {
    print('do anything');
    } else {
      _textController.clear();
      Message message = new Message(
        msg: msg,
        direction: messageDirection,
        dateTime: date,
      );
      setState(() {
        _messages.insert(0, message);
        isSendMoney = false ;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
              onPressed: () {

              },
            ),
            CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/profile.png')
            ),
            Text("Gbemiosla Adegbite" , style: TextStyle(color: Colors.black),),
            IconButton(
              icon: isSendMoney ?  Image.asset('assets/images/greenbtn.png')  : Image.asset('assets/images/greybtn.png'),
              onPressed: () {
                //change color of bottom bar
                setState(() {
                  isSendMoney = true ;
                });

              },
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


  Widget buildBottomBar(String formattedDate) {
    return Center(
      child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: IconTheme(
              data: IconThemeData(color: Theme.of(context).accentColor),
              child: Container(
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => print('hello'),
                      child: Container(
                        child:   IconButton(
                          icon: Image.asset('assets/images/add.png',width: 20,height: 20,),
                          onPressed: () {
                            _sendMsg(
                                _textController.text,
                                'right',
                                formattedDate);
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin:EdgeInsets.all(5.0),
                      width: width*0.7,
                      height: 40,
                      decoration: new BoxDecoration (
                          border: Border.all(color: Colors.black38),
                          borderRadius:  BorderRadius.all(Radius.circular(20.0)),
                          color: isSendMoney ? Colors.green : Colors.white
                      ),
                      child :
                      Container(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: [
                            Flexible(
                              child :TextField(
                                style: TextStyle(color: isSendMoney ? Colors.white : Colors.grey),
                                controller: _textController,
                                decoration: new InputDecoration.collapsed(hintText: ""),
                              ),
                            ),
                            IconButton(
                              icon: Image.asset('assets/images/cam.png',width: 30,height: 30,),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: new IconButton(
                          icon: Image.asset(
                              "assets/images/send.png"),
                          onPressed: () =>
                              _sendMsg(
                                  _textController.text,
                                  'left',
                                  formattedDate)),
                    ),
                  ],
                ),
              ))),
    );


  }


  void sendAttach(){



  }




}
