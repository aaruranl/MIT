import 'package:flutter/material.dart';
import 'package:practise/Screens/Profile/profile.dart';
import 'package:practise/Utils/Constraints.dart';

class termService extends StatefulWidget {
  const termService({Key? key}) : super(key: key);

  @override
  State<termService> createState() => _termServiceState();
}

class _termServiceState extends State<termService> {
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
      body: Center(child: Text("Terms of Service Add Soon !!")),
    );
  }
}
