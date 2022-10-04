// ignore_for_file: must_be_immutable, camel_case_types

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

Widget buildTextField(String klabel, String khint,
    TextEditingController control, void Function(String)? func) {
  return TextField(
    controller: control,
    inputFormatters: <TextInputFormatter>[
      CurrencyTextInputFormatter(
        decimalDigits: 2,
        symbol: '',
      ),
    ],
    keyboardType: TextInputType.number,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      label: Text(klabel),
      prefix: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Text(
            khint,
            style: const TextStyle(color: Colors.white),
          )),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(width: 3.0, color: kPrimaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(width: 3.0, color: kPrimaryColor),
      ),
      labelStyle: const TextStyle(color: Colors.white),
    ),
    onChanged: func,
  );
}
