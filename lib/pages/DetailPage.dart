import 'package:crypto_hunt/models/Cryptocurrency.dart';
import 'package:crypto_hunt/providers/market_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'package:crypto_hunt/models/GraphPoint.dart';
import 'package:crypto_hunt/providers/graph_provider.dart';
import "package:syncfusion_flutter_charts/charts.dart";

class DetailsPage extends StatefulWidget {
  final String id;

  const DetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Widget titleAndDetail(
      String title, String detail, CrossAxisAlignment crossAxisAlignment) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        Text(
          detail,
          style: const TextStyle(fontSize: 17),
        ),
      ],
    );
  }

  late GraphProvider graphProvider;

  int days = 1;
  List<bool> isSelected = [true, false, false, false];

  void toggleDate(int index) async {
    log("Loading....");

    for (int i = 0; i < isSelected.length; i++) {
      if (i == index) {
        isSelected[i] = true;
        log(isSelected.toString());
      } else {
        isSelected[i] = false;
        log(isSelected.toString());
      }
    }
    
    switch (index) {
      case 0:
        days = 1;
        break;
      case 1:
        days = 7;
        break;
      case 2:
        days = 28;
        break;
      case 3:
        days = 90;
        break;
      default:
        break;
    }

    await graphProvider.initializeGraph(widget.id, days);

    setState(() {});

    log("Graph Loaded!");
  }

  void initializeInitialGraph() async {
    log("Loading Graph...");

    await graphProvider.initializeGraph(widget.id, days);
    setState(() {});

    log("Graph Loaded!");
  }

  @override
  void initState() {
    super.initState();

    graphProvider = Provider.of<GraphProvider>(context, listen: false);
    initializeInitialGraph();
  }

  @override
  void dispose() {
    super.dispose();
  
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        
        appBar: AppBar(
        backgroundColor:Colors.amber,
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: ListView(
              
              children: [
                 const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ToggleButtons(
                    fillColor: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                    onPressed: (index) {
                      toggleDate(index);
                    },
                    children: const [
                      Text("1D"),
                      Text("7D"),
                      Text("28D"),
                      Text("90D"),
                    ],
                    isSelected: isSelected,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    series: <AreaSeries>[
                      AreaSeries<GraphPoint, dynamic>(
                          color: const Color.fromARGB(255, 243, 212, 8).withOpacity(0.1),
                          borderColor: const Color.fromARGB(255, 236, 212, 0),
                          borderWidth: 2,
                          dataSource: graphProvider.graphPoints,
                          xValueMapper: (GraphPoint graphPoint, index) =>
                              graphPoint.date,
                          yValueMapper: (GraphPoint graphpoint, index) =>
                              graphpoint.price),
                    ],
                  ),
                ),
                Consumer<MarketProvider>(
                  builder: (context, marketProvider, child) {
                    CryptoCurrency currentCrypto =
                        marketProvider.fetchCryptoById(widget.id);

                    return ListView(                 
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          contentPadding: const EdgeInsets.all(10),
                          tileColor: const Color.fromARGB(19, 22, 22, 22),
                          leading: (
                            ClipOval(
                              child: Image.network(currentCrypto.image!), 
                            )
                          ),
                          title: Text(
                            currentCrypto.name! +
                                " (${currentCrypto.symbol!.toUpperCase()})",
                            style: const TextStyle(
                              fontSize: 30,
                            ),
                          ),
                          subtitle: Text(
                            "₹ " +
                                currentCrypto.currentPrice!.toStringAsFixed(4),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 5, 156, 243),
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                        
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Price Change (24h)",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20 ,),
                            ),
                            Builder(
                              builder: (context) {
                                double priceChange =
                                    currentCrypto.priceChange24!;
                                double priceChangePercentage =
                                    currentCrypto.priceChangePercentage24!;

                                if (priceChange < 0) {
                                  // negative
                                  return Text(
                                    "${priceChangePercentage.toStringAsFixed(2)}% (${priceChange.toStringAsFixed(4)})",
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 23),
                                  );
                                } else {
                                  // positive
                                  return Text(
                                    "+${priceChangePercentage.toStringAsFixed(2)}% (+${priceChange.toStringAsFixed(4)})",
                                    style: const TextStyle(
                                        color: Colors.green, fontSize: 23),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            titleAndDetail(
                                "Market Cap Rank",
                                "#" + currentCrypto.marketCapRank.toString(),
                                CrossAxisAlignment.start),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            titleAndDetail(
                                "Market Cap",
                                "₹ " +
                                    currentCrypto.marketCap!.toStringAsFixed(4),
                                CrossAxisAlignment.start),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            titleAndDetail(
                                "High 24h",
                                "₹ " + currentCrypto.high24!.toStringAsFixed(4),
                                CrossAxisAlignment.start),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            titleAndDetail(
                                "Low 24h",
                                "₹ " + currentCrypto.low24!.toStringAsFixed(4),
                                CrossAxisAlignment.start),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            titleAndDetail(
                                "Circulating Supply",
                                currentCrypto.circulatingSupply!
                                    .toInt()
                                    .toString(),
                                CrossAxisAlignment.start),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            titleAndDetail(
                                "All Time High",
                                currentCrypto.ath!.toStringAsFixed(4),
                                CrossAxisAlignment.start),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            titleAndDetail(
                                "All Time Low",
                                currentCrypto.atl!.toStringAsFixed(4),
                                CrossAxisAlignment.start),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
