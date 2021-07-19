import 'dart:collection';

/// {@template AddressResults}
/// Extracts the address string from Google Places API response.
///
/// AddressResults holds a `List<String>` and can be itereated over directly
/// (i.e. `addressResults.forEach((){})`).
/// {@endtemplate}
class AddressResults extends ListMixin<String> {
  /// {@macro AddressResults}
  AddressResults({
    List<String>? predictions,
  }) : this.predictions = predictions ??= [];

  List<String> predictions;

  /// {@macro AddressResults}
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
