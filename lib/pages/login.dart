import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:foodshop/Widget/widget_support.dart';
import 'package:foodshop/pages/signup.dart';

class LoginIn extends StatefulWidget {
  const LoginIn({super.key});

  @override
  State<LoginIn> createState() => _LoginInState();
}

class _LoginInState extends State<LoginIn> {
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
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height ,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                )),
            child: Text(""),
          ),
          Container(
            margin: EdgeInsets.only(top:90.0, left: 20.0, right: 20.0),
            child: Column(
              children: [
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
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 30.0),
                          Text(
                            "LogIn",
                            style: AppWidget.HeadlineTextFieldWidget(),
                          ),
                          SizedBox(height: 30.0),
                          TextField(
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: AppWidget.SemiBoldTextFieldWidget(),
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: AppWidget.SemiBoldTextFieldWidget(),
                              prefixIcon: Icon(Icons.password_outlined),
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Container(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Forget Password",
                                style: AppWidget.SemiBoldTextFieldWidget(),
                              )),
                              SizedBox(height: 40.0),
                              Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical:8.0),
                                  width:200,
                                  decoration:BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color.fromARGB(255, 48, 255, 186),
                                  ),
                                  child:Center(child: Text("LOGIN",style:TextStyle(color:Colors.white,fontFamily: "Poppins",fontSize: 18.0,fontWeight: FontWeight.bold))),),
                           
                              )   , SizedBox(height: 20.0),
                             
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 70.0,
              ),
               GestureDetector
               (
                onTap: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()));
                },
          
                child: Text("Don't have an account ? Sign Up",style:AppWidget.SemiBoldTextFieldWidget())),]
            ),
          )
                ],
              )),
        ));
  }
}
