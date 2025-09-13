import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kampus/models/sign_in_form_model.dart';
import 'package:kampus/models/user_model.dart';
import 'package:kampus/shared/shared_values.dart';

class AuthService {
  Future<UserModel> login(SignInFormModel data) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/authenticate'),
        body: data.toJson(),
      );

      if (res.statusCode == 200) {
        UserModel user = UserModel.fromJson(jsonDecode(res.body));
        user = user.copyWith(
          password: data.password,
          consoleId: data.consoleId,
          // stase: data.stase,
        );

        await storeCredentialToLocal(user);
        return user;
      } else {
        throw Exception(jsonDecode(res.body)['messages']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final token = await getToken();
      final res = await http.post(
        Uri.parse('$baseUrl/mahasiswa/logout'),
        headers: {'Authorization': token},
      );

      // if (res.statusCode == 200) {
      await clearLocalStorage();
      // } else {
      //   throw jsonDecode(res.body)['message'];
      // }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> storeCredentialToLocal(UserModel user) async {
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'token', value: user.token);
      await storage.write(key: 'email', value: user.email);
      await storage.write(key: 'password', value: user.password);
      await storage.write(key: 'id', value: user.id);
      await storage.write(key: 'consoleId', value: user.consoleId);
      await storage.write(key: 'stase', value: user.stase);
    } catch (e) {
      rethrow;
    }
  }

  Future<SignInFormModel> getCredentialFromLocal() async {
    try {
      const storage = FlutterSecureStorage();
      Map<String, String> values = await storage.readAll();

      if (values['email'] == null || values['password'] == null) {
        throw 'authenticated';
      } else {
        final SignInFormModel data = SignInFormModel(
          email: values['email'],
          password: values['password'],
          consoleId: values['consoleId'],
        );
        return data;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getIdMahasiswa() async {
    String idMahasiswa = '';
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: 'id');

    if (value != null) {
      idMahasiswa = value;
    }

    return idMahasiswa;
  }

  Future<String> getStase() async {
    String staseMhs = '';
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: 'stase');

    if (value != null) {
      staseMhs = value;
    }

    return staseMhs;
  }

  Future<String> getToken() async {
    String token = '';
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: 'token');

    if (value != null) {
      token = value;
    }

    return token;
  }

  Future<void> clearLocalStorage() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
  }
}
