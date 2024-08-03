import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:foodshop/Widget/widget_support.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int a = 1;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
              ),
              Image.asset(
                "images/salad2.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mediterranean", style: AppWidget.SemiBoldTextFieldWidget()),
                      Text("Chickeap Salad", style: AppWidget.boldTextFieldWidget()),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (a > 1) {
                        setState(() {
                          --a;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Text(a.toString(), style: AppWidget.SemiBoldTextFieldWidget()),
                  SizedBox(width: 20.0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        ++a;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                "Sure, here's a paragraph about Chickpea Salad: Chickpea Salad is a delightful and nutritious dish that combines the hearty texture of chickpeas with the fresh flavors of various vegetables and herbs. This salad typically includes ingredients such as diced cucumbers, bell peppers, cherry tomatoes, and finely chopped red onions, all of which add a refreshing crunch. Fresh parsley and cilantro provide an aromatic depth, while a simple dressing of olive oil, lemon juice, and minced garlic brings everything together with a zesty touch. Optional crumbled feta cheese can add a creamy, tangy element to the mix. Chickpea Salad is not only easy to prepare but also packed with protein and fiber, making it a perfect choice for a healthy meal or a vibrant side dish.",
                style: AppWidget.LightTextFieldWidget(),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Text("Delivery Time", style: AppWidget.boldTextFieldWidget()),
                  SizedBox(width: 25.0),
                  Icon(Icons.alarm, color: Colors.black54),
                  SizedBox(width: 5.0),
                  Text("30 minutes", style: AppWidget.SemiBoldTextFieldWidget()),
                ],
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Total", style: AppWidget.SemiBoldTextFieldWidget()),
                      Text("Rs 150", style: AppWidget.HeadlineTextFieldWidget()),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Add to Cart ",
                          style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'Poppins'),
                        ),
                        SizedBox(width: 30.0),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.shopping_cart_outlined, color: Colors.white),
                        ),
                        SizedBox(width: 10.0),
                      ],
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
