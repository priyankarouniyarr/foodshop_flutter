import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodshop/service/shared_pref.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    return await auth.currentUser;
  }

  Future SignOut() async {
    await FirebaseAuth.instance.signOut();
   // await SharedPreferenceHelper().clearAll();
  }

  Future<void> deleteUser() async {
    try {
      User? user = await auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}
