import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practise/Screens/CardPayment/cardPayement.dart';
import 'package:practise/Screens/CashPayment/cashPayment.dart';

class GridDashboard extends StatelessWidget {
  Items item1 = new Items(title: "Cash", img: "assets/png/cash.jpg");

  Items item2 = new Items(
    title: "Card Patyment",
    img: "assets/png/card.png",
  );

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [
      item1,
      item2,
    ];
    var color = 0xff453658;
    return Flexible(
      child: GridView.count(
        childAspectRatio: 1.0,
        padding: EdgeInsets.only(left: 15, right: 15),
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 15,
        children: myList.map((data) {
          return InkWell(
              onTap: () {
                if (data.title == 'Cash') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CashPayment()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CardPayment()),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(color),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      data.img,
                      width: 120,
                      height: 120,
                    ),
                    SizedBox(height: 10),
                    Text(
                      data.title,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        }).toList(),
      ),
    );
  }
}

class Items {
  String title;
  // String subtitle;
  // String event;
  String img;
  Items({required this.title, required this.img});
}
