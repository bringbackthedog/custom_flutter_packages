import 'dart:collection';

/// Extracts the address string from Google Places API response.
class AddressResults extends ListMixin<String> {
  AddressResults({
    List<String>? predictions,
  }) : this.predictions = predictions ??= [];

  List<String> predictions;

  factory AddressResults.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> predictionsMap =
        (json["predictions"] as List).cast<Map<String, dynamic>>();
    List<String> _predictions = predictionsMap
        .map((Map<String, dynamic> predictionJson) =>
            predictionJson['description'] as String)
        .toList();

    return AddressResults(predictions: _predictions);
  }

  @override
  int get length => predictions.length;
  set length(newLength) => predictions.length = newLength;

  @override
  String operator [](int index) => predictions[index];

  @override
  void operator []=(int index, value) => predictions[index] = value;
}
