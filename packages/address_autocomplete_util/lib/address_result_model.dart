import 'dart:collection';

import 'package:address_autocomplete_util/enums.dart';

/// {@template AddressResults}
/// Extracts the address string from Google Places API response.
///
/// AddressResults holds a `List<String>` and can be itereated over directly
/// (i.e. `addressResults.forEach((){})`).
/// {@endtemplate}
class AddressResults extends ListMixin<String> {
  /// {@macro AddressResults}
  AddressResults._privateConstructor({
    List<String>? predictions,
    required this.requestStatus,
  }) : this.predictions = predictions ??= [];

  List<String> predictions;
  PlacesStatusCodes requestStatus;

  /// {@macro AddressResults}
  ///
  /// See [Place Autocomplete
  /// response](https://developers.google.com/maps/documentation/places/web-service/autocomplete?hl=en_US#place_autocomplete_responses)
  /// for full json output.
  factory AddressResults.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> predictionsMap =
        (json["predictions"] as List).cast<Map<String, dynamic>>();
    List<String> _predictions = predictionsMap
        .map((Map<String, dynamic> predictionJson) =>
            predictionJson['description'] as String)
        .toList();

    String statusCode = json['status'];
    PlacesStatusCodes requestStatus = PlacesStatusCodes.values.singleWhere(
        (placesStatusCode) => placesStatusCode.value == statusCode);

    return AddressResults._privateConstructor(
      predictions: _predictions,
      requestStatus: requestStatus,
    );
  }

  @override
  int get length => predictions.length;
  set length(newLength) => predictions.length = newLength;

  @override
  String operator [](int index) => predictions[index];

  @override
  void operator []=(int index, value) => predictions[index] = value;
}
