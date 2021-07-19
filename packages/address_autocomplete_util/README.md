# address_autocomplete_util

Utilility for calls to **[Google's autocomplete]((https://developers.google.com/maps/documentation/places/web-service/autocomplete?hl=en_US))** API from Flutter. 

Use `AddressFinder.fetchAddress()` future to get a list of address predictions. 

e.g.:
```dart
       TextFormField(
          focusNode: _textFieldFocusNode,
          onChanged: (value) async {
            AddressResults addressResults =
                await AddressFinder.instance.fetchAddress(
              addressToLookup: value,
              placesApiKey: apiKey,
              sessionToken: sessionToken,
            );

            addressResults.forEach((String predictedAddress) {
              log(predictedAddress);
            });
          },
        ),
```

This prints every prediction to the console. 

Note that it is safe to call the API multiple time, here using `.fetchAddress` in the TextField's `onChanged`.  
As long as all the requests within one session have the same `sessionToken`, these will count as a single API call. See the [documentation for Places API](https://developers.google.com/maps/documentation/places/web-service/autocomplete?hl=en_US#session_tokens) for more details about session tokens.