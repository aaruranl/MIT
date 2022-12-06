import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:practise/Screens/Chat/chatPage.dart';
import 'package:practise/Screens/Community/addCommunity.dart';
import 'package:practise/Screens/Community/getCommunity.dart';
import 'package:practise/Screens/Home/dummy.dart';
import 'package:practise/Screens/Map/googleMap.dart';
import 'package:practise/Screens/Profile/profile.dart';
import 'package:practise/Screens/Rooms/addRooms.dart';
import 'package:practise/Screens/Rooms/getrooms.dart';
import 'package:practise/Utils/Constraints.dart';
import 'package:practise/Utils/sharedPreferences.dart';
import 'package:practise/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String email;

  HomePage({
    Key? key,
    required this.email,
  }) : super(key: key);
  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  final List<Map> feild = [
    {'Name': 'map', 'Image': 'assets/png/travel.jpeg'},
    {'Name': 'chat', 'Image': 'assets/png/chat.jpeg'},
    {'Name': 'rooms', 'Image': 'assets/png/rooms.jpeg'},
  ];

  final List<Map> rooms = [
    {
      'Name': 'Book Shop',
      'Image': 'assets/png/Rectangle 64.png',
      'Location': 'Jaffna'
    },
    {
      'Name': 'Fruit Shop',
      'Image': 'assets/png/Rectangle 65.png',
      'Location': 'Batti'
    },
    {
      'Name': 'Gift Shop',
      'Image': 'assets/png/Rectangle 64.png',
      'Location': 'Batti'
    },
  ];

  var currentIndex = 0;

  String? mail;
  String? name;
  String? photo;
  String userName = "";
  String userPhoto = "";

  // loader
  bool _isLoading = true;

  //store the userImage in local
  void _getUserDetails() async {
    //  userName = await MySharedPreferences.instance.getStringValue("Email");
    print("sss" + userName);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    mail = localStorage.getString("email");
    // // name = localStorage.getString("name")!;
    // // photo = localStorage.getString("photo")!;
    print("email -:" + mail!);
    // print("name -:" + name!);
    // print("photo-:" + photo!);
  }

  //get subjects details from api
  void _apiGetSubjects() async {
    userName = await MySharedPreferences.instance.getStringValue("Email");
    userPhoto = await MySharedPreferences.instance.getStringValue("photo");
    print("hello" + userName);
    print("[jf" + userPhoto);

    try {} catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  String? email;

  @override
  initState() {
    _getUserDetails();
    _apiGetSubjects();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            // ignore: deprecated_member_use
            overscroll.disallowGlow();
            return false;
          },
          child: SafeArea(
              child: SizedBox(
            child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                children: <Widget>[
                  // Padding(
                  //   padding: EdgeInsets.only(left: 20.0, right: 120.0),
                  //   child: Text(
                  //     'What would you like to find?',
                  //     style: TextStyle(
                  //       fontSize: 30.0,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                  child: InkWell(
                                      onTap: () {
                                        
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileScreen(email: mail!)),
                                        );

                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) => ProfileScreen()),
                                        // );
                                      },
                                      child: userPhoto == ""
                                          ? Image.asset(
                                              "assets/png/profile.png",
                                            )
                                          : Image.network(userPhoto))),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome Home',
                                      // textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '${userName}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.notifications),
                            onPressed: () {
                              print("hello");
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => SearchMap()),
                              // );
                            },
                          ),
                        ],
                      )
                    ]),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 15),
                      child: Text(
                        'Where do ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 5),
                      child: Text(
                        "you want to go ?",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         CircleAvatar(
                  //             child: InkWell(
                  //           onTap: () {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       ProfileScreen(email: mail!)),
                  //             );
                  //           },
                  //           child: Image.asset(
                  //             "assets/png/profile.png",
                  //           ),
                  //         )),
                  //         Padding(
                  //           padding: EdgeInsets.all(8.0),
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 'Welcome Home',
                  //                 // textAlign: TextAlign.left,
                  //                 style: TextStyle(
                  //                   color: primaryColor,
                  //                   fontSize: 12,
                  //                 ),
                  //               ),
                  //               Text(
                  //                 mail.toString().trim(),
                  //                 textAlign: TextAlign.left,
                  //                 style: TextStyle(
                  //                     color: primaryColor,
                  //                     fontSize: 14,
                  //                     fontWeight: FontWeight.bold),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     IconButton(
                  //       icon: Icon(Icons.notifications),
                  //       onPressed: () {},
                  //     ),
                  //   ],
                  // ),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Padding(
                  //     padding: EdgeInsets.only(left: 10.0, top: 30),
                  //     child: Text(
                  //       'Where do ',
                  //       textAlign: TextAlign.left,
                  //       style: TextStyle(
                  //         color: primaryColor,
                  //         fontSize: 24,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Padding(
                  //     padding: EdgeInsets.only(left: 10.0, top: 5),
                  //     child: Text(
                  //       "you want to go ?",
                  //       textAlign: TextAlign.left,
                  //       style: TextStyle(
                  //         color: primaryColor,
                  //         fontSize: 24,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  // Column(
                  //   children: [
                  //     Expanded(
                  //       child: ListView.builder(
                  //           scrollDirection: Axis.horizontal,
                  //           itemCount: feild.length,
                  //           itemBuilder: (BuildContext context, int index) {
                  //             return GestureDetector(
                  //               onTap: () {
                  //                 if (feild[index]['Name'] == 'Book Shop') {
                  //                   Navigator.push(
                  //                     context,
                  //                     MaterialPageRoute(
                  //                         builder: (context) => chatpage(
                  //                               email: mail!,
                  //                             )),
                  //                   );
                  //                 }

                  //                 //  Navigator.push(
                  //                 //         context,
                  //                 //         MaterialPageRoute(
                  //                 //             builder: (context) => DetailsScreen()),
                  //                 //       );
                  //               },
                  //               child: Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   // SizedBox(width: 20),
                  //                   Container(
                  //                     width: screenWidth * 0.85,
                  //                     height: screenHeight * 0.40,
                  //                     child: Padding(
                  //                       padding: EdgeInsets.all(8.0),
                  //                       child: Image.asset(
                  //                         feild[index]['Image'],
                  //                         fit: BoxFit.cover,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               // key: ValueKey(_foundUsers[index]["id"]),

                  //               // margin: EdgeInsets.symmetric(vertical: 10),
                  //               // child: Padding(
                  //               //   padding: const EdgeInsets.all(8.0),
                  //               //   child: Image.asset(
                  //               //     'assets/png/g1.jpeg',
                  //               //   ),
                  //               // ),
                  //             );
                  //           }),
                  //     ),
                  //   ],
                  // ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     SizedBox(
                  //       height: 20,
                  //     ),
                  //     Container(
                  //       margin: EdgeInsets.only(left: 15, right: 15),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text(
                  //             "Ongoing Communities",
                  //             style: TextStyle(
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.bold,
                  //                 color: primaryColor),
                  //           ),
                  //           Column(
                  //             children: [
                  //               InkWell(
                  //                 highlightColor: Colors.transparent,
                  //                 onTap: () {
                  //                   // Navigator.push(
                  //                   //   context,
                  //                   //   MaterialPageRoute(
                  //                   //     builder: (context) =>
                  //                   //         Browser(),
                  //                   //   ),
                  //                   // );
                  //                 },
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.symmetric(vertical: 8),
                  //                   child: Text(
                  //                     " Show All >",
                  //                     style: TextStyle(
                  //                       color: Colors.amber,
                  //                       fontSize: 12,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Container(
                    height: 140.0,
                    child: SizedBox(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: feild.length,
                        itemBuilder: (BuildContext context, int index) {
                          //  Destination destination = destinations[index];
                          return GestureDetector(
                            // onTap: () => Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => DestinationScreen(
                            //       destination: destination,
                            //     ),
                            //   ),
                            // ),
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              width: 240.0,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: <Widget>[
                                  Positioned(
                                    bottom: 15.0,
                                    child: Container(
                                      // height: 120.0,
                                      // width: 200.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                    
                                           ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: InkWell(
                                              onTap: () async {
                                                print("object");
                                                if (feild[index]['Name'] ==
                                                    'chat') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            getCommunityDetails()),
                                                  );
                                                } else if (feild[index]
                                                        ['Name'] ==
                                                    'rooms') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FetchData()),
                                                  );
                                                } else if (feild[index]
                                                        ['Name'] ==
                                                    'map') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MapView()),
                                                  );
                                                }
                                              },
                                              child: Image(
                                                height: 160.0,
                                                width: 240.0,
                                                image: AssetImage(
                                                    feild[index]["Image"]),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ongoing Communities",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                            Column(
                              children: [
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         Browser(),
                                    //   ),
                                    // );
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      " Show All >",
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 300.0,
                    child: SizedBox(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: rooms.length,
                        itemBuilder: (BuildContext context, int index) {
                          //  Destination destination = destinations[index];
                          return GestureDetector(
                            // onTap: () => Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => DestinationScreen(
                            //       destination: destination,
                            //     ),
                            //   ),
                            // ),
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              width: 210.0,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: <Widget>[
                                  Positioned(
                                    bottom: 15.0,
                                    child: Container(
                                      height: 120.0,
                                      width: 210.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '6 person Interested',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                // fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "Room will be deleted on 11/10/2022",
                                              style: TextStyle(
                                                color: Colors.amber,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Image(
                                              height: 180.0,
                                              width: 210.0,
                                              image: AssetImage(
                                                  rooms[index]['Image']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        
                                        // Positioned(
                                        //   left: 10.0,
                                        //   bottom: 10.0,
                                        //   child: Column(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.start,
                                        //     children: <Widget>[
                                        //       Text(
                                        //         "xzvdvzv",
                                        //         style: TextStyle(
                                        //           color: Colors.white,
                                        //           fontSize: 24.0,
                                        //           fontWeight: FontWeight.w600,
                                        //           letterSpacing: 1.2,
                                        //         ),
                                        //       ),
                                        //       Row(
                                        //         children: <Widget>[
                                        //           // Icon(
                                        //           //   Icon.locationArrow,
                                        //           //   size: 10.0,
                                        //           //   color: Colors.white,
                                        //           // ),
                                        //           SizedBox(width: 5.0),
                                        //           Text(
                                        //             "davcadvd",
                                        //             style: TextStyle(
                                        //               color: Colors.white,
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ]),
          ))),
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
        child: SizedBox(
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
