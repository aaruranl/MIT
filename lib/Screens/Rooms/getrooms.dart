import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:practise/Screens/Home/Home.dart';
import 'package:practise/Screens/Home/dummy.dart';
import 'package:practise/Screens/Map/googleMap.dart';
import 'package:practise/Screens/Payment/payment.dart';
import 'package:practise/Screens/Profile/profile.dart';
import 'package:practise/Utils/Constraints.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
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

  FirebaseStorage storage = FirebaseStorage.instance;

// Retriew the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
            fileMeta.customMetadata?['description'] ?? 'No description'
      });
    });

    return files;
  }

  Query dbRef = FirebaseDatabase.instance.ref().child('rooms');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('rooms');

  Widget listItem({required Map student}) {
    return Container(
      margin: EdgeInsets.all(10.0),
      width: 300.0,
      height: 300,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            bottom: 15.0,
            child: Container(
              height: 170.0,
              width: 300.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: primaryColor, //                   <--- border color
                  width: 1.0,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 11.0),
                      child: Text(
                        student['hotelname'],
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      student['roomtype'],
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 12.0,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "USD " + student['price'].toString(),
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 12.0,
                          ),
                        ),
                        RaisedButton(
                          textColor: Colors.white,
                          color: Color.fromRGBO(0, 0, 0, 1),
                          child: Text("Book"),
                          onPressed: () {
                            print(student['price']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Payment(price:student['price'],name:student['hotelname'],roomtype:student['roomtype'])),
                            );
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                      ],
                    ),
                    //  SizedBox(height: 5),
                    Text(
                      student['location'],
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 12.0,
                      ),
                    ),

//  Row(
//   mainAxisAlignment,: CrossAxisAlignment.end,
//    children: [
//      RaisedButton(
//         textColor: Colors.white,
//         color: Colors.black,
//         child: Text("Search"),
//         onPressed: () {},
//         shape: new RoundedRectangleBorder(
//           borderRadius: new BorderRadius.circular(30.0),
//         ),
//       ),
//    ],
//  ),
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
                Hero(
                  tag: "",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image(
                      height: 145.0,
                      width: 300.0,
                      image: AssetImage(rooms[0]['Image']),
                      fit: BoxFit.cover,
                    ),
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
    );
  }
  var currentIndex = 2;

  @override
  Widget build(BuildContext context) {
       var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          email: '',
                        )),
              );
            },
          ),
          leadingWidth: 70,
          centerTitle: true,
          title: const Text(
            'Our Accomondations',
            style: TextStyle(
                color: primaryColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 0.0),
              // child: Text(
              //   'png',
              //      style: TextStyle(
              //           fontSize: 16.0,
              //           color: primaryColor
              //           // fontWeight: FontWeight.w600,
              //         ),

              // ),
            ),
            // IconButton(
            //   icon: Icon(Icons.qr_code_scanner, color: kPrimaryGreyColor),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => HomePage(email: '',),
            //       ),
            //     );
            //   },
            // ),
            IconButton(
              icon: Icon(Icons.add_circle, color: kPrimaryGreyColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageUploads()),
                );
              },
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        //  backgroundColor: primaryColor,
        body: Container(
          height: double.infinity,
          child: FirebaseAnimatedList(
            query: dbRef,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              Map student = snapshot.value as Map;
              student['key'] = snapshot.key;

              //  final Map<String, dynamic> image =
              //               snapshot.data![index;

              return listItem(student: student);
            },
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
                      MaterialPageRoute(builder: (context) => HomePage(email: '',)),
                    );
                  } else if (currentIndex == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapView()),
                    );
                  } else if (currentIndex == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FetchData()),
                    );
                  } else if (currentIndex == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen(email: '',)),
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
        
   