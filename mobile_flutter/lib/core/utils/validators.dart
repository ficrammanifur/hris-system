class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    return null;
  }
  
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    
    return null;
  }
  
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    
    final phoneRegex = RegExp(r'^[0-9]{10,13}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number (10-13 digits)';
    }
    
    return null;
  }
  
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }
    
    try {
      DateTime.parse(value);
    } catch (e) {
      return 'Invalid date format';
    }
    
    return null;
  }
  
  static String? validateLeaveReason(String? value) {
    if (value == null || value.isEmpty) {
      return 'Reason is required';
    }
    
    if (value.length < 10) {
      return 'Reason must be at least 10 characters';
    }
    
    return null;
  }
  
  static String? validatePositiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    
    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return 'Must be a positive number';
    }
    
    return null;
  }
}