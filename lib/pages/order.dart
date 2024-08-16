import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodshop/Widget/widget_support.dart';
import 'package:foodshop/pages/bottomnav.dart';
import 'package:foodshop/service/database.dart';
import 'package:foodshop/service/shared_pref.dart';

class Ordering extends StatefulWidget {
  @override
  State<Ordering> createState() => _OrderingState();
}

class _OrderingState extends State<Ordering> {
  String? id;
  String? wallet;
  int total = 0, amount2 = 0;

  void startTimer() {
    amount2 = total;
    Timer(Duration(seconds: 1), () {
      // For reloading cart button
      setState(() {});
    });
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    wallet = await SharedPreferenceHelper().getUserWallet();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    foodStream = await DatabaseMethods().getFoodCart(id!);
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    startTimer();
    super.initState();
  }

  Stream? foodStream;

  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              total = total + int.parse(ds["total"]);
              return Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                child: Material(
                  elevation: 5.0,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                              },
                              child: Icon(Icons.close,size:15,color:Colors.black))]),
                            SizedBox(
                              height: 10.0,
                            ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                ds["Image"],
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120,
                                  child: Text(ds["name"],
                                      style: AppWidget.SemiBoldTextFieldWidget()),
                                ),
                                Text("Rs\t" + ds["total"],
                                    style: AppWidget.SemiBoldTextFieldWidget()
                                        .copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(width: 10.0),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              height: 70,
                              width: 50,
                              child: Center(child: Text(ds["quantity"])),
                            ),
                          ],
                        ),
                      ],
                    ),
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

  void deductWalletAmount() async {
    int availableAmount = int.parse(wallet!);
    if (availableAmount >= amount2) {
      int updatedAmount = availableAmount - amount2;

      // Update the wallet balance in the database
      await DatabaseMethods().Updateuserwallet(id!, updatedAmount.toString());

      // Update the wallet balance in shared preferences
      await SharedPreferenceHelper().saveUserWallet(updatedAmount.toString());

      setState(() {
        wallet = updatedAmount.toString();
      });

      // Display a success message or navigate to another page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment successful! Remaining balance: Rs $wallet')),
      );
    } else {
      // Display an error message if the wallet balance is insufficient
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Insufficient balance in wallet!')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Material(
                elevation: 2.0,
                child: Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Center(
                    child: Text("Food Cart",
                        style: AppWidget.HeadlineTextFieldWidget()),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              foodCart(),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Price", style: AppWidget.boldTextFieldWidget()),
                    Text("Rs\t" + total.toString(),
                        style: AppWidget.SemiBoldTextFieldWidget()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Available Wallet Balance",
                        style: AppWidget.boldTextFieldWidget().copyWith(fontSize: 18)),
                    Text("Rs\t" + (wallet ?? "0"),
                        style: AppWidget.SemiBoldTextFieldWidget()),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  deductWalletAmount();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> Bottomnav()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Center(
                    child: Text(
                      "CheckOut",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}