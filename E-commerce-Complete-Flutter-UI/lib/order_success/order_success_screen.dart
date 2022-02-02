import 'package:flutter/material.dart';

import 'body.dart';

class OrderSuccessScreen extends StatelessWidget {
  static String routeName = "/order_success";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("Order Success"),
      ),
      body: Body(),
    );
  }
}
