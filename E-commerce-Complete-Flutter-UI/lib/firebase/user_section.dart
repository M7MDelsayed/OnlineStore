import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/chat_pakage/user_model1.dart';
import 'package:shop_app/firebase/user_section.dart';

import '../constants.dart';

class UserSection {
  FirebaseFirestore firestore;
  CollectionReference userRef;
  Future<String> addUser(UserModel userModel) async {
    userRef = FirebaseFirestore.instance.collection(userPath);
    return userRef.doc(userModel.email.toString().trim()).set({
      "Email": userModel.email.toString() ?? "None",
      "Password": userModel.password.toString() ?? "None"
    }).then((value) {
      print("User Added");
      return "Success";
    }).catchError((error) => print("Failed to add user: $error"));
  }

  Map<String, String> updateConditions(UserModel userModel) {
    Map<String, String> map = Map();
    User user = FirebaseAuth.instance.currentUser;
    if (userModel.name != null) {
      map["UserName"] = userModel.name.toString();
    } else {}
    if (userModel.firstName != null) {
      map["FirstName"] = userModel.firstName.toString();
    } else {}
    if (userModel.lastName != null) {
      map["LastName"] = userModel.lastName.toString();
    } else {}
    if (userModel.phone != null) {
      map["Phone"] = userModel.phone.toString();
    } else {}
    if (userModel.address != null) {
      map["Address"] = userModel.address.toString();
    } else {}
    if (userModel.email != null) {
      map["Email"] = userModel.email.toString();
    } else {}
    if (userModel.imageUrl != null) {
      map["ImageUrl"] = userModel.imageUrl.toString();
    } else {}
    if (userModel.verified != null) {
      map["verified"] = userModel.verified.toString();
    } else {}

    return map;
  }

  Future<String> updateUserData(UserModel userModel) async {
    firestore = FirebaseFirestore.instance;
    User user = FirebaseAuth.instance.currentUser;
    print(updateConditions(userModel));
    return firestore.collection(userPath).doc(user.email.toString().trim()).update(
        /*{
      "UserName ": userModel.name.toString() ?? "None",
      "FirstName ": userModel.firstName.toString() ?? "None",
      "LastName ": userModel.lastName.toString() ?? "None",
      "Phone ": userModel.phone.toString() ?? "None",
      "Address ": userModel.address.toString() ?? "None",
      "Email": userModel.email.toString() ?? "None",
      "ImageUrl": userModel.imageUrl.toString() ?? "None",
      "Password": userModel.password.toString() ?? "None"
    }*/
        updateConditions(userModel)).then((value) {
      print("[*] Data Added Successfully");
      return "Data Added Successfully";
    }).catchError((error) {
      print("Failed to add user: $error");
      return "error";
    });
  }

  Future<String> signUp(UserModel userModel) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userModel.email.toString(),
              password: userModel.password.toString())
          .then((value) {
        addUser(userModel).then((value) => true);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return weakPassword;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return accountAlreadyExist;
      }
    } catch (e) {
      print(e);
      return "fail";
    }

    return "success";
  }

  Future<String> signIn(UserModel userModel) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: userModel.email.toString(),
              password: userModel.password.toString())
          .then((value) {
        addUser(userModel);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(kNoUserFound);
        return kNoUserFound;
      } else if (e.code == 'wrong-password') {
        print(kWrongPassword);
        return kWrongPassword;
      }
      return "fail";
    }
    return "success";
  }

  Future<Map<String, dynamic>> user_SignIn_Data_Completions() async {
    Map<String, dynamic> userData = Map<String, String>();
    User user = FirebaseAuth.instance.currentUser;
    firestore = FirebaseFirestore.instance;
    firestore
        .collection(userPath)
        .doc(user.email.toString().trim())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userData = documentSnapshot.data();
        print('Document data: ${documentSnapshot.data()}');
      } else {
        userData = null;
        print('Document does not exist on the database');
      }
    });
    return userData;
  }

  Future<void> verifyPhone(String number, verifcationId) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }

        // Handle other errors
      },
      codeSent: (String verificationId, [int resendToken]) async {
        // Update the UI - wait for the user to enter the SMS code
        // PhoneAuthCredential credential = PhoneAuthProvider.credential(
        //     verificationId: verificationId, smsCode: smsCode);

        //     await auth.signInWithCredential(credential);
        verifcationId = verificationId;
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }
}
