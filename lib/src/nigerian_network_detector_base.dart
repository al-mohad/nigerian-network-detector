import 'nigerian_network.dart';
import 'nigerian_network_result.dart';

/// Service class for detecting the mobile network carrier of Nigerian
/// phone numbers.
///
/// Supports the following input formats:
/// - **Local:**                `08031234567`
/// - **International (+):**    `+2348031234567`
/// - **International (raw):**  `2348031234567`
///
/// All methods are static — no instantiation required.
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
class NigerianNetworkDetector {
  // ---------------------------------------------------------------------------
  // Network-prefix lookup table
  // ---------------------------------------------------------------------------

  /// Maps 4-digit local prefixes to their corresponding [NigerianNetwork].
  static const Map<String, NigerianNetwork> networkPrefixes = {
    // MTN
    '0703': NigerianNetwork.mtn,
    '0706': NigerianNetwork.mtn,
    '0803': NigerianNetwork.mtn,
    '0806': NigerianNetwork.mtn,
    '0810': NigerianNetwork.mtn,
    '0813': NigerianNetwork.mtn,
    '0814': NigerianNetwork.mtn,
    '0816': NigerianNetwork.mtn,
    '0903': NigerianNetwork.mtn,
    '0906': NigerianNetwork.mtn,
    '0913': NigerianNetwork.mtn,
    '0916': NigerianNetwork.mtn,

    // Airtel
    '0701': NigerianNetwork.airtel,
    '0708': NigerianNetwork.airtel,
    '0802': NigerianNetwork.airtel,
    '0808': NigerianNetwork.airtel,
    '0812': NigerianNetwork.airtel,
    '0901': NigerianNetwork.airtel,
    '0902': NigerianNetwork.airtel,
    '0907': NigerianNetwork.airtel,
    '0911': NigerianNetwork.airtel,

    // Glo
    '0705': NigerianNetwork.glo,
    '0805': NigerianNetwork.glo,
    '0807': NigerianNetwork.glo,
    '0811': NigerianNetwork.glo,
    '0815': NigerianNetwork.glo,
    '0905': NigerianNetwork.glo,
    '0915': NigerianNetwork.glo,

    // 9mobile (formerly Etisalat)
    '0809': NigerianNetwork.nineMobile,
    '0817': NigerianNetwork.nineMobile,
    '0818': NigerianNetwork.nineMobile,
    '0908': NigerianNetwork.nineMobile,
    '0909': NigerianNetwork.nineMobile,
  };

  // ---------------------------------------------------------------------------
  // Regex patterns (compiled once, reused)
  // ---------------------------------------------------------------------------

  /// Characters to strip during normalisation.
  static final RegExp _sanitizePattern = RegExp(r'[\s\-().+]');

  /// Valid Nigerian mobile number format: 11 digits starting with 07x, 08x,
  /// or 09x where x is 0 or 1.
  static final RegExp _nigerianMobilePattern = RegExp(r'^0[7-9][01]\d{8}$');

  // ---------------------------------------------------------------------------
  // Constructor
  // ---------------------------------------------------------------------------

  /// Prevent external instantiation — all members are static.
  NigerianNetworkDetector._();

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Normalises a raw phone number to local format (`0XXXXXXXXXX`).
  ///
  /// Strips whitespace, dashes, dots, parentheses, and the `+` sign, then
  /// converts the `234` international prefix to a leading `0`.
  static String _normalize(String raw) {
    String number = raw.trim().replaceAll(_sanitizePattern, '');

    // Convert international format → local
    if (number.startsWith('234') && number.length == 13) {
      number = '0${number.substring(3)}';
    }

    return number;
  }

  /// Returns `true` when [normalized] matches the Nigerian mobile format.
  static bool _isValidNigerianMobile(String normalized) {
    return _nigerianMobilePattern.hasMatch(normalized);
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Detects the mobile network carrier of a Nigerian [phoneNumber].
  ///
  /// Returns a [NigerianNetworkResult] containing the validation status,
  /// detected network, and formatted variants of the number.
  ///
  /// ```dart
  /// final result = NigerianNetworkDetector.detect('+2348031234567');
  /// print(result.network);       // MTN
  /// print(result.international); // +2348031234567
  /// ```
  static NigerianNetworkResult detect(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      return const NigerianNetworkResult.failure(
        error: 'Input must be a non-empty string.',
      );
    }

    final normalized = _normalize(phoneNumber);

    if (!_isValidNigerianMobile(normalized)) {
      return NigerianNetworkResult.failure(
        error: 'Not a valid Nigerian mobile number.',
        normalized: normalized,
      );
    }

    final prefix = normalized.substring(0, 4);
    final network = networkPrefixes[prefix] ?? NigerianNetwork.unknown;
    final international = '+234${normalized.substring(1)}';

    return NigerianNetworkResult.success(
      network: network,
      normalized: normalized,
      international: international,
      prefix: prefix,
    );
  }

  /// Returns the detected [NigerianNetwork] directly, or `null` when the
  /// number is invalid.
  ///
  /// ```dart
  /// final network = NigerianNetworkDetector.networkOf('09091234567');
  /// print(network); // 9mobile
  /// ```
  static NigerianNetwork? networkOf(String phoneNumber) {
    return detect(phoneNumber).network;
  }

  /// Returns `true` if [phoneNumber] is a valid Nigerian mobile number.
  ///
  /// ```dart
  /// NigerianNetworkDetector.isValid('08031234567');  // true
  /// NigerianNetworkDetector.isValid('1234567890');   // false
  /// ```
  static bool isValid(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) return false;
    return _isValidNigerianMobile(_normalize(phoneNumber));
  }

  /// Normalises [phoneNumber] to local format (`0XXXXXXXXXX`) and returns it,
  /// or `null` when the input is not a valid Nigerian mobile number.
  ///
  /// ```dart
  /// NigerianNetworkDetector.normalize('+2348031234567'); // '08031234567'
  /// ```
  static String? normalize(String phoneNumber) {
    final result = detect(phoneNumber);
    return result.isValid ? result.normalized : null;
  }

  /// Formats [phoneNumber] to international format (`+234XXXXXXXXXX`),
  /// or returns `null` when the input is not valid.
  ///
  /// ```dart
  /// NigerianNetworkDetector.toInternational('08031234567');
  /// // '+2348031234567'
  /// ```
  static String? toInternational(String phoneNumber) {
    return detect(phoneNumber).international;
  }
}
