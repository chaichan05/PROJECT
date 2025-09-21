import 'package:flutter/material.dart';

class Validator {
  // static FormFieldValidator<String> accountValidator({String errorMessage = "บัชชีไม่ถูกต้อง"}) {
  //   return (String? accoutadim) {
  //     if (accoutadim != "admin") {
  //       return errorMessage;
  //     }
  //     return null;
  //   };
  // }
  // static FormFieldValidator<String> passwordValidator({String errorMessage = "รหัสผ่านไม่ถูกต้อง"}) {
  //   return (String? passwordadim) {
  //     if (passwordadim != "1234") {
  //       return errorMessage;
  //     }
  //     return null;
  //   };
  // }

  static FormFieldValidator<String> accountValidator({
    String emptyMessage = 'กรุณากรอกชื่อผู้ใช้',
    String invalidMessage = 'ไม่พบบัญชีผู้ใช้',
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return emptyMessage;
      }
      if (value.trim() != "admin") {
        return invalidMessage;
      }
      return null;
    };
  }

  /// ✅ ตรวจสอบรหัสผ่าน (ต้องไม่ว่าง และต้องเป็น 1234)
  static FormFieldValidator<String> passwordValidator({
    String emptyMessage = 'กรุณากรอกรหัสผ่าน',
    String invalidMessage = 'รหัสผ่านไม่ถูกต้อง',
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return emptyMessage;
      }
      if (value.trim() != "1234") {
        return invalidMessage;
      }
      return null;
    };
  }

  static FormFieldValidator<String> required({
    String errorMessage = "กรุณากรอกข้อมูล",
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return errorMessage;
      }
      return null;
    };
  }

  static FormFieldValidator<String> numberValidator({
    String errorMessage = "กรุณากรอกเป็นตัวเลข",
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      final numValue = num.tryParse(value);
      if (numValue == null) {
        return errorMessage;
      }
      return null;
    };
  }

  static FormFieldValidator<String> multiValidator(
    List<FormFieldValidator<String>> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
