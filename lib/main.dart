import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodshop/Widget/app_constant%20.dart';


import 'package:foodshop/admin/admin_login.dart';
import 'package:foodshop/pages/bottomnav.dart';
import 'package:foodshop/pages/login.dart';
import 'package:foodshop/pages/onboard.dart';
import 'package:foodshop/pages/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishablekey; // Use the constant from app_constant.dart
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCbrjSmjbZTBc_TUHoGKGLUKHPmPBSaJUI",
      projectId: "food-deliveryapp-7988c",
      messagingSenderId: "226617620701",
      appId: "1:226617620701:web:ffd827308a8be101664334",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a ValueNotifier to track the login state
    final ValueNotifier<bool> isAdmin = ValueNotifier<bool>(false); // Default to false (simple user)

    // Placeholder for actual authentication logic
    // Here you should check if the user is an admin or a simple user from your authentication system
    Future<void> checkUserRole() async {
      // Simulate checking user role (replace with actual logic)
      await Future.delayed(const Duration(seconds: 10)); // Simulate network delay
      isAdmin.value = true; // Set this based on your actual check
    }

    // Run the role check
    checkUserRole();

    return ValueListenableBuilder<bool>(
      valueListenable: isAdmin,
      builder: (context, isAdminLoggedIn, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Food Shop App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: isAdminLoggedIn ? AdminLogin() : Onboard(), // Choose based on login status
        );
      },
    );
  }
}
