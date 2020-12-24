import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_ui_chat/Utils/Styles.dart';
import 'package:flutter_app_ui_chat/Utils/colors.dart';
import 'package:flutter_screenutil/screenutil.dart';
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
    // animationController =
    //     AnimationController(vsync: this, duration: Duration(milliseconds: 500))
    //       ..addListener(() {
    //         setState(() {});
    //       });
    // animationIcon =
    //     Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    // _controller = AnimationController(
    //     duration: const Duration(milliseconds: 2000), vsync: this)
    //   ..addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       _controller.reverse();
    //     }
    //     if (status == AnimationStatus.dismissed) {
    //       // Navigator.pop(context);
    //     }
    //   });
    //
    // transitionTween = Tween<double>(
    //   begin: 50.0,
    //   end: 200.0,
    // ).animate(
    //   CurvedAnimation(
    //     parent: _controller,
    //     curve: Curves.ease,
    //   ),
    // );
    // borderRadius = BorderRadiusTween(
    //   begin: BorderRadius.circular(75.0),
    //   end: BorderRadius.circular(0.0),
    // ).animate(
    //   CurvedAnimation(
    //     parent: _controller,
    //     curve: Curves.ease,
    //   ),
    // );
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
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(
      //       isOpened ? Icons.close : Icons.add,
      //     ),
      //     backgroundColor: primaryColor,
      //     onPressed: () {
      //       animate();
      //     }),
      bottomNavigationBar: getBottomAppBar(),
      body:
      Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              buildNewUiWhenClicked(),
              Visibility(
                child:
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  height: 190,
                  color: primaryColor,
                ),
                visible: false,
              ),
              Container(
                  height: ScreenUtil().screenHeight * 0.6,
                  child: getMessagesListWidget())
            ],
          ),

          Visibility(
            child:
            Positioned(
              top: 100,
              child:
              //Container(
              // animation: _controller,
              //  builder: (BuildContext context, Widget child) {
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 40,
                width: ScreenUtil().screenWidth * 0.9,
                child: Container(
                  color: whiteColor,
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                        hintText: 'search',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search), onPressed: () {

                        },)),
                  ),
                ),
              ),
            ),
            visible: false,
          ),


          // Positioned(
          //   top: ScreenUtil().screenHeight - 250,
          //   child: getAnimatedSheet(),
          // )
        ],
      ),
    );
  }

  Widget buildNewUiWhenClicked(){
    return Visibility(
      child:  Column(
       children: [
         Text('New Chat'),
         Container(
               decoration: BoxDecoration(
                   border: Border.all(color: Colors.white),
                   borderRadius: BorderRadius.all(Radius.circular(10))),
               height: 40,
               width: ScreenUtil().screenWidth * 0.9,
               child: Container(
                 color: whiteColor,
                 child: TextFormField(
                   enabled: false,
                   decoration: InputDecoration(
                       hintText: 'search',
                       border: InputBorder.none,
                       filled: true,
                       fillColor: Colors.white,
                       suffixIcon: IconButton(
                         icon: Icon(Icons.search), onPressed: () {

                       },)),
                 ),
               ),
             ),



       ],
     ),
      visible: true,
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
    return ListView.builder(
        shrinkWrap: true,
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
        });
  }

  // animate() {
  //   if (!isOpened) {
  //     animationController.forward();
  //     setState(() {
  //       _myValue = _myNewValue;
  //     });
  //     //  getAnimatedSheet();
  //   } else {
  //     animationController.reverse();
  //     setState(() {
  //       _myValue = 0;
  //     });
  //     //   getAnimatedSheet();
  //   }
  //   isOpened = !isOpened;
  // }
  //
  // getAnimatedSheet() {
  //   return AnimatedContainer(
  //     width: ScreenUtil().screenWidth,
  //     color: Colors.white,
  //     duration: duration,
  //     height: _myValue,
  //     child: pickingImage(),
  //   );
  // }

  pickingImage() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 20),
              width: 250,
              height: 75,
              child: RaisedButton(
                  child: Text('test'),
                  onPressed: () => {
                        //Navigator.pop(context),
                        _controller.forward()
                      },
                  color: primaryColor,
                  textColor: whiteColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)))),
          Container(
              padding: EdgeInsets.only(top: 20),
              width: 250,
              height: 75,
              child: RaisedButton(
                  child: Text('test'),
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
