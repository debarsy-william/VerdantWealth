import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kBackgroundColorWhite = Color(0xFFF5F8FF);
const kBackgroundColorGrey = Colors.white70;
const kBackgroundColorGreen = Color(0xFF2E7D32);
const kMainTextColor = Color(0xFFF5F8FF);
const kPrimaryLabelColor = kMainTextColor;

List<BoxShadow> kBoxShadowItem = [
  BoxShadow(
    color: Colors.black.withOpacity(0.16),
    blurRadius: 4,
    offset: const Offset(3, 3),
  )
];

const kLoginInputTextStyle = TextStyle(
  fontSize: 17.0,
  color: kMainTextColor,
  fontWeight: FontWeight.w400,
  decoration: TextDecoration.none,
);

const kLargeTitleStyle = TextStyle(
  fontSize: 42.0,
  fontWeight: FontWeight.bold,
  color: kPrimaryLabelColor,
  decoration: TextDecoration.none,
);

const kSubtitleStyle = TextStyle(
  fontSize: 16.0,
  color: kPrimaryLabelColor,
  fontStyle: FontStyle.italic,
  decoration: TextDecoration.none,
);

const kCalloutLabelStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w700,
  color: kPrimaryLabelColor,
  decoration: TextDecoration.none,
);

const kTextStylePage = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

const linkStyle = TextStyle(color: Colors.white, fontSize: 18);

class LoginHeader extends StatelessWidget {
  const LoginHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'VerdantWealth',
          style: kLargeTitleStyle,
        ),
        Text(
          'La Banque du futur',
          style: kSubtitleStyle,
        ),
      ],
    );
  }
}