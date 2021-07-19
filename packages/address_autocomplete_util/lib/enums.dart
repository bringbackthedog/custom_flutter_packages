/// [Status codes documentation](https://developers.google.com/maps/documentation/places/web-service/autocomplete?hl=en_US#place_autocomplete_status_codes)
enum PlacesStatusCodes {
  OK, // indicates that no errors occurred and at least one result was returned.
  ZERO_RESULTS, // indicates that the search was successful but returned no results. This may occur if the search was passed a bounds in a remote location.
  OVER_QUERY_LIMIT, // indicates that you are over your quota.
  REQUEST_DENIED, // indicates that your request was denied, generally because of lack of a valid key parameter.
  INVALID_REQUEST, // generally indicates that the input parameter is missing.
  UNKNOWN_ERROR, // indicates a server-side error; trying again may be successful.
}

extension PlacesStatusCodesExtension on PlacesStatusCodes {
  /// Get the enum value without the enum name.
  String get value => this.toString().split('.').last;
}
