import 'package:flutter/material.dart';
import 'package:practise/Screens/Home/Home.dart';
import 'package:practise/Screens/Profile/profile.dart';
import 'package:practise/Utils/Constraints.dart';

class CardPayment extends StatefulWidget {
  const CardPayment({Key? key}) : super(key: key);

  @override
  State<CardPayment> createState() => _privacyPolicyState();
}

class _privacyPolicyState extends State<CardPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                          email: '',
                        )),
              );
            }),
        backgroundColor: kPrimaryWhiteColor,
        elevation: 0,
      ),
      backgroundColor: kPrimaryWhiteColor,
      body: Center(child: Text("Card Payment Add Soon !!")),
    );
  }
}
