import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CartCard extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final List<String> images;
  final int quantity;

  CartCard({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
    @required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final itemAmount = (price * quantity).toStringAsFixed(2);
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(images[0]),
            ),
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenHeight(15),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "\$$price",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                  ),
                  TextSpan(
                    text: " x$quantity",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Text(
              "\$$itemAmount",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: kPrimaryColor,
                  fontSize: 15),
            ),
          ],
        )
      ],
    );
  }
}
