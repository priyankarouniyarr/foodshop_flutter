import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodshop/Widget/widget_support.dart';
import 'package:foodshop/pages/bottomnav.dart';
import 'package:foodshop/pages/sucesspage.dart';
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
      setState(() {});
    });
  }

  void removeItemFromCart(String foodId) async {
    if (id != null) {
      await DatabaseMethods().removeFoodFromCart(id!, foodId);
      setState(() {});
    }
  }

  Future<void> getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    wallet = await SharedPreferenceHelper().getUserWallet();
    setState(() {});
  }

  Future<void> ontheload() async {
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
          total = 0; // Reset total before calculating
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              total += int.parse(ds["total"]);
              String foodId = ds.id; // Get document ID
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                removeItemFromCart(foodId); // Call the method to remove the item
                              },
                              child: Icon(Icons.close, size: 20, color: Colors.red),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: ds["Image"],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Icon(Icons.error, size: 100),
                              ),
                            ),
                            SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ds["name"], style: AppWidget.SemiBoldTextFieldWidget().copyWith(fontSize: 16, color: Colors.black)),
                                  SizedBox(height: 5.0),
                                  Text("Rs\t" + ds["total"], style: AppWidget.SemiBoldTextFieldWidget().copyWith(fontWeight: FontWeight.bold, color: Colors.green)),
                                  SizedBox(height: 5.0),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(ds["quantity"], style: TextStyle(fontSize: 16)),
                                    ),
                                  ),
                                ],
                              ),
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
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<bool> deductWalletAmount() async {
    int availableAmount = int.parse(wallet!);

    if (total > 0) {
      if (availableAmount >= total) {
        int updatedAmount = availableAmount - total;
        await DatabaseMethods().Updateuserwallet(id!, updatedAmount.toString());
        await SharedPreferenceHelper().saveUserWallet(updatedAmount.toString());
        await DatabaseMethods().clearCart(id!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Payment successful! Remaining balance: Rs $updatedAmount', style: AppWidget.LightTextFieldWidget().copyWith(color: Colors.white)),
          ),
        );

        setState(() {
          wallet = updatedAmount.toString();
          total = 0;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => DonePage()));
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Insufficient balance in wallet!', style: AppWidget.LightTextFieldWidget().copyWith(color: Colors.white)),
          ),
        );
        return false; // Payment failed
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('No items in the cart!', style: AppWidget.LightTextFieldWidget().copyWith(color: Colors.white)),
        ),
      );
      return false; // No items to pay for
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Center(
                child: Text("Food Cart", style: AppWidget.boldTextFieldWidget().copyWith(fontSize: 24, color: Colors.green)),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(child: foodCart()),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Price", style: AppWidget.LightTextFieldWidget().copyWith(fontSize: 18.0, fontWeight: FontWeight.bold)),
                        Text("Rs\t" + total.toString(), style: AppWidget.LightTextFieldWidget().copyWith(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      deductWalletAmount();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "CheckOut",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
