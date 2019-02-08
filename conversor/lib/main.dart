import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<Map> getData() async {
  const url = "https://api.hgbrasil.com/finance?format=json-cors&key=2a5219f9";
  http.Response response = await http.get(url);
  return json.decode(response.body);
}

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.dolar).toStringAsFixed(2);
    dolarController.text = (euro * this.dolar / euro).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text("Carregando dados...",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0)),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erro ao carregar dados.",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0)),
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,
                              size: 150.0, color: Colors.amber),
                          buildTextField(
                              "Reais", "R\$", realController, _realChanged),
                          Divider(),
                          buildTextField("Dólares", "US\$", dolarController,
                              _dolarChanged),
                          Divider(),
                          buildTextField(
                              "Euro", "£", euroController, _euroChanged)
                        ],
                      ));
                }
            }
          }),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
      controller: c,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber),
          border: OutlineInputBorder(),
          prefixText: prefix),
      style: TextStyle(color: Colors.amber, fontSize: 25.0),
      onChanged: f,
      keyboardType: TextInputType.number);
}
