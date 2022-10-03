// ignore_for_file: unused_local_variable, library_private_types_in_public_api, prefer_const_constructors, camel_case_types, must_be_immutable

import 'dart:convert';

import 'package:conversor_de_moedas/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

const request = "https://api.hgbrasil.com/finance/quotations?key=2f451fb1";
void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double? dolar;
  double? euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 89, 121, 153),
      appBar: AppBar(
        title: const Text('Conversor'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
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
                            padding: const EdgeInsets.symmetric(vertical: 40.0),
                            child: Image.asset(
                              "assets/images/money.png",
                              height: 200,
                            ),
                          ),
                          kTextField(
                            klabel: 'Real',
                            khint: 'R\$',
                          ),
                          SizedBox(height: 15.0),
                          kTextField(
                            klabel: 'Dolar',
                            khint: 'USD',
                          ),
                          SizedBox(height: 15.0),
                          kTextField(
                            klabel: 'Euro',
                            khint: 'EUR',
                          ),
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

class kTextField extends StatelessWidget {
  kTextField({Key? key, required this.klabel, required this.khint})
      : super(key: key);

  String klabel;
  String khint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        label: Text(klabel),
        prefix: Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: Text(
              khint,
              style: TextStyle(color: Colors.white),
            )),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        labelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
