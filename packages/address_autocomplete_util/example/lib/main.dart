import 'dart:developer';

import 'package:address_autocomplete_util/address_autocomplete_util.dart';
import 'package:address_autocomplete_util/address_result_model.dart';
import 'package:address_autocomplete_util/places_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// TODO: ADD API KEY
const apiKey = '';

void main() {
  // Call this anytime *before* using the service.
  AddressFinder.instance.apiKey = apiKey;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String sessionToken = Uuid().v4();
  var _textFieldFocusNode = FocusNode();

  var outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.5),
  );

  @override
  Widget build(BuildContext context) {
    // sessionToken = uuid.v4();

    return Scaffold(
      appBar: AppBar(
        title: Text('Address Autocomplete Util'),
      ),
      body: Center(
        child: TextFormField(
          focusNode: _textFieldFocusNode,
          onChanged: (value) async {
            AddressResults addressResults;

            try {
              addressResults = await AddressFinder.instance.fetchAddress(
                addressToLookup: value,
                sessionToken: sessionToken,
              );

              addressResults.forEach((String predictedAddress) {
                log(predictedAddress);
              });
            } on PlacesException catch (e) {
              log(e.toString());
            }
          },
          decoration: InputDecoration(
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
          ),
        ),
      ),
    );
  }
}
