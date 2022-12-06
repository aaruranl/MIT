// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practise/Screens/Home/Home.dart';
import 'package:practise/Screens/Signup/signup.dart';
import 'package:practise/Screens/forgotPassword/forgotPassword.dart';
import 'package:practise/Utils/Constraints.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:practise/Utils/sharedPreferences.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SignIn_body extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SignIn_body> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = new GlobalKey();

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? email, password;
  final auth = FirebaseAuth.instance;

  String? userEmail = "";
  String? name = "";
  String? image = "";

  bool showPassword = true;
  bool _isLoading = false;
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

  void performLogin() {
    final snackbar = new SnackBar(
      content: new Text("Email : $email, password : $password"),
    );
    scaffoldKey.currentState!.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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

                // Color(0xFFFFEB74D),
                // Colors.pinkAccent,
                // Color(0xFFBA68C8),
                // Color(0xFF7E57C2),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 70,
                      ),
                      Text(
                        "Sign In",
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

                      Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Container(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            highlightColor: Colors.transparent,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 0.0),
                              child: Text(
                                'Forget Password ?',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: kPrimaryWhiteColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      !_isLoading
                          ? _signIn()
                          : CupertinoActivityIndicator(
                              radius: 15,
                            ),
                      //     Padding(
                      //       padding: const EdgeInsets.all(20.0),
                      //       child: Form(
                      //         key: formKey,
                      //  //       autovalidate: true,
                      //         child: Stack(
                      //           children: <Widget>[
                      //             Column(
                      //               children: <Widget>[
                      //                 Container(
                      //                   padding: EdgeInsets.symmetric(horizontal: 15),
                      //                   decoration: BoxDecoration(
                      //                     color: Colors.white,
                      //                     shape: BoxShape.rectangle,
                      //                     borderRadius: BorderRadius.circular(8),
                      //                     boxShadow: [
                      //                       BoxShadow(
                      //                         color: Colors.black.withOpacity(0.2),
                      //                         spreadRadius: 1,
                      //                         blurRadius: 10,
                      //                         offset: Offset(0, 3),
                      //                       )
                      //                     ],
                      //                   ),
                      //                   child: Column(
                      //                     children: <Widget>[
                      //                       SizedBox(
                      //                         height: 20,
                      //                       ),
                      //                       emailInput(),
                      //                       SizedBox(
                      //                         height: 40,
                      //                       ),
                      //                       passwordInput(),
                      //                       SizedBox(
                      //                         height: 40,
                      //                       ),
                      //                       Row(
                      //                         children: [
                      //                           GestureDetector(
                      //                             onTap: () {
                      //                               // Navigator.push(
                      //                               //   context,
                      //                               //   MaterialPageRoute(
                      //                               //       builder: (context) =>
                      //                               //           Forget(title: "")),
                      //                               // );
                      //                             },
                      //                             child: Text(
                      //                               "Forget Password?",
                      //                               style: TextStyle(
                      //                                   color: kPrimaryColor,
                      //                                   decoration:
                      //                                       TextDecoration.underline
                      //                                   // fontWeight: FontWeight.bold,
                      //                                   // fontSize: 20,
                      //                                   ),
                      //                             ),
                      //                           )
                      //                         ],
                      //                       ),
                      //                       SizedBox(
                      //                         height: 100,
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             Positioned(
                      //               bottom: -35,
                      //               right: 0,
                      //               left: 0,
                      //               child: Container(
                      //                 child: Column(
                      //                   mainAxisAlignment: MainAxisAlignment.center,
                      //                   crossAxisAlignment: CrossAxisAlignment.center,
                      //                   children: [
                      //                     FlatButton(
                      //                       onPressed: () async {
                      //                         await onClick();
                      //                       },
                      //                       textColor: Colors.white,
                      //                       padding: const EdgeInsets.all(0.0),
                      //                       shape: CircleBorder(
                      //                         side: BorderSide(
                      //                             color: Colors.white,
                      //                             width: 5,
                      //                             style: BorderStyle.solid),
                      //                       ),
                      //                       child: Container(
                      //                         decoration: const BoxDecoration(
                      //                           borderRadius: BorderRadius.all(
                      //                               Radius.circular(100.0)),
                      //                           gradient: LinearGradient(
                      //                             begin: Alignment.bottomRight,
                      //                             end: Alignment.topLeft,
                      //                             // stops: [0.3, 0.3, 0.7, 0.1, 1],
                      //                             colors: [
                      //                               Color(0xFFFFE0B2),
                      //                               Color(0xFFFFB74D),
                      //                               Color(0xFFE040FB),
                      //                               Color(0xFFBA68C8),
                      //                               Color(0xFF7E57C2),
                      //                             ],
                      //                           ),
                      //                         ),
                      //                         padding: const EdgeInsets.all(15.0),
                      //                         child: _isLoading ? CircularProgressIndicator(
                      //                           strokeWidth: 2,
                      //                           color: Colors.white,
                      //                         ) : Icon(
                      //                           Icons.arrow_forward,
                      //                           size: 35.0,
                      //                           color: Colors.white,
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //           overflow: Overflow.visible,
                      //         ),
                      //       ),
                      //     ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: 250.0,
                        child: Row(children: <Widget>[
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
                          )),
                        ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // with custom text
                      SignInButton(
                        Buttons.Google,
                        onPressed: () async {
                          await signInWithGoogle();

                          setState(() {});
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //  RaisedButton(onPressed: () async {
                      //    SharedPreferences prefs = await SharedPreferences.getInstance();
                      //   //  prefs.setString('userId', user!.uid);
                      //    print(prefs.getString('userId'));
                      //   //  push(context, Signup());
                      //   //  print(user!.uid);
                      //  }, child: Text("data"),),
                      Container(
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't Have an account ?",
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
                                      builder: (context) => SignUp_body()),
                                );
                              },
                              child: Text(
                                'Sign Up',
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
                ]),
              ),
            ),
          )),
    ));
  }

  onClick() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // showProgress(context, 'Logging in, please wait...', false);
      print("Logging in");
      //await resetPassword(email.trim());

      User? user = await _signInWithEmailAndPassword();
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('userId', user.uid);
      // print(prefs.setString('userId', user.uid));
      // getUserAccounts(user.userID);
      // if (user != null) pushAndRemoveUntil(context, Home(), false);
    } else {
      print("validate");
    }
  }

  _signInWithEmailAndPassword() async {
    var errorMessage;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = true;
    });
    try {
      final userCredential = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim()))
          .user;
      if (userCredential != null) {
        User? user = FirebaseAuth.instance.currentUser;
        errorMessage = 'Successfully logged In!.';
        MySharedPreferences.instance
            .setStringValue("Email", _emailController.text.trim());
        prefs.setString('userId', user!.uid);
        prefs.setString('email', _emailController.text.trim());
        prefs.setString('usemailerId', user.uid);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    email: _emailController.text,
                  )),
        );
        // print(user!.email);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Email already used.';
      } else if (e.code == 'account-exists-with-different-credential') {
        errorMessage = 'Email already used.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'User disabled.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Too many requests to log into this account.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Email address is invalid.';
      } else {
        errorMessage = 'Login failed. Please try again.';
      }
      // toastMessage(errorMessage);
    }
    toastMessage(errorMessage);
    setState(() {
      _isLoading = false;
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

  Future<UserCredential> signInWithGoogle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      MySharedPreferences.instance
          .setStringValue("photo", googleUser.photoUrl!);
          MySharedPreferences.instance
          .setStringValue("Email", googleUser.email);
      // prefs.setString('email', googleUser.email);
      // prefs.setString('name', googleUser.displayName!);
      // prefs.setString('photo', googleUser.photoUrl!);
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

    // userEmail = googleUser.email;
    // name = googleUser!.displayName!;
    // image = googleUser!.photoUrl!;

    print(name);
    print(image);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //Sign In Button
  _signIn() {
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
          await onClick();
        },
        padding: EdgeInsets.all(10.0),
        color: Color.fromARGB(255, 44, 21, 120),
        textColor: Colors.white,
        child: Text(
          "Login",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
