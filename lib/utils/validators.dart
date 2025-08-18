class Validators {
  // Phone number validator
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if(!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Enter a valid 10 digit phone number';
    }
    return null;
  }

  // Password validator
  static String? validatePassword(String? value){
    if(value == null || value.isEmpty) {
      return 'Password required';
    }
    if(value.length < 8){
      return 'Passsword must be atleast 8 characters';
    }
    return null;
  }

  // Email
  static String? validateEmail(String? value) {
    if(value == null || value.isEmpty) {
      return 'Email required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if(emailRegex.hasMatch(value.trim())){
      return 'Enter a valid email';
    }
    return null;
  }

  // Verification code
  static String? validateVericationCode(String? value, {int length = 6}) {
    if(value == null || value.trim().isEmpty) {
      return 'Verification code required';
    }
    final trimmed = value.trim();
    if(trimmed.length != length) {
      return 'Code must be $length digits';
    }
    if(!RegExp(r'^\d+$').hasMatch(trimmed)){
      return 'Code must contain only digits';
    }
    return null;
  }
}