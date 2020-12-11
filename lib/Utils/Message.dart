import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_ui_chat/Screens/CustomAudioMessages.dart';
import 'package:flutter_app_ui_chat/Screens/bubble_layout.dart';

import 'AppColors.dart';

class Message extends StatelessWidget {

  Message({this.msg, this.direction, this.dateTime,this.filePath, this.isAttach , this.isAudio, this.isMoney});

  final String msg;
  final String filePath;
  final String direction;
  final String dateTime;
  final bool  isAttach;
  final bool  isAudio;
  final bool  isMoney;
  var width  ;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width ;
    return  Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: direction == 'left' ?
            isAudio ?
            MessagesCustomAudio(url: filePath, time:'') :
        buildBubbleMessage(
            Alignment.bottomLeft, msg, BLUE, Colors.white, true,
            context) :
        buildBubbleMessage(
            Alignment.topRight, msg, Colors.white, Colors.black, false, context)


    );
  }

  Widget buildBubbleMessage(Alignment alignment, String msg,
      Color cardColor, Color textColor, bool isLeft, BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: alignment,
            child:
            isAttach ? Container(
              child: Image.file(File(filePath)),
              margin: EdgeInsets.all(5.0),
            ): CustomPaint(
              painter: ChatBubble(color: isMoney ? GREEN : cardColor, alignment: alignment),
              child: Container(
                margin: EdgeInsets.all(5),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: isLeft ? EdgeInsets.only(left: 5.0) : EdgeInsets
                          .only(right: 5.0),
                      decoration: new BoxDecoration(
                        color: isMoney ? GREEN :cardColor ,
                        border: new Border.all(
                            color: isMoney ? GREEN :cardColor ,
                            width: .25,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5.0),
                          topLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(0.0),
                        ),
                      ),
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(5.0),
                      child: new Text(
                        msg,
                        style: new TextStyle(
                          fontFamily: 'Gamja Flower',
                          fontSize: 20.0,
                          color: isMoney ? Colors.white : textColor,
                        ),
                      ),

                      width:isMoney ? width * 0.40 :width * 0.60,
                    ),
                  ],
                ),
              ),
            ),
          ),
          isMoney || isAttach ? Container() : Container(
            alignment: isLeft? Alignment.topLeft : Alignment.topRight,
            margin: isLeft? EdgeInsets.only(top: 4.0,left: width*0.5) : EdgeInsets.only(top: 4.0,right: 4.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 40),
              child: IntrinsicWidth(
                child:
                Row(
                  children: [
                    Text(
                      dateTime,
                      style: new TextStyle(
                        fontSize: 8.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5.0,),
                    Image.asset('assets/images/seen.png'),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
