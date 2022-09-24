extension InputValidate on String {
  /// Check input is email.
  bool isValidEmailFormat() {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }

  /// Check input is phone number, started 010.
  ///
  /// ```dart
  /// // true
  /// '010-0000-0000'.isValidPhoneNumberFormat()
  ///
  /// // false
  /// '031-0000-0000'.isValidPhoneNumberFormat()
  /// ```
  bool isValidPhoneNumberFormat() {
    return RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$').hasMatch(this);
  }

  /// Check input is wallet address.
  /// The wallet address must be started 0x or 0X.
  /// And its length is 42.
  bool isValidWalletAddress() {
    return RegExp(r"0[xX][0-9a-fA-F]{40}").hasMatch(this);
  }
}