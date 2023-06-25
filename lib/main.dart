import 'package:batua/pages/home_page.dart';
import 'package:batua/pages/onboarding_page.dart';
import 'package:batua/ui_helper/homePageUiHelper.dart';
import 'package:batua/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  bool loggedIn = await isLogged();
  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Batua",
      initialRoute: loggedIn ? HomePage.route : OnboardingPage.route,
      routes: {
        "/": (context) => const OnboardingPage(),
        "/home": (context) => ChangeNotifierProvider(
              create: (context) => HomePageUiHelper(context),
              child: const HomePage(),
            ),
      },
    );
  }
}


