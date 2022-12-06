// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practise/Screens/Home/Home.dart';
import 'package:practise/Utils/Constraints.dart';

class addCommunity extends StatefulWidget {
  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<addCommunity> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final fb = FirebaseDatabase.instance;

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();

    dbRef = FirebaseDatabase.instance.ref().child('community');
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    final ref = fb.reference().child("community");
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: primaryColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            email: '',
                          )),
                );
              }),
          backgroundColor: kPrimaryWhiteColor,
          elevation: 0,
        ),
        backgroundColor: kPrimaryWhiteColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Community Management',
                    style: TextStyle(
                        fontSize: 20,
                        color: kPrimaryYellow,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenHeight * (0.5 / 20)),
                  _name(),
                  SizedBox(height: screenHeight * (0.25 / 20)),
                  _description(),
                  SizedBox(height: screenHeight * (0.5 / 20)),
                  !_isLoading
                      ? _addCommunity()
                      : CupertinoActivityIndicator(
                          radius: 15,
                        ),
                ],
              ),
            ),
          ),
        ));
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
    print(message);
  }

  _addCommunity() {
    return ButtonTheme(
      minWidth: 300.0,
      height: 40.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: primaryColor, // background
          onPrimary: Colors.transparent,
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState?.save();

            Map<String, String> community = {
              'chatname': _nameController.text,
              'description': _descriptionController.text,
            };

            dbRef.push().set(community);
            Fluttertoast.showToast(msg: "Community Details Added Sucessfully");

            clear();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        email: '',
                      )),
            );
          }
        },
        child: Text(
          'Add Community',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  void clear() {
    _nameController.clear();
    _descriptionController.clear();
  }

  _description() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: TextFormField(
        style: const TextStyle(fontSize: 14, color: primaryColor),
        maxLines: 5,
        cursorColor: kPrimaryPurpleColor,
        keyboardType: TextInputType.multiline,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Description required';
          }
          return null;
        },
        controller: _descriptionController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: "Community Description",
          hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              borderSide: BorderSide(color: primaryColor)),
          contentPadding: EdgeInsets.fromLTRB(25, 10, 10, 10),
          fillColor: kPrimaryWhiteColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              borderSide: BorderSide(color: primaryColor)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            borderSide: BorderSide(color: primaryColor),
            gapPadding: 0,
          ),
        ),
      ),
    );
  }

  _name() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: TextFormField(
          style: const TextStyle(fontSize: 14, color: primaryColor),
          cursorColor: kPrimaryPurpleColor,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Chat name required';
            }
            return null;
          },
          controller: _nameController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: "Chat Name",
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                borderSide: BorderSide(color: primaryColor)),
            contentPadding: EdgeInsets.fromLTRB(25, 10, 10, 10),
            fillColor: kPrimaryWhiteColor,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                borderSide: BorderSide(color: primaryColor)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              borderSide: BorderSide(color: primaryColor),
              gapPadding: 0,
            ),
          ),
        ));
  }
}
