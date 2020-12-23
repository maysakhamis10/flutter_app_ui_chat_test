import 'dart:io';
import 'package:file/local.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_ui_chat/Utils/AppColors.dart';
import 'package:flutter_app_ui_chat/Utils/Message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppColors.dart';
import 'TakeAPicutre.dart';
import 'package:permission_handler/permission_handler.dart';


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
  bool  _isSendMoney = false ;
  BehaviorSubject<bool> streamControllerForRecording = BehaviorSubject<bool>();
  Recording _recording = new Recording();
  LocalFileSystem localFileSystem;

  @override
  Widget build(BuildContext context) {
    width = ScreenUtil().screenWidth ;
    height = ScreenUtil().screenHeight;

    DateTime time = DateTime.now();
    String formattedDate = DateFormat('hh:mm').format(time);
    return Scaffold(
            appBar: AppBar(
              actions: [
                buildAppABar()
              ],
            ),
            body: Container(
                width: double.infinity,
                height: double.infinity,
                color: DARK_BLUE,
                child: new Container(
                  child: new Column(
                    children: <Widget>[
                      buildListOfMessages(),
                      new Divider(height: 1.0),
                      buildBottomBar(formattedDate),

                    ],
                  ),
                ))
        );
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
    
    
    if(msg.length==0 && attachPath.length==0){
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
        isMoney: _isSendMoney,
      );
      setState(() {
        _messages.insert(0, message);
        _isSendMoney = false;
      });
    }
  }

  @override
  void initState() {

    localFileSystem = localFileSystem ?? LocalFileSystem();
    checkPermissionStatus();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }



  @override
  void dispose() {
    streamControllerForRecording.close();
    super.dispose();
  }



  Widget buildAppABar(){
    return
    Container(
      width: ScreenUtil().screenWidth ,
      color: Colors.white,
      // padding: EdgeInsets.all(10.0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image(
            height: ScreenUtil().setHeight(14),
            width: ScreenUtil().setWidth(8),
            image:  AssetImage('assets/images/backbtn.png'),
          ),
          CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/profile.png',
              )
          ),
           Align(child:  Text("Gbemiosla Adegbite" , style: TextStyle(color: Colors.black),),
             alignment: Alignment.center,),
          IconButton(
            icon: _isSendMoney ?  Image.asset('assets/images/greenbtn.png')  : Image.asset('assets/images/greybtn.png'),
            onPressed: () {
              //change color of bottom bar
              setState(() {
                if(_isSendMoney){
                  _isSendMoney = false ;
                }
                else{
                  _isSendMoney = true ;
                }
              });

            },
          ),
          IconButton(
            icon: Image.asset('assets/images/btnmoney.png'),
            onPressed: () {},
          )
        ],

      ),

    );
  }


  Widget buildBottomBar(String formattedDate) {
    return   Container(

        decoration: BoxDecoration(color: Colors.white),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              buildMessageField(),
              buildSendButton(formattedDate),
              buildAudioButton()
            ],
          ),
        ),
    );
  }

  Widget buildAddButton(var formattedDate){
    return GestureDetector(
      onTap: () => print('hello'),
      child: Container(
        child:   IconButton(
          icon: Image.asset('assets/images/add.png',width: ScreenUtil().setWidth(20),height: ScreenUtil().setHeight(20),),
          onPressed: () {
            _sendMsg(

                _isSendMoney ? 'N ${_textController.text}': _textController.text,
                'right',
                formattedDate , false , '', false);
          },
        ),
      ),
    );
  }


  Widget buildMessageField(){
    return  Container(
      margin:EdgeInsets.all(5.0),
      width: width*0.7,
      height: ScreenUtil().setHeight(40),
      decoration: new BoxDecoration (
          border: Border.all(color: GREY),
          borderRadius:  BorderRadius.all(Radius.circular(20.0)),
          color: _isSendMoney ? GREEN : Colors.white
      ),
      child :
      Container(
        padding: EdgeInsets.only(left: 2.0),
        child: Row(
          children: [
            Flexible(
              child :TextField(
                keyboardType: TextInputType.text,
                inputFormatters: _isSendMoney ?
                <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ]:<TextInputFormatter>[
                  FilteringTextInputFormatter.allow( RegExp("[a-zA-Z]")),
                ],
                style: TextStyle(color: _isSendMoney ? Colors.white : Colors.grey),
                controller: _textController,
                decoration: new InputDecoration.collapsed(hintText: ""),
              ),
            ),
            IconButton(
              icon: Image.asset(_isSendMoney ? 'assets/images/isMoney.png' :
              'assets/images/cam.png',width: ScreenUtil().setWidth(30),
                height: ScreenUtil().setHeight(30),),
              onPressed:() async {
                var firstCamera = await getCamera();
                String imagePath = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return TakeAPicture(
                        camera: firstCamera,
                      );
                    }));
                _sendMsg('','left','',true , imagePath , false);
              }
            ),
          ],
        ),
      ),
    );
  }


  Widget buildSendButton(var formattedDate){
    return Container(
     // padding: EdgeInsets.all(2),
      child: new IconButton(
          icon: Image.asset(
            "assets/images/send.png",),
          onPressed: () =>
              _sendMsg(
                  _isSendMoney ? 'N ${_textController.text}': _textController.text,
                  'left',
                  formattedDate , false , '', false)),
    );
  }

  Widget buildCameraButton(){
    return  Container(
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
            _sendMsg('','left','',true , imagePath , false);
          }
      ),
    );
  }

  Widget buildAudioButton(){
    return  Container(
      ///padding: EdgeInsets.all(2),
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
    );
  }

  start() async {
    try {
      if (await AudioRecorder.hasPermissions) {

        await AudioRecorder.start();
        bool isRecording = await AudioRecorder.isRecording;
        if (!streamControllerForRecording.isClosed)
          streamControllerForRecording.sink.add(isRecording);
        setState(() {
          _recording = new Recording(duration: new Duration(), path: "");
          isRecording = isRecording;
        });
      } else {
        print("doesn't have permission");
      }
    } catch (e) {
      print(e);
    }
  }

  getFileAndShowIt() async {
    String file = await stop();
    print('new files $file');
    _sendMsg('','left', '' , false , file , true);
  }

  Future<String> stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = localFileSystem.file(recording.path);
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

  Future<void> checkPermissionStatus() async {
    if (await Permission.camera.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage
    ].request();
    print(statuses[
      Permission.microphone
    ]);
  }


}