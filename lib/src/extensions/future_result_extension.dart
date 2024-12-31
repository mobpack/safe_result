import '../result.dart';

/// Extension methods for Future<Result<T>>
extension FutureResultExtension<T> on Future<Result<T>> {
  /// Chain another async operation that returns a Result
  Future<Result<U>> andThen<U>(
    Future<Result<U>> Function(T value) operation,
  ) async {
    final result = await this;
    return switch (result) {
      Ok(value: final v) => await operation(v),
      Error(error: final e) => Result.error(e),
    };
  }

  /// Transform the successful result value
  Future<Result<U>> mapAsync<U>(
    Future<U> Function(T value) transform,
  ) async {
    final result = await this;
    return switch (result) {
      Ok(value: final v) => Result.ok(await transform(v)),
      Error(error: final e) => Result.error(e),
    };
  }
}
