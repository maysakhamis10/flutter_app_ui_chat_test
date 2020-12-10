import 'package:flutter/material.dart';
import 'package:flutter_app_ui_chat/Screens/bubble_layout.dart';

class Message extends StatelessWidget {
  Message({this.msg, this.direction, this.dateTime});

  final String msg;
  final String direction;
  final String dateTime;
  var width  ;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width ;
    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: direction == 'left' ?
        buildBubbleMessage(
            Alignment.bottomLeft, msg, Color(0xff25A3FF), Colors.white, true,
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
            child: CustomPaint(
              painter: ChatBubble(color: cardColor, alignment: alignment),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: isLeft ? EdgeInsets.only(left: 5.0) : EdgeInsets
                          .only(right: 5.0),
                      decoration: new BoxDecoration(
                        color: cardColor,
                        border: new Border.all(
                            color: cardColor,
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
                      padding: const EdgeInsets.all(10.0),
                      child: new Text(
                        msg,
                        style: new TextStyle(
                          fontFamily: 'Gamja Flower',
                          fontSize: 20.0,
                          color: textColor,
                        ),
                      ),
                      width:width * 0.60,
                    ),
                  ],
                ),
              ),
            ),
          ), Container(
            alignment: isLeft? Alignment.topLeft : Alignment.topRight,
          margin: isLeft? EdgeInsets.only(top: 4.0,left: width*0.55) : EdgeInsets.only(top: 4.0,right: 4.0),
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
