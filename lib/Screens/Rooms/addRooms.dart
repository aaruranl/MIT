import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practise/Screens/Home/Home.dart';
import 'package:practise/Utils/Constraints.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _profileController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  //drop down for country
  List<String> _locations = [
    'Srilanka',
    'India',
    'United Kingdom',
    'Austrilia',
  ];

  String? _selectedLocation;

  final photos = <File>[];

  String? password;
  String? confirm;
  String? _uploadedFileURL;
  String? bodyError;

  bool _isLoading = false;
  bool showPassword = true;
  bool showconfirmPassword = true;
  bool image = false;

  File? _image;
  late Future<String> fileurl;
  var _ImageS;

  //get image
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        // _image = image;
        _image = File(pickedFile.path);
        _ImageS = pickedFile.path;

        //file path upload
        if (_image != null) {
          _profileController.text = "Sucessful Uploaded";
        } else {
          _profileController.text = "Unscessful Upload";
        }

        print(_image);
        print('------');
        print(pickedFile.path);
        // uploadFile();

        print(_ImageS);
        image = true;
      });
    }
  }

  //   firebase_storage.FirebaseStorage storage =
  //     firebase_storage.FirebaseStorage.instance;

  //  Future uploadFile() async {
  //   if (_image == null) return;
  //   final fileName = basename(_image!.path);
  //   final destination = 'files/$fileName';

  //   try {
  //     final ref = firebase_storage.FirebaseStorage.instance
  //         .ref(destination)
  //         .child('file/');
  //     await ref.putFile(_image!);
  //   } catch (e) {
  //     print('error occured');
  //   }
  // }

  final fb = FirebaseDatabase.instance;

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();

    dbRef = FirebaseDatabase.instance.ref().child('rooms');
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference().child("rooms");
    var screenHeight = MediaQuery.of(context).size.height;

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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Rooms Management',
                style: TextStyle(
                    fontSize: 20,
                    color: kPrimaryYellow,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * (0.5 / 20)),
              _name(),
              SizedBox(height: screenHeight * (0.25 / 20)),
              countryDropdown(),
              SizedBox(height: screenHeight * (0.25 / 20)),
              _price(),
              SizedBox(height: screenHeight * (0.25 / 20)),
              _profile(),

              SizedBox(height: screenHeight * (0.25 / 20)),
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

              // SizedBox(height: 5.0),
              SizedBox(height: screenHeight * (0.5 / 20)),

              !_isLoading
                  ? _addRooms()
                  : CupertinoActivityIndicator(
                      radius: 15,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _price() {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: TextFormField(
        style: TextStyle(fontSize: 14, color: kPrimaryWhiteColor),
        cursorColor: kPrimaryPurpleColor,
        keyboardType: TextInputType.number,
        // obscureText: showPassword,
        validator: (value) {
          RegExp regex = new RegExp(r'^(^(?:[+0]9)?[0-9]{0,}?(\.\d{1,2})?$)');
          if (value!.length == 0) {
            return 'Amount required';
          } else if (!regex.hasMatch(value)) {
            return 'Amount Must\n -Only Positive Value';
          } else if (int.parse(_priceController.text) == 0) {
            return 'Greater than Zero';
          }
          return null;
        },
        onSaved: (String? val) {
          password = val;
        },
        controller: _priceController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          hintText: "Room Price",
          hintStyle: TextStyle(
            fontSize: 14.0,
            color: kPrimaryWhiteColor,
          ),
          fillColor: kPrimarylightGreyColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide.none,
            gapPadding: 0,
          ),
        ),
      ),
    );
  }

  _password() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: TextFormField(
        style: const TextStyle(fontSize: 14, color: kPrimaryWhiteColor),
        cursorColor: kPrimaryPurpleColor,
        keyboardType: TextInputType.text,
        obscureText: showPassword,
        validator: (value) {
          RegExp regex = RegExp(
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
          if (value!.isEmpty) {
            return 'Password required';
          } else if (!regex.hasMatch(value)) {
            return 'Password Must contains \n - Minimum 1 Upper case \n - Minimum 1 lowercase \n - Minimum 1 Number \n - Minimum 1 Special Character(! @ #  % & *) \n - Minimum 8 letters';
          }
          return null;
        },
        onSaved: (String? val) {
          password = val;
        },
        controller: _passwordController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () => setState(() => showPassword = !showPassword),
            icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
            color: kPrimaryGreyColor,
          ),
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          hintText: "Password",
          hintStyle: TextStyle(
            fontSize: 14.0,
            color: kPrimaryWhiteColor,
          ),
          fillColor: kPrimarylightGreyColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
            borderSide: BorderSide.none,
            gapPadding: 0,
          ),
        ),
      ),
    );
  }

  _confirmpassword() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: TextFormField(
        style: const TextStyle(fontSize: 14, color: Colors.white),
        cursorColor: kPrimaryPurpleColor,
        keyboardType: TextInputType.text,
        obscureText: showconfirmPassword,
        validator: (value) {
          RegExp regex = RegExp(
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
          if (value!.isEmpty) {
            return 'Password required';
          } else if (!regex.hasMatch(value)) {
            return 'Password Must contains \n - Minimum 1 Upper case \n - Minimum 1 lowercase \n - Minimum 1 Number \n - Minimum 1 Special Character \n - Minimum 8 letters';
          } else if (value != _passwordController.text) {
            return 'Not Matched';
          }
          return null;
        },
        onSaved: (String? val) {
          confirm = val;
        },
        controller: _confirmpasswordController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () =>
                setState(() => showconfirmPassword = !showconfirmPassword),
            icon: Icon(
                showconfirmPassword ? Icons.visibility_off : Icons.visibility),
            color: kPrimaryGreyColor,
          ),
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          hintText: "Re-Enter Password",
          hintStyle: TextStyle(fontSize: 14.0, color: kPrimaryWhiteColor),
          fillColor: kPrimarylightGreyColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
            borderSide: BorderSide.none,
            gapPadding: 0,
          ),
        ),
      ),
    );
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
          primary: kPrimaryPurpleColor, // background
          onPrimary: Colors.transparent,
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState?.save();

            Map<String, String> rooms = {
              'hotelname': _nameController.text,
              'roomtype': _selectedLocation!,
              'price': _priceController.text,
              'remarks': _bioController.text,
              'ScannedItem': _image!.toString(),
            };

            dbRef.push().set(rooms);
            Fluttertoast.showToast(msg: "Rooms Added Sucessfully");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        email: '',
                      )),
            );

            // submitSubscription(file: _image, filename: _ImageS);
          }
        },
        child: Text(
          'Add Rooms',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  _bio() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: TextFormField(
        style: const TextStyle(fontSize: 14, color: kPrimaryWhiteColor),
        maxLines: 5,
        cursorColor: kPrimaryPurpleColor,
        keyboardType: TextInputType.multiline,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Remarks required';
          }
          return null;
        },
        controller: _bioController,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          hintText: "Remarks",
          hintStyle: TextStyle(
            fontSize: 14.0,
            color: kPrimaryWhiteColor,
          ),
          fillColor: kPrimarylightGreyColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide.none,
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
          style: const TextStyle(fontSize: 14, color: kPrimaryWhiteColor),
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
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            hintText: "Hotem Name",
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: kPrimaryWhiteColor,
            ),
            fillColor: kPrimarylightGreyColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide.none,
              gapPadding: 0,
            ),
          ),
        ));
  }

  Padding countryDropdown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          hintText: "Room Type",
          hintStyle: TextStyle(fontSize: 14.0, color: kPrimaryWhiteColor),
          fillColor: kPrimarylightGreyColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide.none,
            gapPadding: 0,
          ),
        ),
        isExpanded: true,
        // hint: Text('Select Country'), // Not necessary for Option 1
        value: _selectedLocation,
        onChanged: (String? newValue) {
          setState(() {
            _selectedLocation = newValue;
          });
        },
        validator: (value) => value == null ? 'Room Type required' : null,
        items: _locations.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
    );
  }

  _profile() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: TextFormField(
          style: const TextStyle(fontSize: 14, color: kPrimaryWhiteColor),
          minLines: 1,
          cursorColor: kPrimaryPurpleColor,
          keyboardType: TextInputType.none,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Image required';
            }
            return null;
          },
          controller: _profileController,
          textInputAction: TextInputAction.none,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            hintText: "Room Image",
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: kPrimaryWhiteColor,
            ),
            fillColor: kPrimarylightGreyColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide.none,
              gapPadding: 0,
            ),
            suffixIcon: Container(
              width: 100,
              child: Row(
                children: [
                  Text("Upload",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: kPrimaryWhiteColor,
                      )),
                  IconButton(
                    icon: Icon(
                      Icons.insert_photo_rounded,
                      color: kPrimaryWhiteColor,
                      size: 30.0,
                    ),
                    onPressed: () {
                      _getFromGallery();
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
