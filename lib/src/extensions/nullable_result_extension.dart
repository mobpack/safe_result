import '../result.dart';

/// Extension methods for Result<T> when T is nullable
extension NullableResultExtension<T> on Result<T?> {
  /// Convert a Result<T?> to a Result<T> by converting null values to errors
  Result<T> requireNotNull([String? message]) => switch (this) {
        Ok(value: final v) when v != null => Result.ok(v),
        Ok() => Result.error(
            Exception(message ?? 'Required value was null'),
          ),
        Error(error: final e) => Result.error(e),
      };

  /// Transform a nullable value to another nullable type
  Result<U?> mapNullable<U>(U? Function(T? value) transform) => switch (this) {
        Ok(value: final v) => Result.ok(transform(v)),
        Error(error: final e) => Result.error(e),
      };
}
