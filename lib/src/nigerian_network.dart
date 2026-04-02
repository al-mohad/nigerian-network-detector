/// Represents a Nigerian mobile network carrier.
enum NigerianNetwork {
  /// MTN Nigeria — the largest mobile network in Nigeria.
  mtn('MTN'),

  /// Airtel Nigeria — formerly Zain / Celtel.
  airtel('Airtel'),

  /// Globacom (Glo) — a Nigerian-owned network.
  glo('Glo'),

  /// 9mobile — formerly Etisalat Nigeria.
  nineMobile('9mobile'),

  /// An unrecognised prefix that does not map to a known carrier.
  unknown('Unknown');

  const NigerianNetwork(this.label);

  /// Human-readable display label for the network.
  final String label;

  @override
  String toString() => label;
}
