import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodshop/pages/home.dart';
import 'package:foodshop/pages/order.dart';
import 'package:foodshop/pages/profile.dart';
import 'package:foodshop/pages/wallet.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int currentIndex = 0;
  late List<Widget> pages;
  late Widget currentPage;
  late Home HomePage;
  late Profile profile;
  late Wallet wallet;
  late Order order;

  @override
  void initState() {
    HomePage = Home();
    profile = Profile();
    wallet = Wallet();
    order = Order();
    pages = [Home(), Profile(), Wallet(), Order()];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 65,
          backgroundColor: Colors.green,
          animationDuration: Duration(milliseconds: 500),
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            Icon(Icons.home_outlined, color: Colors.green),
            Icon(Icons.person_outline, color: Colors.green),
            Icon(Icons.wallet_outlined, color: Colors.green),
            Icon(Icons.shopping_cart_outlined, color: Colors.green),
          ]),
      body: pages[currentIndex],
    );
  }
}
