import 'package:test/test.dart';
import 'package:safe_result/safe_result.dart';

void main() {
  group('FutureResult', () {
    group('andThen', () {
      test('chains successful futures', () async {
        final future = Future.value(Result<int>.ok(42));
        final chained = await future.andThen(
          (value) => Future.value(Result.ok(value.toString())),
        );
        expect(chained, isA<Ok<String>>());
        expect((chained as Ok<String>).value, equals('42'));
      });

      test('handles error in first future', () async {
        final error = Exception('first error');
        final future = Future.value(Result<int>.error(error));
        final chained = await future.andThen(
          (value) => Future.value(Result.ok(value.toString())),
        );
        expect(chained, isA<Error<String>>());
        expect((chained as Error<String>).error, equals(error));
      });

      test('handles error in second future', () async {
        final error = Exception('second error');
        final future = Future.value(Result<int>.ok(42));
        final chained = await future.andThen(
          (value) => Future.value(Result<String>.error(error)),
        );
        expect(chained, isA<Error<String>>());
        expect((chained as Error<String>).error, equals(error));
      });
    });

    group('mapAsync', () {
      test('transforms successful future', () async {
        final future = Future.value(Result<int>.ok(42));
        final mapped = await future.mapAsync(
          (value) async => value.toString(),
        );
        expect(mapped, isA<Ok<String>>());
        expect((mapped as Ok<String>).value, equals('42'));
      });

      test('preserves error', () async {
        final error = Exception('test error');
        final future = Future.value(Result<int>.error(error));
        final mapped = await future.mapAsync(
          (value) async => value.toString(),
        );
        expect(mapped, isA<Error<String>>());
        expect((mapped as Error<String>).error, equals(error));
      });
    });
  });
}
