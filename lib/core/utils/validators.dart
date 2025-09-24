/// Utility class for common validation functions
class Validators {
  Validators._();

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Validates password strength
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (value.length > 50) {
      return 'Password must be less than 50 characters';
    }
    
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    
    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    
    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    
    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    
    return null;
  }

  /// Validates name (first name, last name, etc.)
  static String? validateName(String? value, {String fieldName = 'Name'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters long';
    }
    
    if (value.length > 100) {
      return '$fieldName must be less than 100 characters';
    }
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value)) {
      return '$fieldName can only contain letters, spaces, hyphens, and apostrophes';
    }
    
    return null;
  }

  /// Validates phone number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // Check for valid length (10 digits for most countries)
    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  /// Validates required field
  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates minimum length
  static String? validateMinLength(
    String? value,
    int minLength, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters long';
    }
    
    return null;
  }

  /// Validates maximum length
  static String? validateMaxLength(
    String? value,
    int maxLength, {
    String fieldName = 'Field',
  }) {
    if (value != null && value.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }
    
    return null;
  }

  /// Validates numeric input
  static String? validateNumeric(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (double.tryParse(value) == null) {
      return '$fieldName must be a valid number';
    }
    
    return null;
  }

  /// Validates age
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'Age must be a valid number';
    }
    
    if (age < 0 || age > 150) {
      return 'Please enter a valid age';
    }
    
    return null;
  }

  /// Validates URL format
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }

  /// Validates date format (YYYY-MM-DD)
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }
    
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Please enter a valid date (YYYY-MM-DD)';
    }
  }

  /// Validates that two passwords match
  static String? validatePasswordConfirmation(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Password confirmation is required';
    }
    
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    
    return null;
  }
}
