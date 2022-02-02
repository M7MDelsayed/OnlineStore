//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/chat_pakage/user_model1.dart';
//import 'package:shop_app/firebase/user_section.dart';
import 'package:shop_app/screens/profile/components/profile_widget.dart';

class UserAccount extends StatelessWidget {
  static String routeName = "/user_account";
  @override
  Widget build(BuildContext context) {
    final fileImage = ModalRoute.of(context).settings.arguments as dynamic;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 15),
          ProfileWidget(
            imageFile: fileImage,
          ),
          const SizedBox(height: 30),
          UserAccountWidget(
              text1: 'Email :', text2: 'ah@gmail.com' ),
          const SizedBox(height: 24),
          UserAccountWidget(
            text1: 'Password :',
            text2:'12345678',
          ),
          const SizedBox(height: 24),
          UserAccountWidget(
            text1: 'Phone Number :',
            text2: '01067998475',
          ),
        ],
      ),
    );
  }
}

class UserAccountWidget extends StatelessWidget {
  final String text1;
  final String text2;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Text(
              text1,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
                child: Text(
              text2,
            )),
          ],
        ),
        decoration: BoxDecoration(
            color: Color(0xFFF5F6F9), borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  UserAccountWidget({this.text1, this.text2});
}
