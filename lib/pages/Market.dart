import 'package:crypto_hunt/widgets/CryptoListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Cryptocurrency.dart';
import '../providers/market_provider.dart';
import '../widgets/Navbar.dart';


class Markets extends StatefulWidget {
  const Markets({Key? key}) : super(key: key);

  @override
  State<Markets> createState() => _MarketsState();
}

class _MarketsState extends State<Markets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Navbar(),
        appBar: AppBar(
          title: Text(
            'CRYPTO',
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


        body :Consumer<MarketProvider>(
          builder: (context, MarketProvider, child) {
            if (MarketProvider.isLoading == true) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              );
            } else {
              if (MarketProvider.markets.length > 0) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await MarketProvider.fetchData();
                  },
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: MarketProvider.markets.length,
                    itemBuilder: (context, index) {
                      CryptoCurrency currentCrypto = MarketProvider.markets[index];

                      return CryptoListTile(currentCrypto: currentCrypto);
                    },
                  ),
                );
              } else {
                return const Text("Data Not Found!");
              }
            }
          },
        )
    );
  }
}
