import 'package:batua/di/locator.dart';
import 'package:batua/pages/homePage.dart';
import 'package:batua/pages/onboardingPage.dart';
import 'package:batua/pages/tokenInfoPage.dart';
import 'package:batua/pages/transactionHistoryPage.dart';
import 'package:batua/pages/transactionPage.dart';
import 'package:batua/services/account_service.dart';
import 'package:batua/ui_helper/homePageUiHelper.dart';
import 'package:batua/ui_helper/onboarding_page_ui_helper.dart';
import 'package:batua/ui_helper/transaction_history_page_ui_helper.dart';
import 'package:batua/ui_helper/transaction_page_ui_helper.dart';
import 'package:batua/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
void main() async {
  setupDi();
  await Future.wait(
    [
      Hive.initFlutter(),
      dotenv.load(fileName: ".env"),
    ],
  );

  WidgetsFlutterBinding.ensureInitialized();
  bool loggedIn = await AccountService.isLogged();
  runApp(Batua(loggedIn: loggedIn));
}

class Batua extends StatelessWidget {
  final bool loggedIn;
  const Batua({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => OnboardingPageUiHelper(),
        child: MaterialApp(
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          title: "Batua",
          home: loggedIn
              ? ChangeNotifierProvider(
                  create: (context) => getIt<HomePageUiHelper>(),
                  child: const HomePage(),
                )
              : OnboardingPage(),
          routes: {
            "/onboardingPage": (context) => const OnboardingPage(),
            "/homePage": (context) => ChangeNotifierProvider(
                  create: (context) => getIt<HomePageUiHelper>(),
                  child: const HomePage(),
                ),
            "/tokenInfoPage": (context) => const TokenInfoPage(),
            "/transactionHistory": (context) => ChangeNotifierProvider(
                create: (context) => TransactionHistoryPageUiHelper(),
                child: const TransactionHistoryPage()),
            "/transactionPage": (context) => ChangeNotifierProvider(
                create: (context) => TransactionPageUiHelper(),
                child: const TransactionPage()),
          },
        ));
  }
}
