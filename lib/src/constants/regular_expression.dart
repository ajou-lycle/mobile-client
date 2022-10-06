/// Regular expression for matching id.
///
/// Only valid when input has numbers or letters.
/// The length of id is above 3 or below 20.
const String idMatch = r"^[0-9a-zA-Z]{3,20}$";

/// Regular expression for matching password.
///
/// Only valid when input has a small letter, a capital letter, special characters and a number.
/// They must exist at least 1 in the input.
/// The length of password is above 8.
const String passwordMatch = r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$";

/// Regular expression for matching nickname.
///
/// Only valid when input has numbers or letters or koreans.
/// The length of nickname is above 3 or below 10.
const String nicknameMatch = r"^[가-힣0-9a-zA-Z]{3,10}$";

/// Regular expression for matching wallet address.
///
/// Only valid when input starts with 0x and has hex.
/// The length of hex in wallet address *must* be 40.
const String walletAddressMatch = r"0[xX][0-9a-fA-F]{40}";
