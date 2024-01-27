bool validateEmail(String emailAddress) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(emailAddress);

bool validatePassword(String password) => password.length >= 8;

bool isVideoUrl(String url) {
  final RegExp videoExtensions = RegExp(r'\.(mp4|avi|mov|wmv)$', caseSensitive: false);
  return videoExtensions.hasMatch(url);
}
