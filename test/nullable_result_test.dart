import 'package:test/test.dart';
import 'package:safe_result/safe_result.dart';

void main() {
  group('NullableResult', () {
    group('requireNotNull', () {
      test('converts non-null value', () {
        final Result<String?> result = Result.ok('test');
        final nonNull = result.requireNotNull('Value was null');
        expect(nonNull, isA<Ok<String>>());
        expect((nonNull as Ok<String>).value, equals('test'));
      });

      test('converts null value to error', () {
        final Result<String?> result = Result.ok(null);
        final nonNull = result.requireNotNull('Value was null');
        expect(nonNull, isA<Error<String>>());
        expect(
          (nonNull as Error<String>).error,
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Value was null'),
          ),
        );
      });

      test('preserves original error', () {
        final error = Exception('original error');
        final Result<String?> result = Result.error(error);
        final nonNull = result.requireNotNull('Value was null');
        expect(nonNull, isA<Error<String>>());
        expect((nonNull as Error<String>).error, equals(error));
      });
    });

    group('mapNullable', () {
      test('transforms non-null value', () {
        final Result<String?> result = Result.ok('42');
        final mapped = result.mapNullable((value) => int.tryParse(value!));
        expect(mapped, isA<Ok<int?>>());
        expect((mapped as Ok<int?>).value, equals(42));
      });

      test('transforms to null', () {
        final Result<String?> result = Result.ok('not a number');
        final mapped = result.mapNullable((value) => int.tryParse(value!));
        expect(mapped, isA<Ok<int?>>());
        expect((mapped as Ok<int?>).value, isNull);
      });

      test('handles null input', () {
        final Result<String?> result = Result.ok(null);
        final mapped = result.mapNullable((value) => null);
        expect(mapped, isA<Ok<int?>>());
        expect((mapped as Ok<int?>).value, isNull);
      });

      test('preserves error', () {
        final error = Exception('test error');
        final Result<String?> result = Result.error(error);
        final mapped = result.mapNullable((value) => int.tryParse(value!));
        expect(mapped, isA<Error<int?>>());
        expect((mapped as Error<int?>).error, equals(error));
      });

      test('handles null transformation', () {
        final Result<String?> result = Result.ok('42');
        final mapped = result.mapNullable((_) => null);
        expect(mapped, isA<Ok<int?>>());
        expect((mapped as Ok<int?>).value, isNull);
      });
    });
  });
}
