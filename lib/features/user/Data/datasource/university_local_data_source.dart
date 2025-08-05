import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:opal_app/core/network/local_network.dart';
import 'package:opal_app/features/user/Data/models/university_model.dart';

import '../../../../core/errors/exceptions.dart';

abstract class UniversityLocalDataSource {
  Future<List<UniversityModel>> getUniversities();
  Future<Unit> saveUniversities(List<UniversityModel> universities);
}

class UniversityLocalDataSourceImpl implements UniversityLocalDataSource {
  @override
  Future<List<UniversityModel>> getUniversities() {
    final jsonString = CacheNetwork.getCacheData(key: "SAVE_UNIVERSITIES");
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<UniversityModel> universities = decodeJsonData
          .map<UniversityModel>((json) => UniversityModel.fromJson(json))
          .toList();
      return Future.value(universities);
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<Unit> saveUniversities(List<UniversityModel> universities) async {
    final UniversityModelToJson = universities
        .map<Map<String, dynamic>>((user) => user.toJson())
        .toList();
    CacheNetwork.insertToCache(
      key: "SAVE_UNIVERSITIES",
      value: jsonEncode(UniversityModelToJson),
    );
    return unit;
  }
}
