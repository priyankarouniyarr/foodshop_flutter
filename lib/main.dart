import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodshop/Widget/app_constant%20.dart';
import 'package:foodshop/admin/adminhome.dart';
import 'package:foodshop/pages/bottomnav.dart';
import 'package:foodshop/service/servicelocator.dart'; 

import 'package:foodshop/splashscreen.dart'; 
final auth  = FirebaseAuth.instance;
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
   setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     
      
      home: 
  Builder(
    builder: (context) {
      print(auth.currentUser);
      if(auth.currentUser != null){

        if(auth.currentUser!.email == "priyankarouniyar34@gmail.com"){
          return HomeAdmin();
        }
        return Bottomnav();
      }
      
      return SplashScreen();
    }
  ),
    );
  }
}
 