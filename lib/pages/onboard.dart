import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodshop/Widget/content%20model.dart';
import 'package:foodshop/Widget/widget_support.dart';
import 'package:foodshop/pages/signup.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentindex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentindex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ensure the image fits within the available width
                      Image.asset(
                        contents[i].image,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                      ),
                      SizedBox(height: 40),
                      // Wrap the text in a Center widget to ensure proper alignment
                      Center(
                        child: Column(
                          children: [
                            Text(
                              contents[i].title,
                              textAlign: TextAlign.center,
                              style: AppWidget.HeadlineTextFieldWidget(),
                            ),
                            SizedBox(height: 20),
                            Text(
                              contents[i].description,
                              textAlign: TextAlign.center,
                              style: AppWidget.SemiBoldTextFieldWidget(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Dots indicator
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(contents.length, (index) => buildDot(index)),
            ),
          ),
          // Action button
          GestureDetector(
            onTap: () {
              if (currentindex == contents.length - 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Signup()),
                );
              } else {
                _controller.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 60,
              margin: EdgeInsets.all(20.0),
              width: double.infinity,
              child: Center(
                child: Text(
                  currentindex == contents.length - 1 ? "Next" : "Get Started",
                  style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return Container(
      height: 10.0,
      width: currentindex == index ? 18 : 7,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: currentindex == index ? Colors.black : Colors.black38,
      ),
    );
  }
}
