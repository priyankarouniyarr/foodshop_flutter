import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodshop/pages/bottomnav.dart';
import 'package:foodshop/pages/onboard.dart';
import 'package:lottie/lottie.dart'; // Import your onboarding page

class DonePage extends StatefulWidget {
  @override
  _DonePageState createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  @override
  void initState() {
    super.initState();
    
    Timer(Duration(seconds: 3), () { 
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Bottomnav()), // Replace with your onboarding page
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'Animation/done.json', // Path to your Lottie file
          width: 500,
          height: 500,
        ),
      ),
    );
  }
}
