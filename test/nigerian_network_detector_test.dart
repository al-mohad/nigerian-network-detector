import 'package:nigerian_network_detector/nigerian_network_detector.dart';
import 'package:test/test.dart';

void main() {
  group('NigerianNetworkDetector', () {
    // ── detect() ──────────────────────────────────────────────────────────

    group('detect()', () {
      group('valid local format numbers', () {
        test('detects MTN from local prefix 0803', () {
          final result = NigerianNetworkDetector.detect('08031234567');

          expect(result.isValid, isTrue);
          expect(result.network, NigerianNetwork.mtn);
          expect(result.normalized, '08031234567');
          expect(result.international, '+2348031234567');
          expect(result.prefix, '0803');
          expect(result.error, isNull);
        });

        test('detects Airtel from local prefix 0802', () {
          final result = NigerianNetworkDetector.detect('08021234567');

          expect(result.isValid, isTrue);
          expect(result.network, NigerianNetwork.airtel);
          expect(result.prefix, '0802');
        });

        test('detects Glo from local prefix 0805', () {
          final result = NigerianNetworkDetector.detect('08051234567');

          expect(result.isValid, isTrue);
          expect(result.network, NigerianNetwork.glo);
          expect(result.prefix, '0805');
        });

        test('detects 9mobile from local prefix 0909', () {
          final result = NigerianNetworkDetector.detect('09091234567');

          expect(result.isValid, isTrue);
          expect(result.network, NigerianNetwork.nineMobile);
          expect(result.prefix, '0909');
        });
      });

      group('valid international format numbers', () {
        test('handles +234 prefix', () {
          final result = NigerianNetworkDetector.detect('+2348031234567');

          expect(result.isValid, isTrue);
          expect(result.network, NigerianNetwork.mtn);
          expect(result.normalized, '08031234567');
          expect(result.international, '+2348031234567');
        });

        test('handles 234 prefix without +', () {
          final result = NigerianNetworkDetector.detect('2348121234567');

          expect(result.isValid, isTrue);
          expect(result.network, NigerianNetwork.airtel);
          expect(result.normalized, '08121234567');
        });
      });

      group('numbers with formatting characters', () {
        test('strips spaces', () {
          final result = NigerianNetworkDetector.detect('0803 123 4567');

          expect(result.isValid, isTrue);
          expect(result.normalized, '08031234567');
        });

        test('strips dashes', () {
          final result = NigerianNetworkDetector.detect('0803-123-4567');

          expect(result.isValid, isTrue);
          expect(result.normalized, '08031234567');
        });

        test('strips dots', () {
          final result = NigerianNetworkDetector.detect('0803.123.4567');

          expect(result.isValid, isTrue);
          expect(result.normalized, '08031234567');
        });

        test('strips parentheses', () {
          final result = NigerianNetworkDetector.detect('(0803)1234567');

          expect(result.isValid, isTrue);
          expect(result.normalized, '08031234567');
        });

        test('strips mixed formatting', () {
          final result =
              NigerianNetworkDetector.detect('+234 (803) 123-4567');

          expect(result.isValid, isTrue);
          expect(result.network, NigerianNetwork.mtn);
        });
      });

      group('invalid inputs', () {
        test('returns failure for null input', () {
          final result = NigerianNetworkDetector.detect(null);

          expect(result.isValid, isFalse);
          expect(result.error, 'Input must be a non-empty string.');
          expect(result.network, isNull);
          expect(result.international, isNull);
          expect(result.prefix, isNull);
        });

        test('returns failure for empty string', () {
          final result = NigerianNetworkDetector.detect('');

          expect(result.isValid, isFalse);
          expect(result.error, 'Input must be a non-empty string.');
        });

        test('returns failure for whitespace-only string', () {
          final result = NigerianNetworkDetector.detect('   ');

          expect(result.isValid, isFalse);
          expect(result.error, 'Input must be a non-empty string.');
        });

        test('returns failure for non-numeric input', () {
          final result = NigerianNetworkDetector.detect('abcdefghijk');

          expect(result.isValid, isFalse);
          expect(result.error, 'Not a valid Nigerian mobile number.');
        });

        test('returns failure for short number', () {
          final result = NigerianNetworkDetector.detect('080312345');

          expect(result.isValid, isFalse);
          expect(result.error, 'Not a valid Nigerian mobile number.');
        });

        test('returns failure for long number', () {
          final result = NigerianNetworkDetector.detect('080312345678');

          expect(result.isValid, isFalse);
        });

        test('returns failure for non-mobile prefix', () {
          final result = NigerianNetworkDetector.detect('01234567890');

          expect(result.isValid, isFalse);
        });
      });
    });

    // ── All network prefixes ──────────────────────────────────────────────

    group('all known prefixes', () {
      final expectedMappings = {
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
        // 9mobile
        '0809': NigerianNetwork.nineMobile,
        '0817': NigerianNetwork.nineMobile,
        '0818': NigerianNetwork.nineMobile,
        '0908': NigerianNetwork.nineMobile,
        '0909': NigerianNetwork.nineMobile,
      };

      for (final entry in expectedMappings.entries) {
        test('prefix ${entry.key} → ${entry.value.label}', () {
          final number = '${entry.key}1234567';
          final result = NigerianNetworkDetector.detect(number);

          expect(result.isValid, isTrue);
          expect(result.network, entry.value);
          expect(result.prefix, entry.key);
        });
      }
    });

    // ── Convenience methods ───────────────────────────────────────────────

    group('isValid()', () {
      test('returns true for valid number', () {
        expect(NigerianNetworkDetector.isValid('08031234567'), isTrue);
      });

      test('returns false for invalid number', () {
        expect(NigerianNetworkDetector.isValid('1234567890'), isFalse);
      });

      test('returns false for null', () {
        expect(NigerianNetworkDetector.isValid(null), isFalse);
      });

      test('returns false for empty string', () {
        expect(NigerianNetworkDetector.isValid(''), isFalse);
      });
    });

    group('networkOf()', () {
      test('returns correct network for valid number', () {
        expect(
          NigerianNetworkDetector.networkOf('09091234567'),
          NigerianNetwork.nineMobile,
        );
      });

      test('returns null for invalid number', () {
        expect(NigerianNetworkDetector.networkOf('1234567890'), isNull);
      });
    });

    group('normalize()', () {
      test('normalises international to local format', () {
        expect(
          NigerianNetworkDetector.normalize('+2348031234567'),
          '08031234567',
        );
      });

      test('returns null for invalid input', () {
        expect(NigerianNetworkDetector.normalize('invalid'), isNull);
      });
    });

    group('toInternational()', () {
      test('formats local to international', () {
        expect(
          NigerianNetworkDetector.toInternational('08031234567'),
          '+2348031234567',
        );
      });

      test('returns null for invalid input', () {
        expect(NigerianNetworkDetector.toInternational('invalid'), isNull);
      });
    });

    // ── NigerianNetworkResult equality ────────────────────────────────────

    group('NigerianNetworkResult', () {
      test('equal results have same hashCode', () {
        final a = NigerianNetworkDetector.detect('08031234567');
        final b = NigerianNetworkDetector.detect('08031234567');

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different results are not equal', () {
        final a = NigerianNetworkDetector.detect('08031234567');
        final b = NigerianNetworkDetector.detect('09091234567');

        expect(a, isNot(equals(b)));
      });

      test('toString() for valid result contains network', () {
        final result = NigerianNetworkDetector.detect('08031234567');

        expect(result.toString(), contains('MTN'));
        expect(result.toString(), contains('08031234567'));
      });

      test('toString() for invalid result contains error', () {
        final result = NigerianNetworkDetector.detect('invalid');

        expect(result.toString(), contains('error'));
      });
    });

    // ── NigerianNetwork enum ──────────────────────────────────────────────

    group('NigerianNetwork', () {
      test('label returns human-readable name', () {
        expect(NigerianNetwork.mtn.label, 'MTN');
        expect(NigerianNetwork.airtel.label, 'Airtel');
        expect(NigerianNetwork.glo.label, 'Glo');
        expect(NigerianNetwork.nineMobile.label, '9mobile');
        expect(NigerianNetwork.unknown.label, 'Unknown');
      });

      test('toString returns label', () {
        expect(NigerianNetwork.mtn.toString(), 'MTN');
        expect(NigerianNetwork.nineMobile.toString(), '9mobile');
      });
    });
  });
}
