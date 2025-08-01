import 'package:formz/formz.dart';

// Define input validation errors
enum IntegerInputError { isEmpty, notAnInteger, tooSmall, tooLarge }

class IntegerInput extends FormzInput<int?, IntegerInputError> {
  const IntegerInput.pure([super.value]) : super.pure();
  const IntegerInput.dirty([super.value]) : super.dirty();

  @override
  IntegerInputError? validator(int? value) {
    if (value == null || value.toString().isEmpty) {
      return IntegerInputError.isEmpty;
    }
    // Example: Check for non-negative integers
    if (value < 0) {
      return IntegerInputError.tooSmall;
    }
    if (value > 999) {
      return IntegerInputError.tooLarge;
    }
    // No error
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == IntegerInputError.isEmpty) {
      return 'El campo es requerido';
    }
    if (displayError == IntegerInputError.notAnInteger) {
      return 'No es un entero';
    }
    if (displayError == IntegerInputError.tooSmall) {
      return 'Solo numeros positivos';
    }
    if (displayError == IntegerInputError.tooLarge) return 'Máximo 3 digitos';

    return null;
  }
}
