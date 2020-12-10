import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_ui_chat/Utils/Message.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'TakeAPicutre.dart';

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
  BehaviorSubject<bool> streamControllerForRecording = BehaviorSubject<bool>();
  Recording _recording = new Recording();

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

  void _sendMsg(String msg, String messageDirection, String date ,
      bool isAttach , String attachPath , bool isAudio) {
    if(msg.length==0&& attachPath.length==0){
      print('do anything');
    }
    else {
      _textController.clear();
      Message message = new Message(
        msg: msg,
        filePath: attachPath,
        direction: messageDirection,
        dateTime: date,
        isAttach: isAttach,
        isAudio: isAudio ,
      );
      setState(() {
        _messages.insert(0, message);
        isSendMoney = false;
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
                    // GestureDetector(
                    //   onTap: () => print('hello'),
                    //   child: Container(
                    //     child:   IconButton(
                    //       icon: Image.asset('assets/images/add.png',width: 20,height: 20,),
                    //       onPressed: () {
                    //         _sendMsg(
                    //             _textController.text,
                    //             'right',
                    //             formattedDate);
                    //       },
                    //     ),
                    //   ),
                    // ),
                    Container(
                    //  margin:EdgeInsets.all(5.0),
                      width: width*0.6,
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
                              "assets/images/send.png",),
                          onPressed: () =>
                              _sendMsg(
                                  _textController.text,
                                  'left',
                                  formattedDate , false , '', false)),
                    ),
                    Container(
                      child: new IconButton(
                          icon: Image.asset(
                              "assets/images/camera.png",),
                          onPressed: ()async {
                            var firstCamera = await getCamera();
                            String imagePath = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return TakeAPicture(
                                    camera: firstCamera,
                                  );
                                }));
                            _sendMsg('','left',formattedDate,true , imagePath , false);
                          }
                      ),
                    ),
                    Container(
                      child:
                    Row(
                      children: [
                        StreamBuilder<bool>(
                          stream: streamControllerForRecording.stream,
                          initialData: false,
                          builder: (context, snap) {
                            return Visibility(
                              visible: !snap.data,
                              child: IconButton(
                                onPressed:() {
                                  start();
                                },
                                icon: Image.asset(
                                  "assets/images/audio.png",),
                              ),
                            );
                          },
                        ),
                        StreamBuilder<bool>(
                            stream: streamControllerForRecording.stream,
                            initialData: false,
                            builder: (context, snap) {
                              return Visibility(
                                visible: snap.data,
                                child: IconButton(
                                  onPressed:() {
                                    getFileAndShowIt();
                                  },
                                  icon: Icon(
                                      Icons.pause
                                  ),
                                ),
                              );
                            })
                      ],
                    )
                    ),
                  ],
                ),
              ))),
    );
  }


  start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        await AudioRecorder.start();
        bool isRecording = await AudioRecorder.isRecording;
        if (!streamControllerForRecording.isClosed)
          streamControllerForRecording.sink.add(isRecording);
        _recording = new Recording(duration: new Duration(), path: "");
      } else {
        print("doesn't have permission");
      }
    } catch (e) {
      print(e);
    }
  }
  getFileAndShowIt() async {
    String file = await stop();
    _sendMsg('','left', '' , false , file , true);
  }

  Future<String> stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = new File(recording.path);
    print("  File length: ${await file.length()}");
    if (!streamControllerForRecording.isClosed)
      streamControllerForRecording.sink.add(isRecording);
    _recording = recording;
    return file.path;
  }

  Future<CameraDescription> getCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    return firstCamera;
  }


}
