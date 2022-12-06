import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:practise/Screens/Home/Home.dart';
import 'package:practise/Screens/Login/login.dart';
import 'package:practise/Screens/SplashScreen/content_model.dart';

class Onbording extends StatefulWidget {
  @override
  _OnbordingState createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        child: Padding(
          padding: const EdgeInsets.only(top:40.0,right:10,left:10),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (_, i) {
                    return Column(
                      children: [
                        Image.asset(
                          contents[i].image,
                          width: screenWidth * 1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                          child: Column(
                            children: [
                              // Text(
                              //   contents[i].title,
                              //   style: TextStyle(
                              //     fontSize: 35,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),

                              Text(
                                contents[i].discription,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 3, 83, 148),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    contents.length,
                    (index) => buildDot(index, context),
                  ),
                ),
              ),
              Row(
                children: [],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(email: '',)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40, top: 0),
                      child: Text(
                        "Skip",
                        style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 60,
                  //   margin: EdgeInsets.all(40),
                  //   //width: double.infinity,
                  //   child: FlatButton(
                  //     child: Text(
                  //         currentIndex == contents.length  ? "Sign In" : "Previous"),
                  //     onPressed: () {
                  //       // if (currentIndex == contents.length - 1) {
                  //       //   Navigator.pushReplacement(
                  //       //     context,
                  //       //     MaterialPageRoute(
                  //       //       builder: (_) => HomeScreen(),
                  //       //     ),
                  //       //   );
                  //       // }
                  //       // _controller.nextPage(
                  //       //   duration: Duration(milliseconds: 100),
                  //       //   curve: Curves.bounceIn,
                  //       // );
                  //     },
                  //     color: Theme.of(context).primaryColor,
                  //     textColor: Colors.white,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    height: 55,
                    margin: EdgeInsets.all(40),
                    width: 180,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: FlatButton(
                        child: Text(currentIndex == contents.length - 1
                            ? "Sign In"
                            : "Next"),
                        onPressed: () {
                          if (currentIndex == contents.length - 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SignIn_body(),
                              ),
                            );
                          }
                          _controller.nextPage(
                            duration: Duration(milliseconds: 100),
                            curve: Curves.bounceIn,
                          );
                        },
                        color: Color.fromARGB(255, 3, 83, 148),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color.fromARGB(255, 3, 83, 148),
      ),
    );
  }
}
