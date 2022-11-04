// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:practise/Screens/Community/addCommunity.dart';
import 'package:practise/Screens/Home/Home.dart';
import 'package:practise/Utils/Constraints.dart';

class getCommunityDetails extends StatefulWidget {
  const getCommunityDetails({Key? key}) : super(key: key);

  @override
  State<getCommunityDetails> createState() => _FetchDataState();
}

class _FetchDataState extends State<getCommunityDetails> {
  Query dbRef = FirebaseDatabase.instance.ref().child('community');
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('community');


       bool _isLoading = false;

  // This function will be called when the button gets pressed
  _startLoading() {
    setState(() {
      _isLoading = true;
    });

    Timer(const Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget listItem({required Map community}) {
    return _isLoading
              ?  CircularProgressIndicator()
  : Card(
      elevation: 20,
      // color: Colors.amber,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.all(10),
      color: Colors.green[100],
      shadowColor: Colors.blueGrey,
      // elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.messenger, color: Colors.black, size: 45),
            title: Text(
              community["chatname"],
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(community["description"]),
            ),
          ),
        ],

        //   mainAxisAlignment: MainAxisAlignment.end,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     GestureDetector(
        //       onTap: () {
        //    //    Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateRecord(studentKey: student['key'])));
        //       },
        //       child: Row(
        //         children: [
        //           Icon(
        //             Icons.edit,
        //             color: Theme.of(context).primaryColor,
        //           ),
        //         ],
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 6,
        //     ),
        //     GestureDetector(
        //       onTap: () {
        //         reference.child(community['key']).remove();
        //       },
        //       child: Row(
        //         children: [
        //           Icon(
        //             Icons.delete,
        //             color: Colors.red[700],
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon:  Icon(Icons.arrow_back_rounded, color: primaryColor),
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
            'Our Community',
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
                  MaterialPageRoute(builder: (context) => addCommunity()),
                );
              },
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          height: double.infinity,
          child: FirebaseAnimatedList(
            query: dbRef,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              Map community = snapshot.value as Map;
              community['key'] = snapshot.key;

              return listItem(community: community);
            },
          ),
        ));
  }
}
