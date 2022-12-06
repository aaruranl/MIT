import 'dart:io';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:practise/Screens/Home/Home.dart';
import 'package:practise/Utils/Constraints.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class ImageUploads extends StatefulWidget {
  const ImageUploads({Key? key}) : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _profileController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  //drop down for country
  List<String> _locations = [
    'Single Room',
    'Double Romm',
    'Trible Room',
    'Single Room Deluxe',
    'Double Romm Deluxe',
    'Trible Room Deluxe',
  ];

  String? _selectedLocation;

  final photos = <File>[];

  bool _loaderListView = false;

  String? password;
  String? confirm;
  String? _uploadedFileURL;
  String? bodyError;

  bool _isLoading = false;
  bool showPassword = true;
  bool showconfirmPassword = true;
  bool image = false;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

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

  final fb = FirebaseDatabase.instance;

  late DatabaseReference dbRef;

  @override
  void initState() {
    _controller.addListener(() {
      _onChanged();
    });
    super.initState();

    dbRef = FirebaseDatabase.instance.ref().child('rooms');
  }

  final _controller = TextEditingController();
  var uuid = new Uuid();
  String? _sessionToken;
  List<dynamic> _placeList = [];
  List<dynamic> _latlon = [];
  bool buscando = false;

  String _startAddress = '';

  GoogleMapController? mapController;

  List<Marker> _markers = [];
  double? latfromMap;
  double? lonfromMap;
  getAddressFromLatLng() async {
    print("-----SEARCH MAP-----");
    List locations = await locationFromAddress(_controller.text);
    // print(locations);
    print(locations[0]);
    print(locations[0].latitude);
    print(locations[0].longitude);
    latfromMap = locations[0].latitude;
    lonfromMap = locations[0].longitude;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _controller.addListener(() {
  //     _onChanged();
  //   });
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyDM8U1e_9FPJqaCu4Vv0YrMxj6vqEyWyiA";
    String type = 'country:Lk';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken&components=$type';

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });

      for (var i in _placeList) {}
    } else {
      throw Exception('Failed to load predictions');
    }
  }

//  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    final ref = fb.reference().child("rooms");
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
                Padding(
                   padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: TextField(
                    onTap: () {
                      _loaderListView = false;
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Search Location",
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
                ),

                _loaderListView
                    ? Text("")
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _placeList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_placeList[index]["description"]),
                            onTap: () {
                              print(_placeList[index]["description"]);
                              print("---------------------");
                              setState(() {
                                _loaderListView = true;
                                _controller.text =
                                    _placeList[index]["description"];
                              });
                              getAddressFromLatLng();
                              //  searchnavigate();
                            },
                          );
                        },
                      ),
                SizedBox(height: screenHeight * (0.25 / 20)),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Upload Room Image - :",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * (0.25 / 20)),
                GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: Container(
                    width: 300,
                    height: 200,
                    // radius: 100,

                    //  backgroundColor: const Color(0xffFDCF09),
                    child: _photo != null
                        ? ClipRRect(
                            //   borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              _photo!,
                              width: 250,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50)),
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ),

                SizedBox(height: screenHeight * (0.25 / 20)),
                _bio(),

                // Padding(
                //    padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                //   child: TextField(
                //     onTap: () {
                //       _loaderListView = false;
                //     },
                //     controller: _controller,
                //     decoration: InputDecoration(
                //       hintText: "Search Location",
                //       hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                //       focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //           borderSide: BorderSide(color: primaryColor)),
                //       contentPadding: EdgeInsets.fromLTRB(25, 10, 10, 10),
                //       fillColor: kPrimaryWhiteColor,
                //       filled: true,
                //       enabledBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //           borderSide: BorderSide(color: primaryColor)),
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //         borderSide: BorderSide(color: primaryColor),
                //         gapPadding: 0,
                //       ),
                //     ),
                //   ),
                // ),

                // _loaderListView
                //     ? Text("")
                //     : ListView.builder(
                //         physics: const NeverScrollableScrollPhysics(),
                //         shrinkWrap: true,
                //         itemCount: _placeList.length,
                //         itemBuilder: (context, index) {
                //           return ListTile(
                //             title: Text(_placeList[index]["description"]),
                //             onTap: () {
                //               print(_placeList[index]["description"]);
                //               print("---------------------");
                //               setState(() {
                //                 _loaderListView = true;
                //                 _controller.text =
                //                     _placeList[index]["description"];
                //               });
                //               getAddressFromLatLng();
                //               //  searchnavigate();
                //             },
                //           );
                //         },
                //       ),

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
          // child: GestureDetector(
          //   onTap: () {
          //     _showPicker(context);
          //   },
          //   child: Container(
          //     width:250,
          //     height:220,
          //    // radius: 100,

          //   //  backgroundColor: const Color(0xffFDCF09),
          //     child: _photo != null
          //         ? ClipRRect(
          //    //   borderRadius: BorderRadius.circular(50),
          //       child: Image.file(
          //         _photo!,
          //         width: 250,
          //         height: 220,
          //         fit: BoxFit.cover,
          //       ),
          //     )
          //         : Container(
          //       decoration: BoxDecoration(
          //           color: Colors.grey[200],
          //           borderRadius: BorderRadius.circular(50)),
          //       width: 100,
          //       height: 100,
          //       child: Icon(
          //         Icons.camera_alt,
          //         color: Colors.grey[800],
          //       ),
          //     ),
          //   ),
          // ),
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

  _price() {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: TextFormField(
        style: TextStyle(fontSize: 14, color: primaryColor),
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
          hintText: "Room Price",
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

            Map<String, String> rooms = {
              'hotelname': _nameController.text,
              'roomtype': _selectedLocation!,
              'price': _priceController.text,
              'remarks': _bioController.text,
              'location': _controller.text,
            };
            uploadFile();

            dbRef.push().set(rooms);
            Fluttertoast.showToast(msg: "Rooms Added Sucessfully");

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
          'Add Rooms',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  void clear() {
    _nameController.clear();
    _priceController.clear();
    _bioController.clear();
  }

  _bio() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: TextFormField(
        style: const TextStyle(fontSize: 14, color: primaryColor),
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
        decoration: InputDecoration(
          hintText: "Remarks",
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
              return 'Name required';
            }
            return null;
          },
          controller: _nameController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: "Hotel Name",
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

  _location() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: TextFormField(
          style: const TextStyle(fontSize: 14, color: primaryColor),
          cursorColor: kPrimaryPurpleColor,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Location required';
            }
            return null;
          },
          controller: _locationController,
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

  Padding countryDropdown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          hintText: "Room Type",
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
            child: new Text(
              location,
            ),
            value: location,
          );
        }).toList(),
      ),
    );
  }

  locationFromAddress(String text) {}
}
