import 'package:nigerian_network_detector/nigerian_network_detector.dart';

void main() {
  const testNumbers = [
    '08031234567',
    '+2347061234567',
    '2348121234567',
    '09091234567',
    '08051234567',
    '07055551234',
    '1234567890', // invalid
    'abcdefghijk', // invalid
  ];

  print('Nigerian Phone Network Detector');
  print('=' * 40);

  for (final num in testNumbers) {
    final result = NigerianNetworkDetector.detect(num);

    if (result.isValid) {
      print('Input:         $num');
      print('Normalized:    ${result.normalized}');
      print('International: ${result.international}');
      print('Prefix:        ${result.prefix}');
      print('Network:       ${result.network}');
    } else {
      print('Input:         $num');
      print('Error:         ${result.error}');
    }
    print('-' * 40);
  }

  // ── Convenience methods ──────────────────────────────────────────────
  print('\n── Convenience methods ──');
  print('isValid("08031234567"):          ${NigerianNetworkDetector.isValid("08031234567")}');
  print('networkOf("09091234567"):        ${NigerianNetworkDetector.networkOf("09091234567")}');
  print('normalize("+2348031234567"):     ${NigerianNetworkDetector.normalize("+2348031234567")}');
  print('toInternational("08031234567"):  ${NigerianNetworkDetector.toInternational("08031234567")}');
}
