import 'package:apple_bhe/screens/information_screens/financials.dart';
import 'package:apple_bhe/screens/information_screens/inventory.dart';
import 'package:apple_bhe/screens/information_screens/ledger.dart';
import 'package:apple_bhe/screens/information_screens/location.dart';
import 'package:apple_bhe/screens/information_screens/orders.dart';
import 'package:apple_bhe/screens/information_screens/personnel.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/welcome_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color(0xff6C63FF),
            secondary: Color(0xff6C63FF),
          ),
        ),
        initialRoute: WelcomeScreen.id,
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          Financials.id: (context) => Financials(),
          InventoryScreen.id: (context) => InventoryScreen(),
          OrderScreen.id: (context) => OrderScreen(),
          Personnel.id: (context) => Personnel(),
          LedgerScreen.id: (context) => LedgerScreen(),
          Location.id: (context) => Location()
        });
  }
}
