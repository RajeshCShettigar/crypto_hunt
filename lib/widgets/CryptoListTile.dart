import 'package:crypto_hunt/models/Cryptocurrency.dart';
import 'package:crypto_hunt/providers/market_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/DetailPage.dart';

class CryptoListTile extends StatelessWidget {
  final CryptoCurrency currentCrypto;

  const CryptoListTile({Key? key, required this.currentCrypto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MarketProvider marketProvider =
        Provider.of<MarketProvider>(context, listen: false);
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailsPage(
                        id: currentCrypto.id!,
                      )),
            );
          },
          tileColor: const Color.fromARGB(19, 92, 92, 92),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 00),
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(currentCrypto.image!),
          ),
          title: Row(
            children: [
              Flexible(
                  child: Text(currentCrypto.name!,
                      overflow: TextOverflow.ellipsis)),
              const SizedBox(
                width: 10,
              ),
              (currentCrypto.isFavorite == false)
                  ? GestureDetector(
                      onTap: () {
                        marketProvider.addFavorite(currentCrypto);
                      },
                      child: const Icon(
                        CupertinoIcons.heart,
                        size: 18,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        marketProvider.removeFavorite(currentCrypto);
                      },
                      child: const Icon(
                        CupertinoIcons.heart_fill,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
            ],
          ),
          subtitle: Text(currentCrypto.symbol!.toUpperCase()),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹ " + currentCrypto.currentPrice!.toStringAsFixed(4),
                style: const TextStyle(
                  color: Color(0xff0395eb),
                  fontSize: 18,
                ),
              ),
              Builder(
                builder: (context) {
                  double priceChange = currentCrypto.priceChange24!;
                  double priceChangePercentage =
                      currentCrypto.priceChangePercentage24!;

                  if (priceChange < 0) {
                    // negative
                    return Text(
                      "${priceChangePercentage.toStringAsFixed(2)}% (${priceChange.toStringAsFixed(4)})",
                      style: const TextStyle(color: Colors.red),
                    );
                  } else {
                    // positive
                    return Text(
                      "+${priceChangePercentage.toStringAsFixed(2)}% (+${priceChange.toStringAsFixed(4)})",
                      style: const TextStyle(color: Colors.green),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
