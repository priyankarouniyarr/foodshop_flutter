import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  Updateuserwallet(String id, String amount) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'Wallet': amount});
  }

  //food adding items
  Future addFoodItem(Map<String, dynamic> userInfoMap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getFoodItem(
      String
          name) // details that store in firebase//helps to get all the data from firestore database
  async {
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future addFoodtoCart(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Cart')
        .add(userInfoMap);
  }
   Future<Stream<QuerySnapshot>> getFoodCart(
      String
          id) // details that store in firebase//helps to get all the data from firestore database
  async {
    return await FirebaseFirestore.instance.collection("users").doc(id).collection("Cart").snapshots();
  }

}
