import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodshop/Widget/app_constant%20.dart';
import 'package:foodshop/service/database.dart';
import 'package:foodshop/service/shared_pref.dart';
import 'package:http/http.dart' as http;

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String? wallet, id;
  TextEditingController amountcontroller = new TextEditingController();

  String? amount; // Store selected amount for payment

  int? add;

  onTheLoad() async {
    await getTheSharedPref();
  }

  getTheSharedPref() async {
    wallet = await SharedPreferenceHelper().getUserWallet();
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  Map<String, dynamic>? paymentIntent;
  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'NPR');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: '',
        ),
      );
      await displayPaymentSheet();
    } catch (e, s) {
      print('Exception: $e $s');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        add = int.parse(wallet!) + int.parse(amount!);
        await SharedPreferenceHelper()
            .saveUserWallet(add.toString()); //updated wallet
        await DatabaseMethods().Updateuserwallet(id!, add.toString());

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text("Sucessfully Loaded Money"),
                  ],
                ),
              ],
            ),
          ),
        );

        await getTheSharedPref();

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error: $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Stripe Error: $e');
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(content: Text("Cancelled")),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[0]': "card",
      };
      var response = await http.post(
        Uri.parse(
            'https://api.stripe.com/v1/payment_intents'), // Update the URL
        headers: {
          'Authorization':
              'Bearer $scretekey', // Update with your actual secret key
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      print('Payment Intent Response: ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('Error creating payment intent: ${err.toString()}');
      rethrow;
    }
  }

  String calculateAmount(String amount) {
    //to prevent from decimal
    final calculatedAmount = int.parse(amount) * 100;
    return calculatedAmount.toString();
  }

  Future openEdit() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
                child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel),
                      ),
                      SizedBox(width: 60),
                      Center(
                          child: Text("Add money",
                              style: TextStyle(
                                color: Color(0xFF008080),
                                fontWeight: FontWeight.bold,
                              )))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Amount'),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: amountcontroller,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Enter amount"),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      makePayment(amountcontroller.text);
                    },
                    child: Container(
                        width: 100,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 92, 173, 103),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text("Pay",
                                style: TextStyle(color: Colors.white)))),
                  )
                ],
              ),
            )),
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: wallet == null
          ? CircularProgressIndicator()
          : Container(
              margin: EdgeInsets.only(top: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 2.0,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Center(
                        child: Text(
                          "Wallet",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/wallet.png",
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 40.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Wallet",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "Rs\t" + wallet!,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Add Money",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _amountButton("Rs 100", onPressed: () {
                        amount = '100';
                        makePayment('100');
                      }),
                      
                      _amountButton("Rs 500",
                          onPressed: () =>
                              {amount = '500', makePayment('500')}),
                            
                      _amountButton("Rs 1000",
                          onPressed: () =>
                              {amount = '1000', makePayment('1000')}),
                        
                      _amountButton("Rs 5000",
                          isHighlighted: true,
                          onPressed: () =>
                              {amount = '5000', makePayment('5000')}),
                    ],
                  ),
                  SizedBox(height: 40.0),
                  GestureDetector(
                    onTap: () {
                      openEdit();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 101, 173, 111),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Add money',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _amountButton(String amount,
      {bool isHighlighted = false, required VoidCallback onPressed}) {
    return Container(
      
                child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isHighlighted ? Colors.grey[200] : Color(0xFFE9E2E2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(
          amount,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
    );
  }
}
