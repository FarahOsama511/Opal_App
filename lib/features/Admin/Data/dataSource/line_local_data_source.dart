import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/exceptions.dart';
import 'package:opal_app/core/network/local_network.dart';
import 'package:opal_app/features/Admin/Data/models/line_model.dart';

abstract class LineLocalDataSource {
  Future<List<LineModel>> getLines();
  Future<Unit> saveLines(List<LineModel> Line);
}

class LineLocalDataSourceImpl implements LineLocalDataSource {
  @override
  Future<List<LineModel>> getLines() {
    final jsonString = CacheNetwork.getCacheData(key: 'SAVE_LINES');
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<LineModel> Line = decodeJsonData
          .map<LineModel>((json) => LineModel.fromJson(json))
          .toList();
      return Future.value(Line);
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<Unit> saveLines(List<LineModel> Line) async {
    final LineModelToJson = Line.map<Map<String, dynamic>>(
      (line) => line.toJson(),
    ).toList();
    await CacheNetwork.insertToCache(
      key: "SAVE_LINES",
      value: jsonEncode(LineModelToJson),
    );
    return unit;
  }
}
