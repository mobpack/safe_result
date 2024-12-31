import 'package:safe_result/safe_result.dart';

void main() {
  // Basic usage examples
  basicExample();

  // Validation example
  validationExample();

  // Async example
  asyncExample();
}

void basicExample() {
  // Creating Results
  final success = Result<int>.ok(42);
  final failure = Result<int>.error(Exception('Something went wrong'));

  // Pattern matching
  void handleResult(Result<int> result) {
    switch (result) {
      case Ok():
        print('Success: ${result.value}');
      case Error():
        print('Error: ${result.error}');
    }
  }

  handleResult(success); // prints: Success: 42
  handleResult(failure); // prints: Error: Exception: Something went wrong

  // Transformation
  final doubled = success.map((value) => value * 2);
  print(doubled); // prints: Result<int>.ok(84)

  // Default values
  final defaultValue = failure.getOrElse(0);
  print(defaultValue); // prints: 0
}

void validationExample() {
  // User input validation
  Result<int> parseAge(String input) {
    try {
      final age = int.parse(input);
      if (age < 0 || age > 120) {
        return Result.error(Exception('Age must be between 0 and 120'));
      }
      return Result.ok(age);
    } on FormatException {
      return Result.error(Exception('Invalid age format'));
    }
  }

  // Example usage
  final validInput = parseAge('25');
  final invalidFormat = parseAge('not a number');
  final invalidRange = parseAge('150');

  print(validInput); // prints: Result<int>.ok(25)
  print(invalidFormat); // prints: Result<int>.error(Exception: Invalid age format)
  print(invalidRange); // prints: Result<int>.error(Exception: Age must be between 0 and 120)

  // Nullable handling
  final Result<String?> nullableResult = Result.ok(null);
  final nonNullResult = nullableResult.requireNotNull('Value was null');
  print(nonNullResult); // prints: Result<String>.error(Exception: Value was null)

  // Transforming nullable values
  final Result<String?> userName = Result.ok('John');
  final userNameLength = userName.mapNullable(
    (name) => name?.length,
  );
  print(userNameLength); // prints: Result<int?>.ok(4)
}

Future<void> asyncExample() async {
  // Simulated API calls
  Future<Result<String>> fetchUserName() async {
    // Simulating successful API call
    await Future.delayed(Duration(milliseconds: 100));
    return Result.ok('John Doe');
  }

  Future<Result<int>> fetchUserAge(String name) async {
    // Simulating successful API call
    await Future.delayed(Duration(milliseconds: 100));
    return Result.ok(25);
  }

  Future<Result<String>> fetchUserProfile(int age) async {
    // Simulating successful API call
    await Future.delayed(Duration(milliseconds: 100));
    return Result.ok('Profile of $age years old user');
  }

  // Chaining async operations
  final result = await fetchUserName()
      .andThen((name) => fetchUserAge(name))
      .andThen((age) => fetchUserProfile(age));

  print(result); // prints: Result<String>.ok(Profile of 25 years old user)

  // Error handling in async operations
  Future<Result<String>> failingOperation() async {
    await Future.delayed(Duration(milliseconds: 100));
    return Result.error(Exception('Operation failed'));
  }

  final failureResult = await failingOperation()
      .andThen((value) => fetchUserAge(value))
      .andThen((age) => fetchUserProfile(age));

  print(failureResult); // prints: Result<String>.error(Exception: Operation failed)
}
