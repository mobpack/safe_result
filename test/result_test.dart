import 'package:test/test.dart';
import 'package:safe_result/safe_result.dart';

void main() {
  group('Result', () {
    group('creation', () {
      test('ok creates success result', () {
        final result = Result<int>.ok(42);
        expect(result, isA<Ok<int>>());
        expect((result as Ok<int>).value, equals(42));
      });

      test('error creates error result', () {
        final error = Exception('test error');
        final result = Result<int>.error(error);
        expect(result, isA<Error<int>>());
        expect((result as Error<int>).error, equals(error));
      });
    });

    group('pattern matching', () {
      test('matches Ok case correctly', () {
        final result = Result<int>.ok(42);
        switch (result) {
          case Ok():
            expect(result.value, equals(42));
          case Error():
            fail('Should not match Error case');
        }
      });

      test('matches Error case correctly', () {
        final error = Exception('test error');
        final result = Result<int>.error(error);
        switch (result) {
          case Ok():
            fail('Should not match Ok case');
          case Error():
            expect(result.error, equals(error));
        }
      });
    });

    group('map', () {
      test('transforms success value', () {
        final result = Result<int>.ok(42);
        final mapped = result.map((value) => value.toString());
        expect(mapped, isA<Ok<String>>());
        expect((mapped as Ok<String>).value, equals('42'));
      });

      test('preserves error', () {
        final error = Exception('test error');
        final result = Result<int>.error(error);
        final mapped = result.map((value) => value.toString());
        expect(mapped, isA<Error<String>>());
        expect((mapped as Error<String>).error, equals(error));
      });
    });

    group('getOrElse', () {
      test('returns success value', () {
        final result = Result<int>.ok(42);
        expect(result.getOrElse(0), equals(42));
      });

      test('returns default value on error', () {
        final result = Result<int>.error(Exception('test error'));
        expect(result.getOrElse(0), equals(0));
      });
    });
  });
}
