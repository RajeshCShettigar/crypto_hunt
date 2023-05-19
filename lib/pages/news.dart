import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:readmore/readmore.dart';

import '../widgets/Navbar.dart';

class CryptoNewsList extends StatefulWidget {
  const CryptoNewsList({Key? key}) : super(key: key);

  @override
  _CryptoNewsListState createState() => _CryptoNewsListState();
}

class _CryptoNewsListState extends State<CryptoNewsList> {
  List<dynamic> newsItems = [];
  @override
  void initState() {
    super.initState();
    getNews();
  }

  Future<void> getNews() async {
    var response = await http.get(Uri.parse('https://n59der.deta.dev/'));
    String jsonBody = response.body;
    Map<String, dynamic> items = jsonDecode(jsonBody);
    newsItems = items['newsItems'];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    Widget cryptoNewsWidgetMaker(cryptoNewsObject toShow) {
      return Container(
        width: screenWidth * 0.97,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(19, 92, 92, 92),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(toShow.imageUrl),
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                    left: 10,
                    bottom: 7,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        toShow.source.substring(toShow.source.indexOf('|') + 2),
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    )),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.015,
                  horizontal: screenWidth * 0.02),
              child: Text(
                toShow.heading,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    left: screenWidth * 0.02,
                    right: screenWidth * 0.02,
                    bottom: screenWidth * 0.02),
                child: ReadMoreText(
                  toShow.description,
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )),
          ],
        ),
      );
    }

    Stream streamOfNews() {
      return Stream.periodic(Duration(seconds: 10), (count) => getNews());
    }

    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        title: Text(
          'NEWS',
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
      body: StreamBuilder(
        stream: streamOfNews(),
        builder: (context, snapshot) {
          return newsItems.length == 0
              ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              )
          )
              : ListView.builder(
            itemCount: newsItems.length,
            itemBuilder: (context, index) {
              cryptoNewsObject toShow = cryptoNewsObject(
                heading: newsItems[index]["heading"],
                imageUrl: newsItems[index]["imageURL"],
                source: newsItems[index]["source"],
                description: newsItems[index]["description"],
              );
              return cryptoNewsWidgetMaker(toShow);
            },
          );
        },
      ),
    );
  }

}

class cryptoNewsObject {
  final String heading;
  final String imageUrl;
  final String source;
  final String description;
  cryptoNewsObject(
      {required this.heading,
      required this.imageUrl,
      required this.source,
      required this.description});
}
