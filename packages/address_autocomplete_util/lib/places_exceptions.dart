class PlacesException implements Exception {
  final dynamic message;

  PlacesException([this.message]);

  String toString() {
    Object? message = this.message;
    if (message == null) return "PlacesException";
    return "PlacesException: $message";
  }
}
