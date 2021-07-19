## [Unreleased]
### Added
- `PlacesException` and `PlacesStatusCode◊s` to provide additional context on
  failed requests (e.g. invalid APIKey)
- Added `AddressFinder.apiKey` setter. 

### Changed
- Removed apiKey parameter from `AddressFinder.fetchAddress()`. Changed to a single setter that must be called before using AddressFinder. 
- Updated example with try/catch on `AddressFinder.fetchAddress()`.
- Fixed sessionToken creation in example. 

## [0.0.1] - 2021-07-19
Initial release.
### Added
- `AddressFinder.fetchAddress()`
- README
<!-- ### Changed -->
<!-- ### Removed -->