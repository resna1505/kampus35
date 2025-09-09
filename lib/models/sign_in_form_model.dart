class SignInFormModel {
  final String? email;
  final String? password;
  final String? consoleId;

  SignInFormModel({
    this.email,
    this.password,
    this.consoleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'consoleId': consoleId,
    };
  }
}
