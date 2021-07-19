/// Extracts the address string from Google Places API response.
class AddressResult {
  AddressResult({
    this.predictions,
  });

  List<String>? predictions;

  factory AddressResult.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> predictionsMap =
        (json["predictions"] as List).cast<Map<String, dynamic>>();
    List<String> _predictions = predictionsMap
        .map((Map<String, dynamic> predictionJson) =>
            predictionJson['description'] as String)
        .toList();

    return AddressResult(predictions: _predictions);
  }
}
