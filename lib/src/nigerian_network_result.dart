import 'nigerian_network.dart';

/// Immutable result of a Nigerian phone number network detection.
///
/// Contains the validation status, detected network, normalised formats,
/// and a human-readable error message when the input is invalid.
///
/// Use [NigerianNetworkResult.success] and [NigerianNetworkResult.failure]
/// named constructors for clarity:
///
/// ```dart
/// // Successful result
/// final result = NigerianNetworkResult.success(
///   network: NigerianNetwork.mtn,
///   normalized: '08031234567',
///   international: '+2348031234567',
///   prefix: '0803',
/// );
///
/// // Failed result
/// final result = NigerianNetworkResult.failure(
///   error: 'Not a valid Nigerian mobile number.',
/// );
/// ```
class NigerianNetworkResult {
  const NigerianNetworkResult._({
    required this.isValid,
    this.network,
    required this.normalized,
    this.international,
    this.prefix,
    this.error,
  });

  /// Creates a successful detection result.
  const NigerianNetworkResult.success({
    required NigerianNetwork network,
    required String normalized,
    required String international,
    required String prefix,
  }) : this._(
         isValid: true,
         network: network,
         normalized: normalized,
         international: international,
         prefix: prefix,
       );

  /// Creates a failed detection result with an [error] message.
  const NigerianNetworkResult.failure({
    required String error,
    String normalized = '',
  }) : this._(isValid: false, normalized: normalized, error: error);

  /// Whether the input resolved to a valid Nigerian mobile number.
  final bool isValid;

  /// The detected mobile network carrier, or `null` if the number is invalid.
  final NigerianNetwork? network;

  /// The number normalised to local format (e.g. `08031234567`).
  final String normalized;

  /// The number in international E.164-like format (e.g. `+2348031234567`),
  /// or `null` when the input is invalid.
  final String? international;

  /// The 4-digit prefix used for network identification (e.g. `0803`),
  /// or `null` when the input is invalid.
  final String? prefix;

  /// A human-readable description of why detection failed,
  /// or `null` when the number is valid.
  final String? error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NigerianNetworkResult &&
          runtimeType == other.runtimeType &&
          isValid == other.isValid &&
          network == other.network &&
          normalized == other.normalized &&
          international == other.international &&
          prefix == other.prefix &&
          error == other.error;

  @override
  int get hashCode =>
      Object.hash(isValid, network, normalized, international, prefix, error);

  @override
  String toString() {
    if (isValid) {
      return 'NigerianNetworkResult('
          'network: ${network?.label}, '
          'normalized: $normalized, '
          'international: $international, '
          'prefix: $prefix)';
    }
    return 'NigerianNetworkResult(error: $error)';
  }
}
