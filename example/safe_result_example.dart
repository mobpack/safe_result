import 'package:safe_result/safe_result.dart';

void main() {
  // Basic usage examples
  basicExample();

  // Pattern matching examples
  patternMatchingExample();

  // Transformation examples
  transformationExample();

  // Validation example
  validationExample();

  // Async example
  asyncExample();

  // Error handling examples
  errorHandlingExample();

  // Nullable Result examples
  nullableExample();
}

void basicExample() {
  // Creating Results
  final success = Result<int>.ok(42);
  final failure = Result<int>.error(Exception('Something went wrong'));

  // Checking result type
  print('Is success? ${success.isOk}'); // true
  print('Is failure? ${failure.isError}'); // true

  // Getting values
  final value = success.getOrElse(0);
  print('Value or default: $value'); // 42

  final fallback = failure.getOrElse(0);
  print('Fallback value: $fallback'); // 0
}

void patternMatchingExample() {
  // Pattern matching with switch expressions
  Result<String> processInput(String input) => switch (input) {
        '' => Result.error(Exception('Input cannot be empty')),
        var str when str.length < 3 =>
          Result.error(Exception('Input too short')),
        var str => Result.ok(str.toUpperCase())
      };

  // Using pattern matching in switch statements
  void handleResult(Result<String> result) {
    switch (result) {
      case Ok(value: final v):
        print('Success: $v');
      case Error(error: final e):
        print('Error: $e');
    }
  }

  handleResult(processInput('')); // Error: Input cannot be empty
  handleResult(processInput('hi')); // Error: Input too short
  handleResult(processInput('hello')); // Success: HELLO
}

void transformationExample() {
  final result = Result<int>.ok(42);

  // Using map to transform success values
  final doubled = result.map((value) => value * 2);
  print(doubled); // Result<int>.ok(84)

  // Using fold to handle both success and error cases
  final stringified = result.fold(
    onOk: (value) => 'Value is: $value',
    onError: (error) => 'Error: $error',
  );
  print(stringified); // Result<String>.ok('Value is: 42')

  // Chaining transformations
  final complex = result.map((value) => value * 2).fold(
        onOk: (value) => value > 50 ? 'Large' : 'Small',
        onError: (error) => 'Error',
      );
  print(complex); // Result<String>.ok('Large')
}

// Data class for validation
class User {
  final String name;
  final int age;
  final String email;

  User(this.name, this.age, this.email);

  @override
  String toString() => 'User(name: $name, age: $age, email: $email)';
}

void validationExample() {
  // Validation functions returning Result
  Result<String> validateName(String name) {
    if (name.isEmpty) {
      return Result.error(Exception('Name cannot be empty'));
    }
    if (name.length < 2) {
      return Result.error(Exception('Name too short'));
    }
    return Result.ok(name);
  }

  Result<int> validateAge(int age) {
    if (age < 0 || age > 120) {
      return Result.error(Exception('Invalid age'));
    }
    return Result.ok(age);
  }

  Result<String> validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return Result.error(Exception('Invalid email format'));
    }
    return Result.ok(email);
  }

  // Combining multiple validations
  Result<User> createUser(String name, int age, String email) {
    final nameResult = validateName(name);
    final ageResult = validateAge(age);
    final emailResult = validateEmail(email);

    if (nameResult.isError || ageResult.isError || emailResult.isError) {
      return Result.error(Exception('Validation failed'));
    } else {
      return Result.ok(
          User(nameResult.value, ageResult.value, emailResult.value));
    }
  }

  // Example usage
  final validUser = createUser('John', 30, 'john@example.com');
  final invalidUser = createUser('', -5, 'invalid-email');

  print(
      validUser); // Success: User(name: John, age: 30, email: john@example.com)
  print(invalidUser); // Error: Exception: Name cannot be empty
}

Future<void> asyncExample() async {
  // Simulated async operations returning Result
  Future<Result<String>> fetchUserName() async {
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      return Result.ok('John Doe');
    } catch (e) {
      return Result.error(Exception('Failed to fetch user'));
    }
  }

  Future<Result<int>> fetchUserAge(String userName) async {
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      return Result.ok(30);
    } catch (e) {
      return Result.error(Exception('Failed to fetch age'));
    }
  }

  // Using andThen for chaining async operations
  final result = await fetchUserName().andThen((name) => fetchUserAge(name));

  // Handle the final result
  switch (result) {
    case Ok(value: final age):
      print('User age: $age');
    case Error(error: final e):
      print('Error: $e');
  }
}

void errorHandlingExample() {
  // Function that might throw
  int riskyOperation(int value) {
    if (value < 0) {
      throw Exception('Value cannot be negative');
    }
    return value * 2;
  }

  // Using Result to handle exceptions
  Result<int> safeOperation(int value) {
    try {
      return Result.ok(riskyOperation(value));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Example usage
  final success = safeOperation(5);
  final failure = safeOperation(-5);

  // Using fold for unified error handling
  void processResult(Result<int> result) {
    result.fold(
      onOk: (value) => print('Operation succeeded: $value'),
      onError: (error) => print('Operation failed: $error'),
    );
  }

  processResult(success); // Operation succeeded: 10
  processResult(
      failure); // Operation failed: Exception: Value cannot be negative
}

void nullableExample() {
  String? nullableName;
  String? validName = 'John';

  // Converting nullable to Result
  final nullResult = Result<String?>.ok(nullableName).requireNotNull();
  final validResult = Result<String>.ok(validName).requireNotNull();

  print(nullResult); // Error: Exception: Value is null
  print(validResult); // Ok: John

  // Custom error message
  final withMessage = Result<String?>.ok(nullableName)
      .requireNotNull('Custom error message for null value');
  print(withMessage); // Error: Exception: Custom error message for null value
}
