import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/chat_pakage/user_model1.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/firebase/user_section.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  TextEditingController firstNameController,
      lastNameController,
      addressController,
      phoneController;
  String firstName;
  String lastName;
  String phoneNumber;
  String address;
  bool isClicked = false;
  var isLoading = true;
  String result;
  UserSection firebase = UserSection();
  UserModel userModel;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    userData();
    super.initState();
  }

  void userData() async {
    FirebaseFirestore firestore;
    User user = FirebaseAuth.instance.currentUser;
    firestore = FirebaseFirestore.instance;
    firestore
        .collection(userPath)
        .doc(user.email.toString().trim())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map;
        if (data['UserName'] != null) {
          setState(() {
            isLoading = false;
            firstNameController.text = data['FirstName'] ?? "";
            lastNameController.text = data['LastName'] ?? "";
            phoneController.text = data['Phone'] ?? "";
            addressController.text = data['Address'] ?? "";
            address = addressController.text;
            phoneNumber = phoneController.text;
            lastName = lastNameController.text;
            firstName = firstNameController.text;
          });
        } else {
          //
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : Form(
            key: _formKey,
            child: Column(
              children: [
                buildFirstNameFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildLastNameFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildPhoneNumberFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildAddressFormField(),
                FormError(errors: errors),
                SizedBox(height: getProportionateScreenHeight(40)),
                !isClicked
                    ? DefaultButton(
                        text: "continue",
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            userModel = UserModel(
                                firstName: firstName,
                                lastName: lastName,
                                //  phone: phoneNumber,
                                verified: "false",
                                name:
                                    "${firstName.toString().trim()}_${lastName.toString().trim()}",
                                imageUrl: null,
                                email: null,
                                address: address);
                            result = await firebase.updateUserData(userModel);
                            if (result == "error") {
                              setState(() {
                                isClicked = false;
                              });
                              addError(error: "Error in update data");
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginSuccessScreen(
                                          
                                          )
                                          ));
                            }
                            /*
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtpScreen(
                                            number: phoneNumber,
                                          )
                                          ));
                            }
                            */
                          }
                        },
                      )
                    : CircularProgressIndicator(),
              ],
            ),
          );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      controller: addressController,
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        address = value;
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address",
        hintText: "Enter your phone address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        phoneNumber = value;
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        if (value.toString().startsWith("10") ||
            value.toString().startsWith("11") ||
            value.toString().startsWith("12") ||
            value.toString().startsWith("15")) {
          removeError(
              error: "Phone must start with  010 or 011 , or 012 or 015");
        }
        if (value.toString().length == 11) {
          removeError(error: "Phone must be 11 digits");
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        } else {
          try {
            int number = int.parse(value);
            if (number.toString().length + 1 != 11) {
              addError(error: "Phone must be 11 digits");
              return "";
            } else if ((number.toString().startsWith('15')) ||
                (number.toString().startsWith('12')) ||
                (number.toString().startsWith('11')) ||
                (number.toString().startsWith('10'))) {
            } else {
              addError(
                  error: "Phone must start with  010 or 011 , or 012 or 015");
              return "";
            }
          } catch (e) {
            addError(error: "Phone must be number, not string");
            return "";
          }
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      controller: lastNameController,
      onSaved: (newValue) => lastName = newValue,
      onChanged: (value) {
        lastName = value;
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Last Name",
        hintText: "Enter your last name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      controller: firstNameController,
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        firstName = value;
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: "Enter your first name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
