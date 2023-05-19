import 'package:crypto_hunt/models/Cryptocurrency.dart';
import 'package:crypto_hunt/providers/market_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/CryptoListTile.dart';
import '../widgets/Navbar.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Navbar(),
     appBar: AppBar(
      title: Text(
      'FAVORITES',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
        letterSpacing: 2,
      ),
    ),
       backgroundColor:Color(0xffFBC700),
       centerTitle: true,
    ),

      body:  Consumer<MarketProvider>(
          builder: (context, marketProvider, child) {
            List<CryptoCurrency> favorites = marketProvider.markets
                .where((element) => element.isFavorite == true)
                .toList();
            if (favorites.length > 0) {
              return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  CryptoCurrency currentCrypto = favorites[index];
                  return CryptoListTile(currentCrypto: currentCrypto);
                },
              );
            } else {
              return const Center(
                child: Text(
                  "No Favorites yet",
                  style: TextStyle(color: Colors.grey, fontSize: 25),
                ),
              );
            }
          },
        )
    ) ;

  }
}
