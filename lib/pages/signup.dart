import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodshop/Widget/widget_support.dart';
import 'package:foodshop/pages/bottomnav.dart';
import 'package:foodshop/pages/login.dart';
import 'package:foodshop/service/database.dart';
import 'package:foodshop/service/shared_pref.dart';
import 'package:random_string/random_string.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email = "", password = "", username = "";
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController mailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  final _formKey = GlobalKey<FormState>(); //to check field is filled or not

  registration() async {
    if (password != null) {
// SnackBar in Flutter is a lightweight message bar that briefly shows information at the bottom of the screen.
      //The function checks if the password variable is not null before proceeding with registration.
      try {
        // registration() method to handle user registration using Firebase Authentication.
        // Try to create a user with email and password
        //     This line tries to create a new user with the provided email and password using Firebase Authentication. If successful, a UserCredential object is returned.
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            backgroundColor: Colors.green,
            content: Text(" Registered Successfully",
                style: TextStyle(fontSize: 20.0)))));
        String Id = userCredential.user!.uid;

        Map<String, dynamic> addUserInfo = {
          "Username": usernamecontroller.text, //wallet updates
          "Email": mailcontroller.text,
          "Wallet": "0",
          "Id": Id
        };
        await DatabaseMethods().addUserDetail(addUserInfo, Id);
        await SharedPreferenceHelper().saveUserName(usernamecontroller.text);
        await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
        await SharedPreferenceHelper().saveUserId(Id);
        await SharedPreferenceHelper().saveUserWallet('0');

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginIn()));
      } on FirebaseException catch (e) {
        //error handling
        if (e.code == "weak-password") {
          ScaffoldMessenger.of(context).showSnackBar((SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password is too weak",
                style: TextStyle(fontSize: 18),
              ))));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar((SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account already exists",
                style: TextStyle(fontSize: 18),
              ))));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          child: Stack(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color.fromARGB(255, 96, 255, 48),
                    Color.fromARGB(255, 26, 190, 231),
                  ]))),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                )),
            child: Text(""),
          ),
          Container(
            margin: EdgeInsets.only(top: 90.0, left: 20.0, right: 20.0),
            child: Column(children: [
              Center(
                child: Image.asset('images/logo1.png',
                    width: MediaQuery.of(context).size.width / 1.5,
                    fit: BoxFit.cover),
              ),
              SizedBox(height: 50.0),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.8,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 30.0),
                          Text(
                            "Sign Up",
                            style: AppWidget.HeadlineTextFieldWidget(),
                          ),
                          SizedBox(height: 30.0),
                          TextFormField(
                            controller: usernamecontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "UserName",
                              hintStyle: AppWidget.SemiBoldTextFieldWidget(),
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: mailcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: AppWidget.SemiBoldTextFieldWidget(),
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: passwordcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: AppWidget.SemiBoldTextFieldWidget(),
                              prefixIcon: Icon(Icons.password_outlined),
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  email = mailcontroller.text;
                                  password = passwordcontroller.text;
                                  username = usernamecontroller.text;
                                });
                              }
                              registration(); //function call
                            },
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromARGB(255, 48, 255, 186),
                                ),
                                child: Center(
                                    child: Text("SIGN UP",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Poppins",
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold))),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 70.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginIn()));
                },
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account ? ",
                    style: AppWidget
                        .SemiBoldTextFieldWidget(), // Style for the regular text
                    children: [
                      TextSpan(
                        text: "Log In",
                        style: AppWidget.SemiBoldTextFieldWidget().copyWith(
                          color:
                              Color(0xFF87CEEB), // Sky blue color for "Sign Up"
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          )
        ],
      )),
    ));
  }
}
