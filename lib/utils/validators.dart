class Validators {
  static String? validateName(String? value) {
    if (value != null && value.isNotEmpty) {
      return null;
    }
    return 'Please enter employee name';
  }

  static String? validateRole(String? value) {
    if (value != null && value.isNotEmpty) {
      return null;
    }
    return 'Please select employee role';
  }
}
