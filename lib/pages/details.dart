import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          margin: const EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child:
                    const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              ),
              const SizedBox(
                height: 20.0,
              ),

              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: CachedNetworkImage(
               imageUrl:   widget.image,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.5,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name,
                            style: AppWidget.SemiBoldTextFieldWidget()),
                      ],
                    ),
                  ),
                  const Spacer(),
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
                      child: const Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Text(a.toString(),
                      style: AppWidget.SemiBoldTextFieldWidget()),
                  const SizedBox(width: 20.0),
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
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Text(
                widget.description,
                style:
                    AppWidget.LightTextFieldWidget().copyWith(wordSpacing: 20),
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Delivery Time", style: AppWidget.boldTextFieldWidget()),
                  const SizedBox(width: 25.0),
                  const Icon(Icons.alarm, color: Colors.black54),
                  const SizedBox(width: 5.0),
                  Text("30 minutes",
                      style: AppWidget.SemiBoldTextFieldWidget()),
                ],
              ),
              const SizedBox(height: 40.0),
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
                      QueryDocumentSnapshot<Object?>? exist =
                          await DatabaseMethods().checkItem(widget.name, id!);
                      if (exist != null) {
                        int updatedTotal = int.parse(exist['total']) + total;
                        int updatedQuantity = int.parse(exist['quantity']) + a;
                        await DatabaseMethods().updateProduct({
                          "quantity": updatedQuantity.toString(),
                          "total": updatedTotal.toString(),
                        }, exist.id, id!);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          (const SnackBar(
                            backgroundColor: Colors.orangeAccent,
                            content: Text(
                              "Food Added to Cart",
                              style: TextStyle(fontSize: 18),
                            ),
                          )),
                        );
                        return;
                      }
                      Map<String, dynamic> addFoodtoCart = {
                        "name": widget.name,
                        "Image": widget.image,
                        "quantity": a.toString(),
                        "total": total.toString(),
                      };
                      await DatabaseMethods().addFoodtoCart(addFoodtoCart, id!);
                      ScaffoldMessenger.of(context)
                          .showSnackBar((const SnackBar(
                              backgroundColor: Colors.orangeAccent,
                              content: Text(
                                "Food Added to Cart",
                                style: TextStyle(fontSize: 18),
                              ))));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Add to Cart ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'Poppins'),
                          ),
                          const SizedBox(width: 30.0),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 19, 90, 21),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.shopping_cart_outlined,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 10.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 40.0), // Additional space to prevent overflow
            ],
          ),
        ),
      ),
    );
  }
}
