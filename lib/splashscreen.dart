import 'package:flutter/material.dart';
import 'package:foodshop/pages/onboard.dart'; // Replace with your actual import
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );

    _controller.forward();

    _controller.addStatusListener((status) {
     if (status == AnimationStatus.completed) {
       Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (context) => Onboard()), // Replace with your onboarding screen
       );
     }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 26, 119, 131)!, // Lighter green
              const Color.fromARGB(255, 29, 141, 35)!, // Medium green
              const Color.fromARGB(255, 192, 176, 27)!, // Darker green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Lottie.asset('Animation/food1.json'), // Ensure the path is correct
        ),
      ),
    );
  }
}
