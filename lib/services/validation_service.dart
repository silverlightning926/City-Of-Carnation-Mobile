enum EmailValidationResult {
  valid,
  empty,
  invalid,
  tooLong,
  sameAsOldEmail,
}

enum NameValidationResult {
  valid,
  empty,
  tooLong,
  sameAsOldName,
}

enum PhoneValidationResult {
  valid,
  empty,
  invalid,
  tooLong,
  sameAsOldPhone,
}

enum PasswordValidationResult {
  valid,
  empty,
  doesNotMatch,
  tooShort,
  tooLong,
  tooWeak,
  sameAsOldPassword,
}

final emailValidationPattern = RegExp(
    r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');

final phoneValidationPattern = RegExp(r'^[0-9]{10}$');

final nameValidationPattern = RegExp(r'^[a-zA-Z ]+$');

final passwordValidationPattern =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

class ValidationService {
  static EmailValidationResult validateEmail(String newEmail,
      {String? oldEmail}) {
    final trimmedNewEmail = newEmail.trim();
    final trimmedOldEmail = oldEmail?.trim();

    if (trimmedNewEmail.isEmpty) {
      return EmailValidationResult.empty;
    }

    if (!emailValidationPattern.hasMatch(trimmedNewEmail)) {
      return EmailValidationResult.invalid;
    }

    if (trimmedNewEmail.length > 30) {
      return EmailValidationResult.tooLong;
    }

    if (trimmedOldEmail != null && trimmedNewEmail == trimmedOldEmail) {
      return EmailValidationResult.sameAsOldEmail;
    }

    return EmailValidationResult.valid;
  }

  static String getEmailErrorMessage(EmailValidationResult result) {
    switch (result) {
      case EmailValidationResult.empty:
        return 'Email cannot be empty';
      case EmailValidationResult.invalid:
        return 'Email is invalid';
      case EmailValidationResult.tooLong:
        return 'Email is too long';
      case EmailValidationResult.sameAsOldEmail:
        return 'New email cannot be the same as old email';

      default:
        return '';
    }
  }

  static NameValidationResult validateName(String newName, {String? oldName}) {
    final trimmedNewName = newName.trim();
    final trimmedOldName = oldName?.trim();

    if (trimmedNewName.isEmpty) {
      return NameValidationResult.empty;
    }

    if (trimmedNewName.length > 100) {
      return NameValidationResult.tooLong;
    }

    if (trimmedOldName != null && trimmedNewName == trimmedOldName) {
      return NameValidationResult.sameAsOldName;
    }

    return NameValidationResult.valid;
  }

  static String getNameErrorMessage(NameValidationResult result) {
    switch (result) {
      case NameValidationResult.empty:
        return 'Name cannot be empty';
      case NameValidationResult.tooLong:
        return 'Name is too long';
      case NameValidationResult.sameAsOldName:
        return 'New name cannot be the same as old name';
      default:
        return '';
    }
  }

  static PhoneValidationResult validatePhone(String newPhone,
      {String? oldPhone}) {
    final trimmedNewPhone = newPhone.trim();
    final trimmedOldPhone = oldPhone?.trim();

    if (trimmedNewPhone.isEmpty) {
      return PhoneValidationResult.empty;
    }

    if (!phoneValidationPattern.hasMatch(trimmedNewPhone)) {
      return PhoneValidationResult.invalid;
    }

    if (trimmedNewPhone.length > 10) {
      return PhoneValidationResult.tooLong;
    }

    if (trimmedOldPhone != null && trimmedNewPhone == trimmedOldPhone) {
      return PhoneValidationResult.sameAsOldPhone;
    }

    return PhoneValidationResult.valid;
  }

  static String getPhoneErrorMessage(PhoneValidationResult result) {
    switch (result) {
      case PhoneValidationResult.empty:
        return 'Phone cannot be empty';
      case PhoneValidationResult.invalid:
        return 'Phone is invalid';
      case PhoneValidationResult.tooLong:
        return 'Phone is too long';
      case PhoneValidationResult.sameAsOldPhone:
        return 'New phone cannot be the same as old phone';
      default:
        return '';
    }
  }

  static PasswordValidationResult validatePassword(
      String newPassword, String confirmPassword,
      {String? oldPassword}) {
    final trimmedNewPassword = newPassword.trim();
    final trimmedOldPassword = oldPassword?.trim();

    if (trimmedNewPassword.isEmpty) {
      return PasswordValidationResult.empty;
    }

    if (trimmedNewPassword.length < 8) {
      return PasswordValidationResult.tooShort;
    }

    if (trimmedNewPassword.length > 30) {
      return PasswordValidationResult.tooLong;
    }

    if (!passwordValidationPattern.hasMatch(trimmedNewPassword)) {
      return PasswordValidationResult.tooWeak;
    }

    if (trimmedNewPassword != confirmPassword) {
      return PasswordValidationResult.doesNotMatch;
    }

    if (trimmedOldPassword != null &&
        trimmedNewPassword == trimmedOldPassword) {
      return PasswordValidationResult.sameAsOldPassword;
    }

    return PasswordValidationResult.valid;
  }

  static String getPasswordErrorMessage(PasswordValidationResult result) {
    switch (result) {
      case PasswordValidationResult.empty:
        return 'Password cannot be empty';
      case PasswordValidationResult.doesNotMatch:
        return 'Passwords do not match';
      case PasswordValidationResult.tooShort:
        return 'Password is too short';
      case PasswordValidationResult.tooLong:
        return 'Password is too long';
      case PasswordValidationResult.tooWeak:
        return 'Password is too weak. It must contain at least one uppercase letter, one lowercase letter, one number and one special character';
      case PasswordValidationResult.sameAsOldPassword:
        return 'New password cannot be the same as old password';
      default:
        return '';
    }
  }
}
