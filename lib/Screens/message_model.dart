class Message {
  final String image;
  final String name;
  final String lastMessage;
  final int unreadMessages;
  final String time;
  final bool mute;

  Message(this.image,this.name, this.lastMessage,this.unreadMessages,this.time,this.mute);

  Message.fromJson(Map<String, dynamic> json)
      : image = json['image'],
        name = json['name'],
        lastMessage = json['lastMessage'],
        unreadMessages = json['unreadMessages'],
        time=json['time'],
        mute = json['mute'];

}