// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:io';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:practise/Screens/Home/Home.dart';
import 'package:practise/Screens/Profile/newUserProfile.dart';
import 'package:practise/Utils/Constraints.dart';
import 'package:practise/Utils/sharedPreferences.dart';

class UserScreens extends StatefulWidget {
  const UserScreens({Key? key}) : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<UserScreens> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confpasswordController = TextEditingController();

  bool showConfirmPassword = true;

  final photos = <File>[];

  String? password;
  String? confirm;

  String? bodyError;

  bool _isLoading = false;
  bool showPassword = true;
  bool showconfirmPassword = true;
  bool image = false;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final fb = FirebaseDatabase.instance;

  late DatabaseReference dbRef;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

  String userEmail = "";
  String userName = "";
  String userAddress = "";
  String userBio = "";
  String userPhoto = "";

  // loader

  //get subjects details from api
  void getUserDateails() async {
    userEmail = await MySharedPreferences.instance.getStringValue("Email");
    userName = await MySharedPreferences.instance.getStringValue("userName");
    userAddress =
        await MySharedPreferences.instance.getStringValue("userAddress");
    userBio = await MySharedPreferences.instance.getStringValue("userBio");
    print("hello" + userEmail);

    try {} catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getUserDateails();
    dbRef = FirebaseDatabase.instance.ref().child('profile');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference().child("profile");
    var screenHeight = MediaQuery.of(context).size.height;
    // final ref = fb.reference().child("rooms");
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: primaryColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileView()),
                );
              }),
          backgroundColor: kPrimaryWhiteColor,
          elevation: 0,
        ),
        backgroundColor: kPrimaryWhiteColor,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Profile',
                  style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryYellow,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenHeight * (0.25 / 20)),
                SizedBox(height: screenHeight * (0.25 / 20)),
                GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.grey[200],
                    child: _photo != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              _photo!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : CircleAvatar(
                            radius: 75,
                            child: ClipRRect(
                              child: Image.asset('assets/png/profile.png'),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                  ),
                ),
                // SizedBox(height: screenHeight * (0.35 / 20)),

                // _email(),
                SizedBox(height: screenHeight * (0.35 / 20)),
                _name(),
                SizedBox(height: screenHeight * (0.35 / 20)),
                _address(),
                SizedBox(height: screenHeight * (0.35 / 20)),
                // _password(),
                // SizedBox(height: screenHeight * (0.35 / 20)),
                // _Confirmpassword(),
                SizedBox(height: screenHeight * (0.35 / 20)),
                _bio(),
                !_isLoading
                    ? bodyError != null
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                            child: Container(
                              padding: EdgeInsets.only(top: 10),
                              alignment: Alignment.topLeft,
                              child: Text(
                                bodyError.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.red),
                              ),
                            ))
                        : SizedBox()
                    : SizedBox(),
                SizedBox(height: screenHeight * (0.5 / 20)),
                !_isLoading
                    ? _addRooms()
                    : CupertinoActivityIndicator(
                        radius: 15,
                      ),
              ],
            ),
          ),
        ));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
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

  _addRooms() {
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

            Map<String, String> profile = {
              'name': _nameController.text,
              'address': _addressController.text,
              'bio': _bioController.text
            };

            dbRef.push().set(profile);
            Fluttertoast.showToast(msg: "Profile Update Sucessfully !!!");

            // MySharedPreferences.instance
            //     .setStringValue("userName", _nameController.text.trim());

            // MySharedPreferences.instance
            //     .setStringValue("userAddress", _addressController.text.trim());

            // MySharedPreferences.instance
            //     .setStringValue("userBio", _bioController.text.trim());

            // MySharedPreferences.instance
            //     .setStringValue("userPhoto", _photo!.toString());

            // Map<String, String> rooms = {
            //   'hotelname': _nameController.text,
            //   'roomtype': _selectedLocation!,
            //   'price': _priceController.text,
            //   'remarks': _bioController.text,
            //   'location': _controller.text,
            // };
            // uploadFile();

            // dbRef.push().set(rooms);
            // Fluttertoast.showToast(msg: "Rooms Added Sucessfully");

            clear();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => HomePage(
            //             email: '',
            //           )),
            // );

            // submitSubscription(file: _image, filename: _ImageS);
          }
        },
        child: Text(
          'Update Profile',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

//clear formfield Controller
  void clear() {
    _nameController.clear();
    _bioController.clear();
    _addressController.clear();
  }

//bio TextformFielld
  _bio() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: TextFormField(
        //   initialValue: userEmail.toString(),
        style: const TextStyle(fontSize: 14, color: primaryColor),
        maxLines: 5,
        cursorColor: kPrimaryPurpleColor,
        keyboardType: TextInputType.multiline,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Bio required';
          }
          return null;
        },
        controller: _bioController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: "Bio",
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

//email TextformFielld
  _email() {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: TextFormField(
        readOnly: false,
        initialValue: userEmail.toString(),
        style: TextStyle(fontSize: 16, color: primaryColor),
        cursorColor: primaryColor,
        keyboardType: TextInputType.text,
        validator: (value) {
          RegExp regex = RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
          if (value!.isEmpty) {
            return 'Email Required';
          } else if (!regex.hasMatch(value)) {
            return 'Email Required';
          }
          return null;
        },
        onSaved: (String? val) {
          password = val;
        },
        //controller: _emailController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          // hintText: "Email Address",
          // hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
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

//password TextformFielld
  _password() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: TextFormField(
        style: const TextStyle(fontSize: 16.0, color: primaryColor),
        cursorColor: primaryColor,
        keyboardType: TextInputType.text,
        obscureText: showPassword,
        validator: (value) {
          RegExp regex = RegExp(
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
          if (value!.isEmpty) {
            return 'Password required';
          } else if (!regex.hasMatch(value)) {
            return 'Password Must contains \n - Minimum 1 Upper case \n - Minimum 1 lowercase \n - Minimum 1 Number \n - Minimum 1 Special Character \n - Minimum 8 letters';
          }
          return null;
        },
        onSaved: (String? val) {
          password = val;
        },
        controller: _passwordController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: "Password",
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

//name TextformFielld
  _name() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: TextFormField(
          style: const TextStyle(fontSize: 14, color: primaryColor),
          cursorColor: kPrimaryPurpleColor,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Name required';
            }
            return null;
          },
          controller: _nameController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: "Name",
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

  _address() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: TextFormField(
          style: const TextStyle(fontSize: 14, color: primaryColor),
          cursorColor: kPrimaryPurpleColor,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Address required';
            }
            return null;
          },
          controller: _addressController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: "Address",
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
