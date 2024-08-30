import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodshop/Widget/widget_support.dart';
import 'package:foodshop/pages/details.dart';
import 'package:foodshop/pages/order.dart';
import 'package:foodshop/service/database.dart';
import 'package:foodshop/service/shared_pref.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  bool icecream = true;
  bool pizza = false;
  bool burger = false;
  bool salad = false;
  bool momo = false;
  bool sweets = false;
  bool drinks = false;
  bool noodles = false;
  bool itali = false;
  bool more = false;
  String? name;
  Stream? fooditemStream;

  @override
  void initState() {
    super.initState();
    ontheload();
    getthesharedpre();
  }

  ontheload() async {
    fooditemStream = await DatabaseMethods().getFoodItem("Ice-cream");
    setState(() {});
  }

  getthesharedpre() async {
    name = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  Widget allItems() {
    return StreamBuilder(
      stream: fooditemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Details(
                              name: ds['name'],
                              price: ds['price'],
                              image: ds['Image'],
                              description: ds['Details'],
                            )),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: ds['Image'],
                              height: 180,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            ds['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Fresh and Healthy",
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Rs ${ds['price']}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget allItemsVertically() {
    return StreamBuilder(
      stream: fooditemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Details(
                                name: ds['name'],
                                price: ds['price'],
                                image: ds['Image'],
                                description: ds['Details'],
                              )),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20, bottom: 20),
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: ds['Image'],
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ds['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Fresh and Healthy",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Rs ${ds['price']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hi, $name",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Ordering()),
                      );
                    },
                    color: Colors.green,
                    padding: EdgeInsets.all(8),
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Deliciousness in Every Easy Bite",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 65, 117, 67),
                ),
              ),
              Text(
                "Simple, Satisfying, and Always Delicious!",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 100,
                child: showItem(),
              ),
              SizedBox(height: 20),
              Container(
                height: 330,
                child: allItems(),
              ),
              SizedBox(height: 20),
              allItemsVertically(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showItem() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryButton("Ice-cream", "images/ice-cream.png", icecream),
          _buildCategoryButton("Pizza", "images/pizza.png", pizza),
          _buildCategoryButton("Salad", "images/salad.png", salad),
          _buildCategoryButton("Burger", "images/burger.png", burger),
          _buildCategoryButton("Momo", "images/momo.png", momo),
          _buildCategoryButton("Sweets", "images/sweets.png", sweets),
          _buildCategoryButton("Drinks", "images/drinks.png", drinks),
          _buildCategoryButton("Noodles", "images/noodles.png", noodles),
          _buildCategoryButton("Itali", "images/itali.png", itali),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category, String imagePath, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () async {
          setState(() {
            icecream = category == "Ice-cream";
            pizza = category == "Pizza";
            burger = category == "Burger";
            salad = category == "Salad";
            momo = category == "Momo";
            sweets = category == "Sweets";
            drinks = category == "Drinks";
            noodles = category == "Noodles";
            itali = category == "Itali";
            more = category == "More";
          });
          fooditemStream = await DatabaseMethods().getFoodItem(category);
          setState(() {});
        },
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
              Text(
                category,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
