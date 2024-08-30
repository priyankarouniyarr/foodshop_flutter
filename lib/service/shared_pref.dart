import 'package:shared_preferences/shared_preferences.dart';//user details to save locally

class SharedPreferenceHelper {
  
  static const String userIdKey = "USERKEY";
  static const String userNameKey = "USERNAMEKEY";
  static const String userWalletKey = "USERWALLETKEY";//saving data
  static const String userEmailKey = "USEREMAILKEY";
   static const String userProfileKey = "USEREPROFILEKEY";
   
   static const String userFoodCart ="USERFOODCART";
  

  Future<bool> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, userId);
  }

    Future<bool> saveUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, userName);
  }
  Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, userEmail);

  }

 Future<bool> saveCartItems(String Cart) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userFoodCart, Cart);
  }
  Future<bool> saveUserWallet(String userWallet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userWalletKey, userWallet);

  }
  Future<bool> saveUserProfile(String userProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();//saving
    return prefs.setString(userProfileKey, userProfile);
  }

  Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    

  }
  Future <String?> getCartItems() async{
    
     SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userFoodCart);
  }
  Future<String?> getUserId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }
   Future<String?> getUserProfile() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfileKey);
  }


   Future<String?> getUserEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }
  
 Future<String?> getUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }
 Future<String?> getUserWallet() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userWalletKey);
  }


}
