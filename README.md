# Nigerian Network Detector

[![Dart](https://img.shields.io/badge/Dart-3.11+-blue.svg)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A lightweight, **zero-dependency** Dart package for detecting the mobile network carrier of Nigerian phone numbers.

## Features

- 🔍 **Network Detection** — Identify MTN, Airtel, Glo, and 9mobile from a phone number
- 📱 **Format Normalisation** — Automatically normalises local, international (+234), and raw international formats
- ✅ **Validation** — Verify whether a string is a valid Nigerian mobile number
- 🌍 **International Formatting** — Convert any valid input to E.164-like international format
- 🪶 **Zero Dependencies** — Pure Dart with no external runtime packages

## Supported Formats

| Format              | Example           |
| ------------------- | ----------------- |
| Local               | `08031234567`     |
| International (+)   | `+2348031234567`  |
| International (raw) | `2348031234567`   |
| Formatted           | `0803-123-4567`   |

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  nigerian_network_detector: ^1.0.0
```

Then run:

```bash
dart pub get
```

## Usage

### Full Detection

```dart
import 'package:nigerian_network_detector/nigerian_network_detector.dart';

void main() {
  final result = NigerianNetworkDetector.detect('08031234567');

  if (result.isValid) {
    print(result.network);       // MTN
    print(result.normalized);    // 08031234567
    print(result.international); // +2348031234567
    print(result.prefix);        // 0803
  } else {
    print(result.error);         // Error description
  }
}
```

### Quick Validation

```dart
NigerianNetworkDetector.isValid('08031234567');  // true
NigerianNetworkDetector.isValid('1234567890');   // false
```

### Get Network Directly

```dart
final network = NigerianNetworkDetector.networkOf('09091234567');
print(network); // 9mobile
```

### Format Conversion

```dart
// International → Local
NigerianNetworkDetector.normalize('+2348031234567');
// '08031234567'

// Local → International
NigerianNetworkDetector.toInternational('08031234567');
// '+2348031234567'
```

## Supported Networks & Prefixes

| Network  | Prefixes                                                               |
| -------- | ---------------------------------------------------------------------- |
| MTN      | 0703, 0706, 0803, 0806, 0810, 0813, 0814, 0816, 0903, 0906, 0913, 0916 |
| Airtel   | 0701, 0708, 0802, 0808, 0812, 0901, 0902, 0907, 0911                   |
| Glo      | 0705, 0805, 0807, 0811, 0815, 0905, 0915                               |
| 9mobile  | 0809, 0817, 0818, 0908, 0909                                           |

## API Reference

| Method                                      | Returns                  | Description                              |
| ------------------------------------------- | ------------------------ | ---------------------------------------- |
| `NigerianNetworkDetector.detect(phone)`     | `NigerianNetworkResult`  | Full detection with all metadata         |
| `NigerianNetworkDetector.isValid(phone)`    | `bool`                   | Quick validity check                     |
| `NigerianNetworkDetector.networkOf(phone)`  | `NigerianNetwork?`       | Network enum or null                     |
| `NigerianNetworkDetector.normalize(phone)`  | `String?`                | Local format or null                     |
| `NigerianNetworkDetector.toInternational(phone)` | `String?`           | International format or null             |

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
