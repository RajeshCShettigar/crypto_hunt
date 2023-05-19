import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:crypto_hunt/pages/HomePage.dart';
import 'package:crypto_hunt/providers/graph_provider.dart';
import 'package:crypto_hunt/pages/Login.dart';
import 'package:crypto_hunt/providers/market_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';
import 'package:crypto_hunt/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MarketProvider>(
          create: (context) => MarketProvider(),
        ),
        ChangeNotifierProvider<GraphProvider>(
          create: (context) => GraphProvider(),
        ),
      ],
      child: const MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            height: myHeight,
            width: myWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FadeInImage(
                  placeholder: AssetImage('images/1.gif'),
                  image: NetworkImage('https://media.tenor.com/jp3nDTIWZWYAAAAj/bitcoin-bittrex-global.gif'),
                ),

                Column(
                  children: [
                    Text(
                      'Crypto Hunt',
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Track your favourite crypto currencies',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: myWidth * 0.14),
                  child: GestureDetector(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final isLoggedIn = prefs.getString('status')==null?false:true;
                      if (isLoggedIn) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffFBC700),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: myWidth * 0.05,
                        vertical: myHeight * 0.013,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Explore!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
}}
