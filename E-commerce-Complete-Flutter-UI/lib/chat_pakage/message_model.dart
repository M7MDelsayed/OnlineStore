import 'package:flutter/cupertino.dart';
import 'package:shop_app/chat_pakage/user_model1.dart';

class Messages {
  final UserModel sender;
  final String time;
  final String text;
  final bool isLiked;
  final bool unRead;

  Messages(
      {@required this.sender,
      @required this.time,
      @required this.text,
      @required this.isLiked,
      @required this.unRead});
}

final UserModel currentUser =
    UserModel(imageUrl: 'assets/images/me.jpg', id: '1', name: 'me');
final UserModel meto =
    UserModel(imageUrl: 'assets/images/meto.jpg', id: '2', name: 'meto');
final UserModel khaled =
    UserModel(imageUrl: 'assets/images/khaled.jpg', id: '3', name: 'khaled');
final UserModel zein =
    UserModel(imageUrl: 'assets/images/zein.jpg', id: '4', name: 'zein');
final UserModel somaa =
    UserModel(imageUrl: 'assets/images/UserImage.jpg', id: '5', name: 'somaa');

List<UserModel> favorites = [meto, khaled, zein, somaa, zein, somaa];
List<Messages> chats = [
  Messages(
      sender: zein,
      time: '9:30 PM',
      text: 'Hello Sayed How are You today we will work on Grad Project ? ',
      isLiked: false,
      unRead: true),
  Messages(
      sender: currentUser,
      time: '9:30 PM',
      text: 'Hello Sayed How are You today we will work on Grad Project ? ',
      isLiked: false,
      unRead: true),
  Messages(
      sender: currentUser,
      time: '9:30 PM',
      text: 'Hello Sayed How are You today we will work on Grad Project ? ',
      isLiked: false,
      unRead: true),
  Messages(
      sender: meto,
      time: '10:30 PM',
      text: 'Hello friend How are You ? ',
      isLiked: false,
      unRead: true),
  Messages(
      sender: khaled,
      time: '11:30 PM',
      text: 'Hello mate How are You ? ',
      isLiked: false,
      unRead: false),
  Messages(
      sender: zein,
      time: '9:30 PM',
      text: 'Hello Sayed How are You today we will work on Grad Project ? ',
      isLiked: false,
      unRead: true),
  Messages(
      sender: meto,
      time: '10:30 PM',
      text: 'Hello friend How are You ? ',
      isLiked: false,
      unRead: true),
  Messages(
      sender: khaled,
      time: '11:30 PM',
      text: 'Hello mate How are You ? ',
      isLiked: false,
      unRead: false),
  Messages(
      sender: zein,
      time: '9:30 PM',
      text: 'Hello Sayed How are You today we will work on Grad Project ? ',
      isLiked: true,
      unRead: true),
  Messages(
      sender: meto,
      time: '10:30 PM',
      text: 'Hello friend How are You ? ',
      isLiked: false,
      unRead: true),
  Messages(
      sender: khaled,
      time: '11:30 PM',
      text: 'Hello mate How are You ? ',
      isLiked: false,
      unRead: false),
];
