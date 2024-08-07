import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodshop/Widget/widget_support.dart';
import 'package:foodshop/pages/details.dart';
import 'package:foodshop/service/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  bool icecream = false;
  bool pizza = false;
  bool burger = false;
  bool salad = false;

Stream? fooditemStream  ;
ontheload() async{
  fooditemStream=await DatabaseMethods().getFoodItem("Pizza");
  setState(() {
    
  });
}
@override
void initState() {
  ontheload();
  super.initState();
}
// Widget allItems() {
//   return StreamBuilder( stream :fooditemStream ,builder: (context,AsyncSnapshot snapshot){
// return snapshot.hasData? ListView.builder(
//   padding: EdgeInsets.zero,
//   itemCount: snapshot.data.docs.length,
//   shrinkWrap:true ,
//   scollDirection: Axis.horizontal,
//   itemBuilder: (context,index){


// },




  
// CircularProgressIndicator;
//   },); 
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello Priyanka",
                      style: AppWidget.boldTextFieldWidget()),
                  Container(
                    margin: EdgeInsets.only(right: 20.0),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.shopping_cart, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text("Delicious Food",
                  style: AppWidget.HeadlineTextFieldWidget()),
              Text("Discover and Get Great Food",
                  style: AppWidget.LightTextFieldWidget()),
              SizedBox(height: 20),
              Container(
                  margin: EdgeInsets.only(right: 20.0), child: showItem()),
              SizedBox(height: 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                       Container(
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
                                  child: Image.asset("images/chicken pizza.jpeg",
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text("Chicken Pizza",
                                    style:
                                        AppWidget.SemiBoldTextFieldWidget()),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text("Fresh and Healthy",
                                    style: AppWidget.LightTextFieldWidget()),
                                SizedBox(height: 5.0),
                                Text("\$"+"15",
                                    style: AppWidget.boldTextFieldWidget()),
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      width:15.0
                    ),
                    Container(
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
                                  child: Image.asset("images/cheese.jpeg",
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text("Cheese Pizza",
                                    style:
                                        AppWidget.SemiBoldTextFieldWidget()),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text("Fresh and Healthy",
                                    style: AppWidget.LightTextFieldWidget()),
                                SizedBox(height: 5.0),
                                Text("\$"+"10",
                                    style: AppWidget.boldTextFieldWidget()),
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    GestureDetector(
                         onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Details()),
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
                                    borderRadius:BorderRadius.circular(10),
                                    child: Image.asset("images/pizza veg.jpeg",
                                        height: 150, width: 150, fit: BoxFit.cover),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text("Veg Pizza",
                                      style: AppWidget.SemiBoldTextFieldWidget()),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text("Spicy with vegetables",
                                      style: AppWidget.LightTextFieldWidget()),
                                  SizedBox(height: 5.0),
                                  Text("\$"+"20",
                                      style: AppWidget.boldTextFieldWidget()),
                                ],
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
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
                            child: Image.asset(
                              "images/burger2.jpg",
                              height: 120,
                              width: 120,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(width: 20.0),
                          Column(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "Burger",
                                    style: AppWidget.SemiBoldTextFieldWidget(),
                                  )),
                              SizedBox(height: 5.0),
                              Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "Vege Burger",
                                    style: AppWidget.LightTextFieldWidget(),
                                  )),
                              SizedBox(height: 5.0),
                              Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "\$"+"20",
                                    style: AppWidget.LightTextFieldWidget(),
                                  )),
                                  
             
                            ],
                          )
                        ],
                      )
                      ),
                ),
              ),
              SizedBox(
                height:20.0
              ),
               Container(
                margin: EdgeInsets.only(right: 20),
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
                            child: Image.asset(
                              "images/ice4.jpg",
                              height: 120,
                              width: 120,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(width: 20.0),
                          Column(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "Choclate Icecream",
                                    style: AppWidget.SemiBoldTextFieldWidget(),
                                  )),
                              SizedBox(height: 5.0),
                              Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "Fresh Cream",
                                    style: AppWidget.LightTextFieldWidget(),
                                  )),
                              SizedBox(height: 5.0),
                              Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "\$"+"25",
                                    style: AppWidget.LightTextFieldWidget(),
                                  )),

            ],
          ),
             ] ),

      ),),
    ),]),),),);

  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              icecream = true;
              pizza = false;
              burger = false;
              salad = false;
            });
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
        InkWell(
          onTap: () {
            setState(() {
              icecream = false;
              pizza = true;
              burger = false;
              salad = false;
            });
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
        InkWell(
          onTap: () {
            setState(() {
              icecream = false;
              pizza = false;
              burger = false;
              salad = true;
            });
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
        InkWell(
          onTap: () {
            setState(() {
              icecream = false;
              pizza = false;
              burger = true;
              salad = false;
            });
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
      ],
    );
  }
}
