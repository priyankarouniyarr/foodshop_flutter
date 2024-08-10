import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodshop/Widget/app_constant%20.dart';
import 'package:foodshop/admin/addfood.dart';
import 'package:foodshop/admin/admin_login.dart';
import 'package:foodshop/admin/adminhome.dart';
import 'package:foodshop/pages/bottomnav.dart'; // Ensure this path is correct
import 'package:foodshop/pages/login.dart'; // Ensure this path is correct
import 'package:foodshop/pages/onboard.dart'; // Ensure this path is correct
import 'package:foodshop/pages/signup.dart';
import 'package:foodshop/splashscreen.dart'; // Ensure this path is correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishablekey; // Use the constant from app_constant.dart
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCbrjSmjbZTBc_TUHoGKGLUKHPmPBSaJUI",
      projectId: "food-deliveryapp-7988c",
      messagingSenderId: "226617620701",
      appId: "1:226617620701:web:ffd827308a8be101664334",
      storageBucket: "food-deliveryapp-7988c.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     
      
      home: 
  Bottomnav(),// Update this if you want to use MyHomePage
    );
  }
}
 