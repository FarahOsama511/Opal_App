import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/local_network.dart';
import '../models/down_town_model.dart';

abstract class DownTownLocalDataSource {
  Future<List<DownTownModel>> getDownTown();
  Future<Unit> saveDownTown(List<DownTownModel> downTown);
}

class DownTownLocalDataImpl implements DownTownLocalDataSource {
  @override
  Future<List<DownTownModel>> getDownTown() {
    final jsonString = CacheNetwork.getCacheData(key: 'SAVE_DOWN_TOWN');
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<DownTownModel> downTown = decodeJsonData
          .map<DownTownModel>((json) => DownTownModel.fromJson(json))
          .toList();
      return Future.value(downTown);
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<Unit> saveDownTown(List<DownTownModel> downTown) async {
    final DownTownModelToJson = downTown
        .map<Map<String, dynamic>>((downTown) => downTown.toJson())
        .toList();
    await CacheNetwork.insertToCache(
      key: "SAVE_DOWN_TOWN",
      value: jsonEncode(DownTownModelToJson),
    );
    return unit;
  }
}
