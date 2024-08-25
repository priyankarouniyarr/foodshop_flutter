import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(id) async {
    return await FirebaseFirestore.instance.collection('users').doc(id).get();
  }

  Future<void> Updateuserwallet(String id, String amount) async {
    try {
      await _firestore.collection('users').doc(id).update({
        'wallet': amount,
      });
    } catch (e) {
      print('Error updating wallet: $e');
    }
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

  Future updateProduct(Map<String, dynamic> data, productId, userId) async {
    print(productId);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Cart")
        .doc(productId)
        .update(data);
  }

  Future<Stream<QuerySnapshot>> getFoodCart(String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Cart")
        .snapshots();
  }

  Future<QueryDocumentSnapshot<Object?>?> checkItem(productName, userId) async {
    final resp = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Cart")
        .get();

    final docs = resp.docs;
    QueryDocumentSnapshot<Object?>? result;
    for (QueryDocumentSnapshot doc in docs) {
      if (doc['name'] == productName) {
        result = doc;
      }
    }
    return result;
  }

  Future<void> removeFoodFromCart(String userId, String foodId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Cart') // Updated here
          .doc(foodId)
          .delete();
    } catch (e) {
      print('Error removing food from cart: $e');
    }
  }

  Future<void> clearCart(String userId) async {
    print(userId);
    print("Done");
    final cartCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Cart');
    final cartItems = await cartCollection.get();

    for (var doc in cartItems.docs) {
      doc.reference.delete();
    }
  }
}
