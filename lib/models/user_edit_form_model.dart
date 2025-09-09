class UserEditFormModel {
  final String? password;

  UserEditFormModel({
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
    };
  }
}
