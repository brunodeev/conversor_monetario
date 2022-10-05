// ignore_for_file: unused_local_variable, library_private_types_in_public_api, prefer_const_constructors, camel_case_types, must_be_immutable, avoid_print

import 'dart:convert';

import 'package:conversor_de_moedas/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'models/default_text_field.dart';

const request = "https://api.hgbrasil.com/finance/quotations?key=2f451fb1";
void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
      fontFamily: 'SFPro',
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double? dolar;
  double? euro;

  void _clearAll() {
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar!).toStringAsFixed(2);
    euroController.text = (real / euro!).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar!).toStringAsFixed(2);
    euroController.text = ((dolar * this.dolar!) / euro!).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro!).toStringAsFixed(2);
    dolarController.text = ((euro * this.euro!) / dolar!).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 89, 121, 153),
      appBar: AppBar(
        title: const Text(
          'Conversor',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  'Carregando Dados...',
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                    'Erro ao Carregar Dados',
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60.0),
                            child: Image.asset(
                              "assets/images/money.png",
                              height: 200,
                            ),
                          ),
                          buildTextField(
                              'Real', 'R\$', realController, _realChanged),
                          SizedBox(height: 15.0),
                          buildTextField(
                              'Dólar', 'US\$', dolarController, _dolarChanged),
                          SizedBox(height: 15.0),
                          buildTextField(
                              'Euro', '€', euroController, _euroChanged),
                        ],
                      ),
                    ),
                  );
                }
            }
          }),
    );
  }
}
