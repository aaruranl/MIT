// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:practise/Screens/Home/Home.dart';
import 'package:practise/Utils/Constraints.dart';

class Payment extends StatefulWidget {
  final String price;
  final String name;
  final String roomtype;

  Payment({
    key,
    required this.price,
    required this.name,
    required this.roomtype,
  }) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  //get details form previous screen
  late String price;
  late String name;
  late String roomtype;

//form controllers
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  final TextEditingController _daysController = TextEditingController();

  String? password;
  final bool _isLoading = false;
  int totalprice = 00;

//firebase initilation
  final fb = FirebaseDatabase.instance;
  late DatabaseReference dbRef;

//calculate the total payment
  void _calculate() {
    setState(() {
      totalprice = int.parse(price) * int.parse(_daysController.text);
      print(totalprice);
    });
  }

  @override
  void initState() {
    price = widget.price;
    name = widget.name;
    roomtype = widget.roomtype;
    dateInput.text = "";

    print(price);
    print(name);
    print(roomtype);
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('payment');
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    final ref = fb.reference().child("payment");
    //  final ref = fb.reference().child("community");
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
          padding: const EdgeInsets.only(top: 5.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Booking Management',
                  style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryYellow,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenHeight * (0.5 / 20)),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Name',
                        style: TextStyle(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * (0.25 / 20)),
                _customerName(),
                SizedBox(height: screenHeight * (0.5 / 20)),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number',
                        style: TextStyle(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * (0.25 / 20)),
                _phoneNumber(),
                SizedBox(height: screenHeight * (0.5 / 20)),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Hotel Name',
                        style: TextStyle(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * (0.25 / 20)),
                _name(),
                SizedBox(height: screenHeight * (0.5 / 20)),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        ' Room Type',
                        style: TextStyle(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * (0.25 / 20)),
                _type(),
                SizedBox(height: screenHeight * (0.5 / 20)),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        ' Arrival',
                        style: TextStyle(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * (0.25 / 20)),
                _date(),
                SizedBox(height: screenHeight * (0.5 / 20)),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        ' Number of Days',
                        style: TextStyle(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * (0.25 / 20)),
                _days(),
                SizedBox(height: screenHeight * (0.5 / 20)),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Room Price',
                        style: TextStyle(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * (0.25 / 20)),
                _price(),
                SizedBox(height: screenHeight * (0.75 / 20)),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price',
                        style: TextStyle(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          totalprice.toString() + " USD",
                          style: TextStyle(
                              fontSize: 20,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * (0.75 / 20)),
                !_isLoading
                    ? _addPayment()
                    : CupertinoActivityIndicator(
                        radius: 15,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//toast sucessfull message
  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
    print(message);
  }

//paymet button
  _addPayment() {
    return ButtonTheme(
      minWidth: 300.0,
      height: 40.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          onPrimary: Colors.transparent,
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState?.save();

            Map<String, String> payment = {
              'customerName': _nameController.text,
              'phoneNumber': _phoneController.text,
              'hotelName': name.toString(),
              'roomType': roomtype.toString(),
              'arrival': dateInput.text,
              'numberOfDays': _daysController.text,
              'roomPrice': price.toString(),
              'totalPayment': totalprice.toString()
            };

            dbRef.push().set(payment);
            Fluttertoast.showToast(msg: "Payment Sucessfully");
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
          'Proceed',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

//form clear
  void clear() {
    _nameController.clear();
    _phoneController.clear();

    dateInput.clear();
    _daysController.clear();
  }

//roomtype form
  _type() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: TextFormField(
          readOnly: true,
          initialValue: roomtype.toString(),
          style: const TextStyle(fontSize: 14, color: primaryColor),
          cursorColor: kPrimaryPurpleColor,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Chat name required';
            }
            return null;
          },
          //  controller: _nameController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: "Check In Date",
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

//phonumber textformfield
  _phoneNumber() {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: TextFormField(
        style: TextStyle(fontSize: 14, color: primaryColor),
        cursorColor: kPrimaryPurpleColor,
        keyboardType: TextInputType.number,
        // obscureText: showPassword,
        validator: (value) {
          RegExp regex = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
          if (value!.isEmpty) {
            return 'PhoneNumber required';
          } else if (!regex.hasMatch(value)) {
            return 'Password Must contains  10 digits';
          }
          return null;
        },
        onSaved: (String? val) {
          password = val;
        },
        controller: _phoneController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: "TelephoneNumber",
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

//customer textformfield
  _customerName() {
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
            hintText: " Name",
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

//price textformfiled
  _price() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: TextFormField(
          readOnly: true,
          initialValue: price.toString(),
          style: const TextStyle(fontSize: 14, color: primaryColor),
          cursorColor: kPrimaryPurpleColor,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Chat name required';
            }
            return null;
          },
          //  controller: _nameController,
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

//date textformfield
  _date() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: TextFormField(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2100));

            if (pickedDate != null) {
              print(
                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
              print(
                  formattedDate); //formatted date output using intl package =>  2021-03-16
              setState(() {
                dateInput.text =
                    formattedDate; //set output date to TextField value.
              });
            } else {}
          },
          readOnly: true,
          // initialValue: roomtype.toString(),
          style: TextStyle(fontSize: 14, color: primaryColor),
          cursorColor: kPrimaryPurpleColor,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Chat name required';
            }
            return null;
          },
          controller: dateInput,
          //  controller: _nameController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(Icons.calendar_month),
              color: primaryColor,
            ),
            hintText: "Check In Date",
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

//days textformfield
  _days() {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: TextFormField(
        onChanged: (text) {
          _calculate();
        },
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
          } else if (int.parse(_daysController.text) == 0) {
            return 'Greater than Zero';
          }
          return null;
        },
        onSaved: (String? val) {
          password = val;
        },
        controller: _daysController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: "Number of Days",
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

//bio textformfield
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

//name textformfield
  _name() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: TextFormField(
          readOnly: true,
          initialValue: name.toString(),
          style: const TextStyle(fontSize: 14, color: primaryColor),
          cursorColor: kPrimaryPurpleColor,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Chat name required';
            }
            return null;
          },
          //  controller: _nameController,
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
