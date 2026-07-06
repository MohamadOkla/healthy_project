import 'package:flutter/services.dart';

import '../constants/app_regex.dart';

abstract final class Validators {
  static const String emailEnglishOnlyMessage =
      'يجب إدخال بريد إلكتروني باللغة الإنجليزية فقط';

  static const String passwordLengthMessage =
      'كلمة المرور يجب أن تكون 8 أحرف على الأقل';

  static const String passwordUppercaseMessage =
      'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل';

  static const String passwordLowercaseMessage =
      'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل';

  static const String passwordNumberMessage =
      'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';

  static const String passwordSpecialMessage =
      'يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل';

  static const String passwordEnglishOnlyMessage =
      'يجب إدخال كلمة المرور بحروف إنجليزية فقط وبدون مسافات';

  static const String confirmPasswordMessage = 'كلمتا المرور غير متطابقتين';

  static final List<TextInputFormatter> emailInputFormatters = [
    FilteringTextInputFormatter.allow(AppRegex.emailAllowedCharacters),
  ];

  static final List<TextInputFormatter> passwordInputFormatters = [
    FilteringTextInputFormatter.allow(AppRegex.passwordAllowedCharacters),
  ];

  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return emailEnglishOnlyMessage;
    }
    if (AppRegex.hasArabic.hasMatch(email) ||
        AppRegex.hasWhitespace.hasMatch(email) ||
        !AppRegex.emailRegex.hasMatch(email)) {
      return emailEnglishOnlyMessage;
    }
    return null;
  }

  static String? validateEmailOrPhone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني أو رقم الهاتف';
    }

    final phoneOnly = RegExp(r'^[0-9+()-]+$').hasMatch(text) &&
        RegExp(r'[0-9]{7,}').hasMatch(text.replaceAll(RegExp(r'[^0-9]'), ''));
    if (phoneOnly) {
      return null;
    }

    return validateEmail(text);
  }

  static String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.length < 8) {
      return passwordLengthMessage;
    }
    if (AppRegex.hasArabic.hasMatch(password) ||
        AppRegex.hasWhitespace.hasMatch(password)) {
      return passwordEnglishOnlyMessage;
    }
    if (!AppRegex.hasUppercase.hasMatch(password)) {
      return passwordUppercaseMessage;
    }
    if (!AppRegex.hasLowercase.hasMatch(password)) {
      return passwordLowercaseMessage;
    }
    if (!AppRegex.hasNumber.hasMatch(password)) {
      return passwordNumberMessage;
    }
    if (!AppRegex.hasSpecialCharacter.hasMatch(password)) {
      return passwordSpecialMessage;
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String password,
  ) {
    if (value != password) {
      return confirmPasswordMessage;
    }
    return null;
  }

  static int passwordStrengthScore(String password) {
    var score = 0;
    if (password.length >= 8) score++;
    if (AppRegex.hasUppercase.hasMatch(password) &&
        AppRegex.hasLowercase.hasMatch(password)) {
      score++;
    }
    if (AppRegex.hasNumber.hasMatch(password)) score++;
    if (AppRegex.hasSpecialCharacter.hasMatch(password)) score++;
    return score.clamp(0, 4);
  }
}
