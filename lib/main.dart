import 'package:chatify/pages/home_page.dart';
import 'package:chatify/pages/login_page.dart';
import 'package:chatify/pages/signup_page.dart';
import 'package:chatify/pages/splash_page.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    (SplashPage(
      onInitializationComplete: () {
        runApp(MainApp());
      },
    )),
  );
}

//Main app
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext context) => AuthenticationProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Chatify",
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            color: Color.fromRGBO(36, 35, 49, 1.0),
          ),
          scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
          ),
        ),
        navigatorKey: NavigationService.navigatorkey,
        initialRoute: "/login",
        routes: {
          "/login": (BuildContext context) => const LoginPage(),
          "/home": (BuildContext context) => const HomePage(),
          "/signup": (BuildContext context) => const SignupPage(),
        },
      ),
    );
  }
}
