class Valid {
  bool isPassAccountName = false;
  bool isPassNickname = false;
  bool isSendEmail = false;
  bool isPassEmail = false;
  bool isPassWalletAddress = false;

  Map<String, dynamic> toJson() => {
        'isPassAccountName': isPassAccountName,
        'isPassNickname': isPassNickname,
        'isSendEmail': isSendEmail,
        'isPassEmail': isPassEmail,
        'isPassWalletAddress': isPassWalletAddress
      };

  bool validate() {
    if (isPassAccountName &&
        isPassNickname &&
        isSendEmail &&
        isPassEmail &&
        isPassWalletAddress) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return '''
    isPassAccountName: $isPassAccountName, 
    isPassNickname: $isPassNickname, 
    isSendEmail: $isSendEmail,
    isPassEmail: $isPassEmail, 
    isPassWalletAddress: $isPassWalletAddress''';
  }
}
