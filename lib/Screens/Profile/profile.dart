// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:practise/Screens/Home/Home.dart';
import 'package:practise/Screens/Login/login.dart';
import 'package:practise/Screens/Map/googleMap.dart';
import 'package:practise/Screens/Profile/newUserProfile.dart';
import 'package:practise/Screens/Profile/userDetails.dart';
import 'package:practise/Screens/Profile/userProfileView.dart';
import 'package:practise/Screens/Rooms/getrooms.dart';
import 'package:practise/Screens/forgotPassword/forgotPassword.dart';
import 'package:practise/Support/privacyPolicy.dart';
import 'package:practise/Support/termOfService.dart';
import 'package:practise/Utils/Constraints.dart';
import 'package:practise/Utils/sharedPreferences.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String email;
  ProfileScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<ProfileScreen> {
  String? mail;
  String? name;
  String? photo;
  String userPhoto = "";

  String? email;
  var currentIndex = 3;

  String userName = "";

  // loader
  bool _isLoading = true;

  //reterive details from local storages
  void _getUserDetails() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    userPhoto = await MySharedPreferences.instance.getStringValue("photo");
    mail = localStorage.getString("email")!;
    // name = localStorage.getString("name")!;
    // photo = localStorage.getString("photo")!;
    // print("email -:" + mail!);
    // print("name -:" + name!);
    // print("photo-:" + photo!);
  }

  //get subjects details from api
  void _apiGetSubjects() async {
    userName = await MySharedPreferences.instance.getStringValue("Email");
    print("hello" + userName);

    try {} catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // email = widget.email;
    // print(email);
    _getUserDetails();
    _apiGetSubjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    final _auth = FirebaseAuth.instance;

    return Scaffold(
      backgroundColor: kPrimaryWhiteColor,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return false;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
            ),
            child: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              child: InkWell(
                                  onTap: () {},
                                  child: userPhoto == ""
                                      ? Image.asset(
                                          "assets/png/profile.png",
                                        )
                                      : Image.network(userPhoto))),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  '${userName}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ]),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Show Profile',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  highlightColor: kPrimaryBlueColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileView()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 0,
                      right: 20,
                      bottom: 10,
                      top: 10,
                    ),
                    child: Container(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // SizedBox(
                              //   width: 20,
                              // ),
                              Text(
                                "Personal Information",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: kPrimaryGreyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                InkWell(
                  highlightColor: kPrimaryBlueColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Forget(
                                title: '',
                              )),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      bottom: 10,
                      top: 10,
                    ),
                    child: Container(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Change Password",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: kPrimaryGreyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // InkWell(
                //   highlightColor: kPrimaryBlueColor,
                //   onTap: () {},
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //       right: 20,
                //       bottom: 10,
                //       top: 10,
                //     ),
                //     child: Container(
                //       height: 30,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Row(
                //             children: [
                //               Text(
                //                 "Social Connect",
                //                 style: TextStyle(
                //                   color: primaryColor,
                //                   fontSize: 18,
                //                 ),
                //               ),
                //             ],
                //           ),
                //           Icon(
                //             Icons.arrow_forward_ios,
                //             size: 16.0,
                //             color: kPrimaryGreyColor,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // InkWell(
                //   highlightColor: kPrimaryBlueColor,
                //   onTap: () {},
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //       right: 20,
                //       bottom: 10,
                //       top: 10,
                //     ),
                //     child: Container(
                //       height: 30,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Row(
                //             children: [
                //               Text(
                //                 "Switch to local guide",
                //                 style: TextStyle(
                //                   color: primaryColor,
                //                   fontSize: 18,
                //                 ),
                //               ),
                //             ],
                //           ),
                //           Icon(
                //             Icons.arrow_forward_ios,
                //             size: 16.0,
                //             color: kPrimaryGreyColor,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Support',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                InkWell(
                  highlightColor: kPrimaryBlueColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => privacyPolicy()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      bottom: 10,
                      top: 10,
                    ),
                    child: Container(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Privacy Policy",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: kPrimaryGreyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  highlightColor: kPrimaryBlueColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => termService()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      bottom: 10,
                      top: 10,
                    ),
                    child: Container(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Terms of Services",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: kPrimaryGreyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  highlightColor: kPrimaryBlueColor,
                  onTap: () async {
                    await GoogleSignIn().signOut();
                    _handleLogout(context);
                      MySharedPreferences.instance.removeAll();
                    _auth.signOut().whenComplete(() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn_body(),
                        ),
                      );
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      bottom: 10,
                      top: 50,
                    ),
                    child: Container(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Logout",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: screenWidth * .200,
        decoration: BoxDecoration(
          color: darkBlue,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(
                () {
                  currentIndex = index;
                  print(currentIndex);
                  if (currentIndex == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                email: '',
                              )),
                    );
                  } else if (currentIndex == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapView()),
                    );
                  } else if (currentIndex == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FetchData()),
                    );
                  } else if (currentIndex == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                                email: '',
                              )),
                    );
                  }
                },
              );
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  margin: EdgeInsets.only(
                    bottom: index == currentIndex ? 0 : screenWidth * .05,
                    right: screenWidth * .0422,
                    left: screenWidth * .0422,
                  ),
                  width: screenWidth * .128,
                  height: index == currentIndex ? screenWidth * .02 : 0,
                  decoration: BoxDecoration(
                    color: kPrimaryYellow,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                ),
                Icon(
                  listOfIcons[index],
                  size: screenWidth * .08,
                  color: index == currentIndex
                      ? kPrimaryYellow
                      : kPrimaryWhiteColor,
                ),
                SizedBox(height: screenWidth * .03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.map,
    Icons.room,
    Icons.settings_rounded,
  ];
}

//LOGOUT
void _handleLogout(BuildContext context) async {
  try {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('token');
    localStorage.remove('userId');
    localStorage.remove('email');
    localStorage.remove('name');
    localStorage.remove('photo');
  } catch (e) {
    print(e);
  }
}
