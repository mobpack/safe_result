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

    group('fold', () {
      test('transforms Ok value using onOk handler', () {
        final result = Result<int>.ok(42);
        final folded = result.fold(
          onOk: (value) => value.toString(),
          onError: (error) => 'error',
        );
        expect(folded, isA<Ok<String>>());
        expect((folded as Ok<String>).value, equals('42'));
      });

      test('transforms Error value using onError handler', () {
        final error = Exception('test error');
        final result = Result<int>.error(error);
        final folded = result.fold(
          onOk: (value) => value.toString(),
          onError: (error) => 'error: ${error.toString()}',
        );
        expect(folded, isA<Ok<String>>());
        expect((folded as Ok<String>).value, startsWith('error: Exception'));
      });

      test('propagates exception from onOk handler', () {
        final result = Result<int>.ok(42);
        final folded = result.fold(
          onOk: (value) => throw Exception('onOk error'),
          onError: (error) => 'error',
        );
        expect(folded, isA<Error<String>>());
        expect((folded as Error<String>).error.toString(), contains('onOk error'));
      });

      test('propagates exception from onError handler', () {
        final result = Result<int>.error(Exception('original error'));
        final folded = result.fold(
          onOk: (value) => 'ok',
          onError: (error) => throw Exception('onError error'),
        );
        expect(folded, isA<Error<String>>());
        expect((folded as Error<String>).error.toString(), contains('onError error'));
      });

      test('supports type transformation', () {
        final result = Result<int>.ok(42);
        final folded = result.fold<bool>(
          onOk: (value) => value > 0,
          onError: (error) => false,
        );
        expect(folded, isA<Ok<bool>>());
        expect((folded as Ok<bool>).value, isTrue);
      });
    });

    group('error getter', () {
      test('returns error for Error result', () {
        final exception = Exception('test error');
        final result = Result<int>.error(exception);
        expect(result.error, equals(exception));
      });

      test('throws TypeError when accessed on Ok result', () {
        final result = Result<int>.ok(42);
        expect(() => result.error, throwsA(isA<TypeError>()));
      });
    });

    group('when', () {
      test('calls ok handler for Ok value', () {
        final result = Result<int>.ok(42);
        final state = result.when(
          ok: (value) => 'success: $value',
          error: (error) => 'error: $error',
        );
        expect(state, equals('success: 42'));
      });

      test('calls error handler for Error value', () {
        final error = Exception('test error');
        final result = Result<int>.error(error);
        final state = result.when(
          ok: (value) => 'success: $value',
          error: (error) => 'error: $error',
        );
        expect(state, startsWith('error: Exception'));
      });

      test('supports different return type', () {
        final result = Result<String>.ok('user123');
        final state = result.when(
          ok: (value) => UserState(
            isLoading: false,
            userId: value,
            error: null,
          ),
          error: (error) => UserState(
            isLoading: false,
            userId: null,
            error: error,
          ),
        );
        expect(state, isA<UserState>());
        expect(state.userId, equals('user123'));
        expect(state.error, isNull);
      });
    });
  });
}

class UserState {
  final bool isLoading;
  final String? userId;
  final Exception? error;

  UserState({
    required this.isLoading,
    required this.userId,
    required this.error,
  });
}
