import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/chat_pakage/user_model1.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/firebase/user_section.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/size_config.dart';

class OtpForm extends StatefulWidget {
  String number;
  OtpForm({Key key, @required this.number}) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserModel userModel;
  String Verifcationid;
  String value1;
  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  UserSection userSection = UserSection();
  @override
  void initState() {
    super.initState();
    print('+2${widget.number}');
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    // userSection.verifyPhone("+201002201278", this.Verifcationid);
    phone_auth();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  void phone_auth() async {
    print('+2${widget.number}');
    await auth.verifyPhoneNumber(
      phoneNumber: '+2${widget.number}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // await auth.signInWithCredential(credential);

        var result = await userSection.updateUserData(userModel).then((value) =>
            Navigator.pushReplacementNamed(context, HomeScreen.routeName));
        print(result);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }

        // Handle other errors
      },
      codeSent: (String verificationId, int resendToken) async {
        this.Verifcationid = verificationId;
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.10),
          Column(
            children: [
              /*  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: getProportionateScreenWidth(30),
                    child: TextFormField(
                      autofocus: true,
                      obscureText: true,
                      style: TextStyle(fontSize: 19),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        nextField(value, pin2FocusNode);
                      },
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(19),
                    child: TextFormField(
                      focusNode: pin2FocusNode,
                      obscureText: true,
                      style: TextStyle(fontSize: 24),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) => nextField(value, pin3FocusNode),
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(19),
                    child: TextFormField(
                      focusNode: pin3FocusNode,
                      obscureText: true,
                      style: TextStyle(fontSize: 19),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) => nextField(value, pin4FocusNode),
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(30),
                    child: TextFormField(
                      focusNode: pin4FocusNode,
                      obscureText: true,
                      style: TextStyle(fontSize: 24),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        if (value.length == 1) {
                          pin4FocusNode.unfocus();
                          // Then you need to check is the code is correct or not
                          this.value1 = value;
                        }
                      },
                    ),
                  ),
                ],
              ),*/
              TextFormField(
                onSaved: (newValue) => this.value1 = newValue,
                onChanged: (value) {
                  this.value1 = value;
                  print(this.value1);
                  if (value.isNotEmpty) {}
                  return null;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "OTP",
                  hintText: "Enter your OTP number",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon:
                      CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
                ),
              )
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.10),
          DefaultButton(
            text: "Continue",
            press: () async {
              userModel = UserModel(
                  firstName: null,
                  lastName: null,
                  phone: widget.number,
                  name: null,
                  imageUrl: null,
                  email: null,
                  password: null,
                  address: null,
                  verified: 'true');
              print("dddddddd${this.Verifcationid.toString()}");

              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: this.Verifcationid, smsCode: this.value1);
              await userSection.updateUserData(userModel).then((value) =>
                  Navigator.pushReplacementNamed(
                      context, HomeScreen.routeName));
              //await auth.signInWithCredential(credential);
            },
          )
        ],
      ),
    );
  }
}
