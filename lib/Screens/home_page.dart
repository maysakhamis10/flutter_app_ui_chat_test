import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_ui_chat/Utils/Styles.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'colors.dart';
import 'message_model.dart';
import 'messages_mock.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var messagesMap;
  List<Message> messageItems;
  bool isOpened = false;
  AnimationController animationController;
  Animation<double> animationIcon;
  Curve curve = Curves.easeOut;
  AnimationController _controller;
  Animation<double> transitionTween;
  Animation<BorderRadius> borderRadius;
  var _myValue = 0.0;
  bool isClicked = false ;


  final _myNewValue = 200.0;
  Duration duration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    messagesMap = jsonDecode(messagesData)["messages"] as List;
    messageItems =
        List<Message>.from(messagesMap.map((i) => Message.fromJson(i)));
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    animationIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          // Navigator.pop(context);
        }
      });

    transitionTween = Tween<double>(
      begin: 50.0,
      end: 200.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
    borderRadius = BorderRadiusTween(
      begin: BorderRadius.circular(75.0),
      end: BorderRadius.circular(0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();}

  @override
  void dispose() {
    // animationController.dispose();
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primaryColor));
    return Scaffold(
      backgroundColor: whileColorBackground,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          child: Icon(
            isOpened ? Icons.close : Icons.add,
          ),
          backgroundColor: primaryColor,
          onPressed: () {
            animate();
          }),
      bottomNavigationBar: getBottomAppBar(),
      body: Stack(
        alignment: Alignment.center,
      children: [
        Column(
          children: [
            buildWhiteBar(),
            buildBlueBarUi(),
            Container(
                height: ScreenUtil().screenHeight * 0.6,
                child: getMessagesListWidget())
          ],
        ),
        Visibility(
          visible: isClicked ? false : true,
          child:
          Positioned(
            top: isClicked ? 80 : 180,
            child: Container(
              height: 40,
              // margin: EdgeInsets.only(left :20.0 , right: 20.0),
              width: ScreenUtil().screenWidth*0.9,
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: TextFormField(
                  enabled: true,
                  decoration: InputDecoration(
                      hintText: 'Search for a contact',
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            if (isClicked) {
                              isClicked = false;
                            }
                            else {
                              isClicked = true;
                            }
                          });
                        },)),
                ),
              ),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            ),

          ),
        ),
        Positioned(
          top: ScreenUtil().screenHeight - 260,
          child: getAnimatedSheet(),
        )
      ]
      ,
    ),
    );
  }


 Widget buildBlueBarUi(){
    return  Visibility(visible: isClicked ? false : true ,
      child:
      Container(
        margin: EdgeInsets.only(bottom: 15),
        height: 200,
        color: primaryColor,
      ),
    );
}

  Widget buildWhiteBar() {
    return Visibility(
        visible: isClicked ? true : false
        , child:
    Container(
      height: 260,

      child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              alignment: Alignment.center,
              width: ScreenUtil().screenWidth,
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60,),

                  Container(child: Text('New Chat', style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold,fontSize: 18)),
                  margin: EdgeInsets.only(left : 10 ),),
                  SizedBox(height: 20,),
                  Container(
                    height: 40,
                    margin: EdgeInsets.only(left :10.0 , right: 10.0),
                    width: ScreenUtil().screenWidth,
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: TextFormField(
                        enabled: true,
                        decoration: InputDecoration(
                            hintText: 'Search for a contact',
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  if (isClicked) {
                                    isClicked = false;
                                  }
                                  else {
                                    isClicked = true;
                                  }
                                });
                              },)),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),

                  ),
                  SizedBox(height: 20,),
                  Row(children: [
                    SizedBox(width: 20,),
                    Icon(Icons.group,color: primaryColor,),
                    SizedBox(width: 20,),
                    Text('Create New Group', style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),],),
                  SizedBox(height: 20,),
                  Row(children: [
                    SizedBox(width: 20,),
                    Icon(Icons.group_add_sharp,color: primaryColor,)
                    ,SizedBox(width: 20,),Text('Create New Account', style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                ],
              ),
                  SizedBox(height: 20,),
                ]
            ),
          ),
      ),
    )
    );
  }
  
  getBottomAppBar() {
    return BottomAppBar(
        elevation: 10,
        notchMargin: 5,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 56,
          padding: EdgeInsets.only(left: 36, right: 36),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                child: Icon(Icons.settings),
                onTap: () {},
              ),
              InkWell(
                child: Icon(Icons.chat),
                onTap: () {},
              ),
              SizedBox(width: 40), // The dummy child
              InkWell(
                child:  Icon(Icons.account_box),
                onTap: () {},
              ),
              InkWell(
                child:  Icon(Icons.money),
                onTap: () {},
              ),
            ],
          ),
        ));
  }

  getMessagesListWidget() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListView.builder(
          //shrinkWrap: true,
          itemCount: messageItems.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsets.only(bottom: 8, left: 20, right: 20),
                child: Column(children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Image(
                                      height: 50,
                                      width: 50,
                                      image: AssetImage(
                                        messageItems[index].image,
                                      ))),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    messageItems[index].name,
                                    style: SemiBoldTextStyle,
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    messageItems[index].lastMessage,
                                    textAlign: TextAlign.start,
                                  )
                                ],
                              ),
                            ]),
                        Row(children: <Widget>[
                          Icon(
                            Icons.volume_off,
                            color: Colors.grey,
                          ),
                          Column(
                            children: [
                              Text(
                                messageItems[index].time,
                                style: TextStyle(color: babyBlueColor),
                              ),
                              Container(
                                  width: 25,
                                  height: 25,
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: new BoxDecoration(
                                      color: babyBlueColor,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(
                                        messageItems[index]
                                            .unreadMessages
                                            .toString(),
                                        style: WhiteTextStyle),
                                  ))
                            ],
                          ),
                        ])
                      ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Divider(),
                  )
                ]));
          }),
    );
  }

  animate() {
    if (!isOpened) {
      animationController.forward();
      setState(() {
        _myValue = _myNewValue;
      });
      //  getAnimatedSheet();
    } else {
      animationController.reverse();
      setState(() {
        _myValue = 0;
      });
      //   getAnimatedSheet();
    }
    isOpened = !isOpened;
  }

  getAnimatedSheet() {
    return AnimatedContainer(
      width: ScreenUtil().screenWidth,
      color: Colors.white,
      duration: duration,
      height: _myValue,
      child: pickingImage(),
    );
  }

  pickingImage() {
    return Container(
      child: ListView(
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(10.0),
                width: 180,
                // height: 60,
                child: RaisedButton(
                    child: Text('Start chat'),
                    onPressed: () => {
                      //Navigator.pop(context),
                      _controller.forward()
                    },
                    color: primaryColor,
                    textColor: whiteColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)))),
            Container(
                margin: EdgeInsets.all(10.0),
                width: 180,
                // height: 60,
                child: RaisedButton(
                    child: Text('Send a contact'),
                    onPressed: () => {
                      Navigator.pop(context),
                    },
                    color: primaryColor,
                    textColor: whiteColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)))),
          ],
        ),

    );
  }
}
