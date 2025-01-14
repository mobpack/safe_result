## 1.1.6

- Improved documentation for error getter to clarify TypeError behavior
- Added test cases for error getter behavior
- Enhanced example documentation

## 1.1.5

- Added @override annotation for value getter in Ok class
- Fixed documentation formatting

## 1.1.4

* Add value getter for easier access to Ok values
* Add equality operators for better comparison
* Improve error handling in map and fold methods
* Update example to use direct value access

## 1.1.3

- Added comprehensive examples:
  - Pattern matching with switch expressions
  - Value transformations and chaining
  - Form validation patterns
  - Async operation handling
  - Error handling strategies
  - Nullable value handling
- Improved documentation with practical use cases

## 1.1.2

- Fixed `fold` method to return non-nullable `Result<U>` with required handlers
- Added comprehensive test cases for `fold` method:
  - Success and error transformations
  - Exception handling
  - Type transformations
- Updated documentation to match new `fold` method signature

## 1.1.1

- Added comprehensive test suite for Result type and extensions
- Added more examples in documentation:
  - Pattern matching with switch expressions
  - Async operation chaining
  - Error handling patterns
  - Nullable Result handling
- Improved API documentation with detailed usage examples
- Added example project demonstrating real-world use cases

## 1.0.0

- Initial version
- Added Result type with Ok and Error variants
- Added map, fold, and getOrElse operations
- Added extension methods for nullable Results
- Added extension methods for Future<Result>
- Added comprehensive documentation and examples
