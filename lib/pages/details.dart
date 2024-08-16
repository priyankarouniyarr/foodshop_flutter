import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:foodshop/Widget/widget_support.dart';
import 'package:foodshop/service/database.dart';
import 'package:foodshop/service/shared_pref.dart';

class Details extends StatefulWidget {
  String name, description, image;
  String price;
  Details(
      {required this.name,
      required this.description,
      required this.image,
      required this.price});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int a = 1;
  String? id;
  int total = 0;

  getthesharedpre() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  onload() async {
    await getthesharedpre();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    onload();
    total = int.parse(widget.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
              ),
              SizedBox(
                height: 20.0,
              ),
              
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.network(
                  widget.image,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.5,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Container(
                    
                    width:MediaQuery.of(context).size.width/2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name,
                            style: AppWidget.SemiBoldTextFieldWidget()),
                      ],
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (a > 1) {
                        --a;
                        total = total - int.parse(widget.price);
                        setState(() {});
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Text(a.toString(),
                      style: AppWidget.SemiBoldTextFieldWidget()),
                  SizedBox(width: 20.0),
                  GestureDetector(
                    onTap: () {
                      ++a;
                      total = total + int.parse(widget.price);
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                widget.description,
                style: AppWidget.LightTextFieldWidget(),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Text("Delivery Time", style: AppWidget.boldTextFieldWidget()),
                  SizedBox(width: 25.0),
                  Icon(Icons.alarm, color: Colors.black54),
                  SizedBox(width: 5.0),
                  Text("30 minutes",
                      style: AppWidget.SemiBoldTextFieldWidget()),
                ],
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Total", style: AppWidget.SemiBoldTextFieldWidget()),
                      Text("Rs\t" + total.toString(),
                          style: AppWidget.HeadlineTextFieldWidget()),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> addFoodtoCart = {
                        "name": widget.name,
                        "Image": widget.image,
                        "quantity": a.toString(),
                        "total": total.toString(),
                      };
                      await DatabaseMethods().addFoodtoCart(addFoodtoCart, id!);
                      ScaffoldMessenger.of(context).showSnackBar((SnackBar(
                          backgroundColor: Colors.orangeAccent,
                          content: Text(
                            "Food Added to Cart",
                            style: TextStyle(fontSize: 18),
                          ))));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Add to Cart ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'Poppins'),
                          ),
                          SizedBox(width: 30.0),
                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 19, 90, 21),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.shopping_cart_outlined,
                                color: Colors.white),
                          ),
                          SizedBox(width: 10.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.0), // Additional space to prevent overflow
            ],
          ),
        ),
      ),
    );
  }
}
