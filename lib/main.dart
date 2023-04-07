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
import 'package:provider/provider.dart';
import 'package:apple_bhe/link_contract.dart';

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
    return ChangeNotifierProvider(
      create: (_) => LinkSmartContract(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xff331E38),
          appBarTheme: AppBarTheme(backgroundColor: Color(0xff706993)),
          fontFamily: 'Oswald',
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color(0xff6C63FF),
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
          LocationScreen.id: (context) => LocationScreen()
        },
      ),
    );
  }
}
