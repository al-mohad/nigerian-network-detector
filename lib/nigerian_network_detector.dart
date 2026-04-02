/// Detect the mobile network carrier of Nigerian phone numbers.
///
/// Supports MTN, Airtel, Glo, and 9mobile with automatic format normalisation
/// for local (`08031234567`), international (`+2348031234567`), and raw
/// international (`2348031234567`) formats.
///
/// ## Quick start
///
/// ```dart
/// import 'package:nigerian_network_detector/nigerian_network_detector.dart';
///
/// void main() {
///   final result = NigerianNetworkDetector.detect('08031234567');
///
///   if (result.isValid) {
///     print(result.network);       // MTN
///     print(result.international); // +2348031234567
///   }
/// }
/// ```
library;

export 'src/nigerian_network.dart';
export 'src/nigerian_network_detector_base.dart';
export 'src/nigerian_network_result.dart';
