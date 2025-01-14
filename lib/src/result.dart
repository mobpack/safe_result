/// A type that represents either success ([Ok]) or failure ([Error]).
sealed class Result<T> {
  const Result();

  /// Creates a successful [Result], completed with the specified [value].
  const factory Result.ok(T value) = Ok._;

  /// Creates an error [Result], completed with the specified [error].
  const factory Result.error(Exception error) = Error._;

  /// Maps a Result<T> to Result<U> by applying a function to the contained Ok value,
  /// leaving an Error value untouched.
  Result<U> map<U>(U Function(T value) transform);

  /// Returns the value if Ok, otherwise returns the provided default value
  T getOrElse(T defaultValue);

  /// Returns true if the result is Ok
  bool get isOk;

  /// Returns true if the result is Error
  bool get isError;

  /// Transforms the Result into another Result using the provided functions
  Result<U> fold<U>({
    required U Function(T value) onOk,
    required U Function(Exception error) onError,
  });

  /// Executes the provided callback if the result is Ok
  Result<T> onSuccess(void Function(T value) action);

  /// Executes the provided callback if the result is Error
  Result<T> onFailure(void Function(Exception error) action);

  /// Returns the value if the result is Ok
  T get value => (this as Ok<T>).value;

  /// Returns the error if this is an [Error] result.
  /// Throws a [TypeError] if this is an [Ok] result.
  Exception get error => (this as Error<T>).error;
}

/// Subclass of Result for values
final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  /// Returned value in result
  @override
  final T value;

  @override
  Result<U> map<U>(U Function(T value) transform) {
    try {
      return Result.ok(transform(value));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  T getOrElse(T defaultValue) => value;

  @override
  bool get isOk => true;

  @override
  bool get isError => false;

  @override
  Result<U> fold<U>({
    required U Function(T value) onOk,
    required U Function(Exception error) onError,
  }) {
    try {
      return Result.ok(onOk(value));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Result<T> onSuccess(void Function(T value) action) {
    action(value);
    return this;
  }

  @override
  Result<T> onFailure(void Function(Exception error) action) => this;

  @override
  String toString() => 'Result<$T>.ok($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ok<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Subclass of Result for errors
final class Error<T> extends Result<T> {
  const Error._(this.error);

  /// Returned error in result
  final Exception error;

  @override
  Result<U> map<U>(U Function(T value) transform) => Error._(error);

  @override
  T getOrElse(T defaultValue) => defaultValue;

  @override
  bool get isOk => false;

  @override
  bool get isError => true;

  @override
  Result<U> fold<U>({
    required U Function(T value) onOk,
    required U Function(Exception error) onError,
  }) {
    try {
      return Result.ok(onError(error));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Result<T> onSuccess(void Function(T value) action) => this;

  @override
  Result<T> onFailure(void Function(Exception error) action) {
    action(error);
    return this;
  }

  @override
  String toString() => 'Result<$T>.error($error)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Error<T> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;
}
