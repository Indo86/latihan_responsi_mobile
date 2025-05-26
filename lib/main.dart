import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'services/auth_services.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loggedIn = await AuthService.isLoggedIn;
  runApp(RestaurantApp(initialRoute: loggedIn ? '/home' : '/login'));
}

class RestaurantApp extends StatelessWidget {
  final String initialRoute;
  const RestaurantApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/login':    (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/home':     (_) => const HomePage(),
      },
    );
  }
}
