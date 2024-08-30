


import 'package:foodshop/service/database.dart';
import 'package:foodshop/service/shared_pref.dart';
import 'package:get_it/get_it.dart';
final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  
  getIt.registerLazySingleton<SharedPreferenceHelper>(() => SharedPreferenceHelper());
  getIt.registerLazySingleton<DatabaseMethods>(() => DatabaseMethods());
}
