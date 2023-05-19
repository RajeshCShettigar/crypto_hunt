import 'package:crypto_hunt/pages/Favorites.dart';
import 'package:crypto_hunt/pages/Market.dart';
import 'package:crypto_hunt/pages/news.dart';
import 'package:flutter/material.dart';
import '../widgets/Navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      body: SafeArea(
        child: Container(
          // padding: const EdgeInsets.only(top: 3, left: 3, right: 3, bottom: 3),
          child: IndexedStack(
            index: _currentIndex,
            children: const [
              Markets(),
              Favorites(),
              CryptoNewsList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.amber,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.monetization_on,
                color: Colors.grey,
              ),
              label: 'Market',
              activeIcon: Icon(
                Icons.monetization_on,
                color: Color(0xffFBC700),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: Colors.grey,
              ),
              label: 'Favorite',
              activeIcon: Icon(
                Icons.favorite,
                color: Color(0xffFBC700),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.newspaper,
                color: Colors.grey,
              ),
              label: 'News',
              activeIcon: Icon(
                Icons.newspaper,
                color: Color(0xffFBC700),
              )),
        ],
      ),
    );
  }
}
