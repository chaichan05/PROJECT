import 'package:flutter/material.dart';

class Validator {
  static FormFieldValidator<String> required({String errorMessage = "กรุณากรอกข้อมูล"}) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return errorMessage;
      }
      return null;
    };
  }
  static FormFieldValidator<String> numberValidator({String errorMessage = "กรุณากรอกเป็นตัวเลข"}) {
  return (value) {
    if (value == null || value.trim().isEmpty) return null;
    final numValue = num.tryParse(value);
    if (numValue == null) {
      return errorMessage;
    }
    return null;
  };
}
static FormFieldValidator<String> multiValidator(List<FormFieldValidator<String>> validators) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}

