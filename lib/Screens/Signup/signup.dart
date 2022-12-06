// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:practise/Screens/Home/Home.dart';
import 'package:practise/Screens/Login/login.dart';
import 'package:practise/Utils/Constraints.dart';
import 'package:flutter/cupertino.dart';
import 'package:practise/Utils/sharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp_body extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp_body> {
  bool _isLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confpasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? email, password;
  final auth = FirebaseAuth.instance;

  bool showPassword = true;
  bool showConfirmPassword = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _submit() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 108, 74, 231),
              Color.fromARGB(255, 44, 21, 126),
              Color.fromARGB(255, 44, 21, 126),
              Color.fromARGB(255, 44, 21, 120),
              Color.fromARGB(255, 108, 74, 231),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          color: kPrimaryLightColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _email(),
                      SizedBox(
                        height: 30,
                      ),
                      _password(),
                      SizedBox(
                        height: 30,
                      ),
                      _Confirmpassword(),
                      SizedBox(
                        height: 30,
                      ),
                      !_isLoading
                          ? _Register()
                          : CupertinoActivityIndicator(
                              radius: 15,
                            ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        width: 250.0,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Divider(
                              thickness: 1.0,
                              color: Colors.white,
                            )),
                            Text(
                              "   OR   ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SignInButton(
                        Buttons.Google,
                        onPressed: () async {
                          await signInWithGoogle();
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Alredy Have an account ?",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignIn_body()),
                                );
                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Email Feils
  _email() {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: TextFormField(
        style: const TextStyle(fontSize: 16, color: kPrimaryBlueColor),
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
        controller: _emailController,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          hintText: "Email ",
          hintStyle: TextStyle(
            fontSize: 16.0,
            color: kPrimaryGreyColor,
          ),
          fillColor: kPrimaryWhiteColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide.none,
            gapPadding: 0,
          ),
        ),
      ),
    );
  }

//Password Feild
  _password() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: TextFormField(
        style: const TextStyle(fontSize: 16.0, color: kPrimaryBlueColor),
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
          suffixIcon: IconButton(
            onPressed: () => setState(() => showPassword = !showPassword),
            icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
            color: kPrimaryBlueColor,
          ),
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          hintText: "Password",
          hintStyle: TextStyle(
            fontSize: 16.0,
            color: kPrimaryGreyColor,
          ),
          fillColor: kPrimaryWhiteColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide.none,
            gapPadding: 0,
          ),
        ),
      ),
    );
  }

  //Password Feild
  _Confirmpassword() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: TextFormField(
        style: const TextStyle(fontSize: 16.0, color: kPrimaryBlueColor),
        cursorColor: primaryColor,
        keyboardType: TextInputType.text,
        obscureText: showConfirmPassword,
        validator: (val) =>
            val != _passwordController.text ? 'Password Not Matched' : null,
        onSaved: (val) => password = val,
        controller: _confpasswordController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () =>
                setState(() => showConfirmPassword = !showConfirmPassword),
            icon: Icon(
                showConfirmPassword ? Icons.visibility_off : Icons.visibility),
            color: kPrimaryBlueColor,
          ),
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          hintText: "Confirm Password",
          hintStyle: TextStyle(
            fontSize: 16.0,
            color: kPrimaryGreyColor,
          ),
          fillColor: kPrimaryWhiteColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide.none,
            gapPadding: 0,
          ),
        ),
      ),
    );
  }

//google sign in
  Future<UserCredential> signInWithGoogle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      MySharedPreferences.instance
          .setStringValue("photo", googleUser.photoUrl!);
      MySharedPreferences.instance.setStringValue("Email", googleUser.email);

      prefs.setString('userId', googleUser.id);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(email: '')),
      );

      Fluttertoast.showToast(msg: " Sucessfully Login !!!");
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //Sign In Button
  _Register() {
    return Container(
      margin: EdgeInsets.only(left: 50, right: 50, top: 20),
      height: 65.0,
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: kPrimaryWhiteColor),
        ),
        onPressed: () async {
          _submit();
          _register();
        },
        padding: EdgeInsets.all(10.0),
        color: Color.fromARGB(255, 44, 21, 120),
        textColor: Colors.white,
        child: Text(
          "Register",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    // String confirmpassword = _confpasswordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      setState(() {
        if (user != null) {
          Fluttertoast.showToast(msg: "user created");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      email: '',
                    )),
          );
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    setState(() {
      _isLoading = false;
    });
    // } else {
    //   Fluttertoast.showToast(msg: "Passwords don't match");
  }
}
