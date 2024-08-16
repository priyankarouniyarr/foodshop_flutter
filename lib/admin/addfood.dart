import 'dart:io'; // Import this for File
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodshop/service/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:foodshop/Widget/widget_support.dart';
import 'package:random_string/random_string.dart';

class Addfood extends StatefulWidget {
  const Addfood({super.key});

  @override
  State<Addfood> createState() => _AddfoodState();
}

class _AddfoodState extends State<Addfood> {
  final List<String> items = ['Ice-cream', 'Burger', 'Salad', 'Pizza','Momo' ,'Drinks','Itali','Noodles','Sweets'];
  String? value;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailscontroller = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future<void> getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }
uploadItem() async {
  if (selectedImage == null ||
      namecontroller.text.isEmpty ||
      pricecontroller.text.isEmpty ||
      detailscontroller.text.isEmpty ||
      value == null || value!.isEmpty) {
    // Show a message if any field is empty
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "All fields are required!",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
    return; // Stop the function here
  }

  String addId = randomAlphaNumeric(10); // Add data to Firebase Storage

  Reference firebaseStorageRef =
      FirebaseStorage.instance.ref().child("blogImages").child(addId);

  // Start the upload task
  final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
  // Get the download URL
  var downloadUrl = await (await task).ref.getDownloadURL();

  Map<String, dynamic> addItem = {
    "name": namecontroller.text,
    "Image": downloadUrl,
    "price": pricecontroller.text,
    "Details": detailscontroller.text,
    "category": value ?? '',
  };

  // Add item to the database
  await DatabaseMethods().addFoodItem(addItem, value!).then((value) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          "Food Item has been added successfully",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  });
}

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Item', style: AppWidget.HeadlineTextFieldWidget()),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child:
              Icon(Icons.arrow_back_ios_new_outlined, color: Color(0xFF373866)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 50.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Upload the Item Picture',
                style: AppWidget.SemiBoldTextFieldWidget()),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: selectedImage == null
                  ? Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.5, color: Colors.black),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Icon(Icons.camera_alt_outlined,
                              color: Colors.black),
                        ),
                      ),
                    )
                  : Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.5, color: Colors.black),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child:
                                Image.file(selectedImage!, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 30.0),
            Text('Item Name', style: AppWidget.SemiBoldTextFieldWidget()),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFFececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: namecontroller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Item Name",
                  hintStyle: AppWidget.LightTextFieldWidget(),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Text('Item Price', style: AppWidget.SemiBoldTextFieldWidget()),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFFececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: pricecontroller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Item Price",
                  hintStyle: AppWidget.LightTextFieldWidget(),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Text('Item Details', style: AppWidget.SemiBoldTextFieldWidget()),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFFececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                maxLines: 5,
                controller: detailscontroller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Item Details",
                  hintStyle: AppWidget.LightTextFieldWidget(),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text('Select Category', style: AppWidget.SemiBoldTextFieldWidget()),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFFececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item,
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.black)),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    this.value = value;
                  }),
                  dropdownColor: Colors.white,
                  hint: Text("Select the category"),
                  iconSize: 36,
                  icon: Icon(Icons.arrow_drop_down),
                  value: value,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {
                uploadItem();
              },
              child: Center(
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
