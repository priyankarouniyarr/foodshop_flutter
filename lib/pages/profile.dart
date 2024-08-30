import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:foodshop/pages/login.dart';
import 'package:foodshop/pages/onboard.dart';

import 'package:foodshop/service/auth.dart';
import 'package:foodshop/service/shared_pref.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profile, name, email, profilePic;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future<void> getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
      uploadItem();
    }
  }

  Future<void> uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10); // Generate unique ID
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("ProfileImages").child(addId);

      try {
        final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
        var downloadUrl = await (await task).ref.getDownloadURL();

        await SharedPreferenceHelper().saveUserProfile(downloadUrl);

        // Re-fetch user data
        await getthesharedpre();

        setState(() {}); // Refresh the UI
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> getthesharedpre() async {
    profile = await SharedPreferenceHelper().getUserProfile();
    print('Profile URL Retrieved: $profile');

    // Set default profile picture if profile URL is null
    if (profile == null || profile!.isEmpty) {
      profile = null; // This will show the default icon
    }

    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  Future<void> onthisload() async {
    await getthesharedpre();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    onthisload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: 45.0,
                          left: 20.0,
                          right: 20.0,
                        ),
                        height: MediaQuery.of(context).size.height / 4.2,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green, Colors.greenAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(
                              MediaQuery.of(context).size.width, 110),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 6.5,
                          ),
                          child: Material(
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(60.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60.0),
                              child: selectedImage == null
                                  ? GestureDetector(
                                      onTap: getImage,
                                      child: profile == null
                                          ? Icon(Icons.person,
                                              size: 100, color: Colors.grey)
                                          : CachedNetworkImage(
                                              imageUrl: profile!,
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => 
                                                CircularProgressIndicator(),
                                              errorWidget: (context, url, error) => 
                                                Icon(Icons.error, size: 120),
                                            ),
                                    )
                                  : Image.file(
                                      selectedImage!,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 70.0),
                        child: Center(
                          child: Text(
                            name!,
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  _buildProfileInfoCard(
                    icon: Icons.person,
                    label: 'Name',
                    value: name!,
                  ),
                  SizedBox(height: 20.0),
                  _buildProfileInfoCard(
                    icon: Icons.email,
                    label: 'Email',
                    value: email!,
                  ),
                  SizedBox(height: 20.0),
                  _buildProfileInfoCard(
                    icon: Icons.description,
                    label: 'Terms and Condition',
                    value: 'View Terms',
                    onTap: () {
                      // Handle view terms logic here
                    },
                  ),
                  SizedBox(height: 20.0),
                  _buildActionButton(
                    icon: Icons.delete,
                    label: 'Delete Account',
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 5.0,
                              color: Colors.lightGreen[400],
                            ),
                          );
                        },
                      );
                      try {
                        await AuthMethods().deleteUser();
                        await Future.delayed(Duration(seconds: 2));
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Onboard()),
                        );
                      } catch (e) {
                        Navigator.pop(context);
                        print('Error occurred: $e');
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
                  _buildActionButton(
                    icon: Icons.logout,
                    label: 'Log Out',
                    onTap: () async {
                      await SharedPreferenceHelper().clearAll();
                      await AuthMethods().SignOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginIn()),
                      );
                      print(email);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileInfoCard({required IconData icon, required String label, required String value, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Material(
          elevation: 2.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.black, size: 24.0),
                SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
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
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Material(
          elevation: 2.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.red, size: 24.0),
                SizedBox(width: 20.0),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
