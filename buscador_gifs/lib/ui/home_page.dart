import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class _HomePageState extends State<HomePage> {

  int _offset = 0;
  String _search;
  final _apiKey = 'itbWR3r622goX2vGeENv444gmB0xB5JQ';

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null)
      response = await http.get("http://api.giphy.com/v1/gifs/trending?api_key=$_apiKey&limit=20&rating=G");
    else
      response = await http.get("http://api.giphy.com/v1/gifs/search?api_key=$_apiKey&q=$_search&limit=20&offset=$_offset&rating=G&lang=pt");

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              decoration: InputDecoration(
                labelText: "Pesquise Aqui!",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder()
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch(snapshot.connectionState) {

                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );

                    default:
                      if (snapshot.hasError) return Container(width: 0.0, height: 0.0);
                      else return _createGifTable(context, snapshot);
                  }
                }
            ),
          )
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null)
      return data.length;
    else
      return data.length + 1;
  }

  Widget _createGifTable(context, snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Image.network(snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),
          );
        }
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
