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
      // For reloading cart button
      setState(() {});
    });
  }

  void removeItemFromCart(String foodId) async {
    if (id != null) {
      await DatabaseMethods().removeFoodFromCart(id!, foodId);

      // Refresh the stream to reflect the changes
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
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                removeItemFromCart(
                                    foodId); // Call the method to remove the item
                              },
                              child: Icon(Icons.close,
                                  size: 15, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: ds["Image"],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 15.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  child: Text(ds["name"],
                                      style: AppWidget.SemiBoldTextFieldWidget()
                                          .copyWith(fontSize: 15)),
                                ),
                                Text("Rs\t" + ds["total"],
                                    style: AppWidget.SemiBoldTextFieldWidget()
                                        .copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(width: 10.0),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(20)),
                                height: 50,
                                width: 50,
                                child: Center(child: Text(ds["quantity"])),
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
            backgroundColor: Colors.amber,
            content: Text(
                'Payment successful! Remaining balance: Rs $updatedAmount',
                style: AppWidget.LightTextFieldWidget()
                    .copyWith(color: Colors.white)),
          ),
        );

        setState(() {
          wallet = updatedAmount.toString();
          total = 0;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DonePage()));
        return true;
        // Payment successful
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.amber,
            content: Text('Insufficient balance in wallet!',
                style: AppWidget.LightTextFieldWidget()
                    .copyWith(color: Colors.white)),
          ),
        );
        return false; // Payment failed
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.amber,
          content: Text('No items in the cart!',
              style: AppWidget.LightTextFieldWidget()
                  .copyWith(color: Colors.white)),
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
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Center(
              child: Text("Food Cart", style: AppWidget.boldTextFieldWidget()),
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
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Price",
                          style: AppWidget.LightTextFieldWidget()
                              .copyWith(fontSize: 18.0)),
                      Text("Rs\t" + total.toString(),
                          style: AppWidget.LightTextFieldWidget()
                              .copyWith(fontSize: 18)),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    deductWalletAmount();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    margin:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
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
        ]),
      ),
    );
  }
}
