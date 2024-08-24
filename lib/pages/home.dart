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
  bool sweets= false;
  bool drinks =false;
  bool noodles = false;
  bool itali =false;
  bool more = false;
  String? name;
  Stream? fooditemStream;
  

  ontheload() async {
    fooditemStream = await DatabaseMethods().getFoodItem("Ice-cream");
    setState(() {});
  }
   
  @override
  void initState() {
    ontheload();
    getthesharedpre();
    super.initState();
  }

   getthesharedpre() async {
  
    name = await SharedPreferenceHelper().getUserName();
   // print (name);
    
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
                    
                  margin: EdgeInsets.all(4),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                   
                        padding: EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Center(
                                child: CachedNetworkImage(
                                  imageUrl:ds['Image'],
                                    height: 180, width: 200, fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(ds['name'],
                                style: AppWidget.SemiBoldTextFieldWidget().copyWith(fontSize: 14)),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(" Fresh and Healthy",
                                style: AppWidget.LightTextFieldWidget()),
                            SizedBox(height: 5.0),
                            Text("Rs\t" + ds['price'] ,
                                style: AppWidget.boldTextFieldWidget().copyWith(fontSize: 18.0)),
                          ],
                        )),
                  ),
                ),
              );
            },
          );
        } else {
          return CircularProgressIndicator();
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
                    margin: EdgeInsets.only(right: 20, bottom: 30.0),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                              imageUrl:  ds['Image'],
                                height: 120,
                                width: 120,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align content to the start
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    ds['name'],
                                    style: AppWidget.SemiBoldTextFieldWidget(),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "Fresh and Healthy",
                                    style: AppWidget.LightTextFieldWidget(),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "Rs\t" + ds['price'],
                                    style: AppWidget.LightTextFieldWidget(),
                                  ),
                                ),
                              ],
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
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hi, $name", style: AppWidget.boldTextFieldWidget().copyWith(color:Colors.grey,fontSize: 30)),
                InkWell(
                  onTap: () {
                      Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Ordering()),
                              );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20.0),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.shopping_cart, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Deliciousness in Every Easy Bite", style: AppWidget.HeadlineTextFieldWidget().copyWith(fontSize:20,color: const Color.fromARGB(255, 65, 117, 67))),
            Text("Simple, Satisfying, and Always Delicious!",
                style: AppWidget.LightTextFieldWidget()),
            SizedBox(height: 20),
            Container(margin: EdgeInsets.only(right: 20.0), height:100,
      
            child: showItem()),
            
            Container(height: 330, 
            child: allItems()),
            SizedBox(
              height: 50.0,
            ),
            allItemsVertically(),
          ]),
        ),
      ),
    );
  }

  //categories
  Widget showItem() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () async {
             icecream =true;
              pizza = false;
              burger = false;
              salad = false;
              momo = false;
              itali= false;
              drinks= false;
              sweets= false;
              noodles=false;
              more =false;
              fooditemStream = await DatabaseMethods().getFoodItem("Ice-cream");
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: icecream ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  "images/ice-cream.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  color: icecream ? Colors.black : Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,

          ),

          InkWell(
            onTap: () async {
               icecream =false;
              pizza = true;
              burger = false;
              salad = false;
              momo = false;
              itali= false;
              drinks= false;
              sweets= false;
              noodles=false;
              more =false;
              fooditemStream = await DatabaseMethods().getFoodItem("Pizza");
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: pizza ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  "images/pizza.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  color: pizza ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
            SizedBox(
            width: 5,

          ),

          InkWell(
            onTap: () async {
              icecream =false;
              pizza = false;
              burger = false;
              salad = true;
              momo = false;
              itali= false;
              drinks= false;
              sweets= false;
              noodles=false;
              more =false;
              fooditemStream = await DatabaseMethods().getFoodItem("Salad");
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: salad ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  "images/salad.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  color: salad ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
            SizedBox(
            width: 5,

          ),

          InkWell(
            onTap: () async {
            icecream =false;
              pizza = false;
              burger = true;
              salad = false;
              momo = false;
              itali= false;
              drinks= false;
              sweets= false;
              noodles=false;
              more =false;
              fooditemStream = await DatabaseMethods().getFoodItem("Burger");
      
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: burger ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  "images/burger.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  color: burger ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
            SizedBox(
            width: 5,

          ),

          InkWell(
            onTap: () async {
              icecream =false;
              pizza = false;
              burger = false;
              salad = false;
              momo = true;
              itali= false;
              drinks= false;
              sweets= false;
              noodles=false;
              more =false;
              fooditemStream = await DatabaseMethods().getFoodItem("Momo");
      
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: momo ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  "images/momo.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  color: momo ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
            SizedBox(
            width: 5,

          ),

              InkWell(
            onTap: () async {
               icecream =false;
              pizza = false;
              burger = false;
              salad = false;
              momo = false;
              itali= false;
              drinks= false;
              sweets= true;
              noodles=false;
              more =false;
              fooditemStream = await DatabaseMethods().getFoodItem("Sweets");
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: sweets ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  "images/sweets.png",
                  height: 40,
                  width: 50,
                  fit: BoxFit.contain,
                  color: sweets ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
            SizedBox(
            width: 5,

          ),

              InkWell(
            onTap: () async {
               icecream =false;
              pizza = false;
              burger = false;
              salad = false;
              momo = false;
              itali= false;
              drinks= true;
              sweets= false;
              noodles=false;
              more =false;
              fooditemStream = await DatabaseMethods().getFoodItem("Drinks");
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: drinks ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  "images/drinks.png",
                  height: 40,
                  width: 50,
                  fit: BoxFit.cover,
                 color: drinks ? Colors.black : Colors.black,
                ),
              ),
            ),
          ), 
            SizedBox(
            width: 5,

          ),
   InkWell(
            onTap: () async {
              icecream =false;
              pizza = false;
              burger = false;
              salad = false;
              momo = false;
              itali= false;
              drinks= false;
              sweets= false;
              noodles=true;
              more =false;
              fooditemStream = await DatabaseMethods().getFoodItem("Noodles");
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: noodles? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  "images/noodles.png",
                  height: 40,
                  width: 50,
                  fit: BoxFit.cover,
                 // color: noodles ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
            SizedBox(
            width: 5,

          ),
    InkWell(
            onTap: () async {
              icecream =false;
              pizza = false;
              burger = false;
              salad = false;
              momo = false;
              itali= true;
              drinks= false;
              sweets= false;
              noodles=false;
              more =false;

              fooditemStream = await DatabaseMethods().getFoodItem("Itali");
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: itali ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  "images/itali.png",
                  height: 40,
                  width: 60,
                  fit: BoxFit.cover,
                 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
