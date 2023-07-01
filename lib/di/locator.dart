import 'package:batua/ui_helper/homePageUiHelper.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDi() {
  getIt.registerLazySingleton<HomePageUiHelper>(() => HomePageUiHelper());

// Alternatively you could write it if you don't like global variables
}
