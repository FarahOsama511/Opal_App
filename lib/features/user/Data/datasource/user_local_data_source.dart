import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:opal_app/features/user/Data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';

abstract class UserLocalDataSource {
  Future<List<UserModel>> getUsers();
  Future<Unit> saveUsers(List<UserModel> Users);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences prefs;

  UserLocalDataSourceImpl({required this.prefs});
  @override
  Future<List<UserModel>> getUsers() {
    final jsonString = prefs.getString("SAVE_Users");
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<UserModel> Users = decodeJsonData
          .map<UserModel>((json) => UserModel.fromJson(json))
          .toList();
      return Future.value(Users);
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<Unit> saveUsers(List<UserModel> Users) async {
    final UserModelToJson = Users.map<Map<String, dynamic>>(
      (user) => user.toJson(),
    ).toList();
    prefs.setString("SAVE_Users", jsonEncode(UserModelToJson));
    return unit;
  }
}
