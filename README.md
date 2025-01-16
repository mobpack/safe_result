# safe_result

A Dart package providing a Result type for handling success and error cases in a type-safe way.

## Features

- Type-safe error handling
- Pattern matching support
- Functional programming utilities
- Async operation support
- Null safety

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  safe_result: ^1.1.6
```

## Usage

```dart
import 'package:safe_result/safe_result.dart';

// Creating Results
final success = Result<int>.ok(42);
final failure = Result<int>.error(Exception('Something went wrong'));

// Pattern matching
switch (success) {
  case Ok():
    print('Value: ${success.value}');
  case Error():
    print('Error: ${success.error}');
}

// Using map for transformation
final doubled = success.map((value) => value * 2);

// Using fold for transformation with error handling
final message = success.fold(
  onOk: (value) => 'Success: $value',
  onError: (error) => 'Error: $error',
);

// Using when for pattern matching with specific return types
final state = success.when(
  ok: (user) => UserState(
    isLoading: false,
    user: user,
    error: null,
  ),
  error: (error) => UserState(
    isLoading: false,
    user: null,
    error: error,
  ),
);

// Safe error access with type checking
try {
  final error = failure.error; // Safe: failure is Error
  print('Error occurred: $error');
} on TypeError {
  print('Cannot access error on Ok result');
}

// Handling nullable values
final Result<String?> nullableResult = Result.ok(null);
final Result<String> nonNullResult = nullableResult.requireNotNull('Value was null');

// Async operations
Future<Result<User>> getUser() async {
  try {
    final user = await api.fetchUser();
    return Result.ok(user);
  } catch (e) {
    return Result.error(Exception('Failed to fetch user: $e'));
  }
}

// Chaining async operations
final userSettings = await getUser()
  .andThen((user) => fetchUserSettings(user.id))
  .mapAsync((settings) async {
    await cache.save(settings);
    return settings;
  });
```

## Additional information

For more examples and detailed documentation, visit the [GitHub repository](https://github.com/mobpack/safe_result).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
