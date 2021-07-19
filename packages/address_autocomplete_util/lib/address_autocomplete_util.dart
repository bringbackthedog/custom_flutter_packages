library address_autocomplete_util;

import 'dart:convert';
import 'package:address_autocomplete_util/address_result_model.dart';
import 'package:address_autocomplete_util/constants.dart';
import 'package:address_autocomplete_util/enums.dart';
import 'package:address_autocomplete_util/places_exceptions.dart';
import 'package:http/http.dart' as http;

/// Calls on Google Places API to autocomplete the address field.
///
/// [Documentation for Place API](https://developers.google.com/maps/documentation/places/web-service/autocomplete?hl=en_US#session_tokens)
class AddressFinder {
  AddressFinder._();
  static AddressFinder _instance = AddressFinder._();
  static AddressFinder instance = _instance;

  String? _apiKey;
  set apiKey(String key) => _apiKey = key;

  /// Returns encoded Url endpoint.
  /// [addressToLookup] is a single string of the address sent to the autocomplete API.
  ///
  /// Format of url is https://maps.googleapis.com/maps/api/place/autocomplete/json?input=1234+davie+vancouver&key=APIKEY
  Uri _getUri({
    required String addressToLookup,
    required String apiKey,
    String? sessionToken,
  }) {
    //

    Map<String, String> queryParameters = {
      'input': addressToLookup,
      'types': 'address',
      'components': 'country:ca',
      'key': apiKey,
      if (sessionToken != null) 'sessiontoken': sessionToken,
    };

    return Uri.https(kUrlAuthority, kUrlPath, queryParameters);
  }

  /// [addressToLookup] is a single string of the address sent to the autocomplete API.
  Future<AddressResults> fetchAddress({
    required String addressToLookup,
    String? sessionToken,
  }) async {
    //
    if (_apiKey == null) {
      throw Exception(
          'No API key provided. Set your key first using `AddressFinder.apiKey = APIKEY`. ');
    }

    Uri uri = _getUri(
        addressToLookup: addressToLookup,
        apiKey: _apiKey!,
        sessionToken: sessionToken);

    http.Response apiResponse = await http.get(uri);

    if (apiResponse.statusCode == 200) {
      AddressResults addressResults =
          AddressResults.fromJson(jsonDecode(apiResponse.body));

      bool placesReturnValidObject =
          addressResults.requestStatus == PlacesStatusCodes.OK ||
              addressResults.requestStatus == PlacesStatusCodes.ZERO_RESULTS;

      if (placesReturnValidObject)
        return addressResults;
      else
        throw PlacesException(addressResults.requestStatus.value);
      //
    } else {
      throw "Failed to fetch address from Google places API";
    }
  }
}
