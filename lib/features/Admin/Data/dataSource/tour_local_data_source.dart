import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/exceptions.dart';
import 'package:opal_app/core/network/local_network.dart';
import 'package:opal_app/features/Admin/Data/models/tour_model.dart';

abstract class LocalDataSource {
  Future<List<TourModel>> getTours();
  Future<Unit> saveTours(List<TourModel> tours);
}

class TourLocalDataSourceImpl implements LocalDataSource {
  @override
  Future<List<TourModel>> getTours() {
    final jsonString = CacheNetwork.getCacheData(key: 'SAVE_TOURS');
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<TourModel> tours = decodeJsonData
          .map<TourModel>((json) => TourModel.fromJson(json))
          .toList();
      return Future.value(tours);
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<Unit> saveTours(List<TourModel> tours) async {
    final tourModelToJson = tours
        .map<Map<String, dynamic>>((tour) => tour.ToJson(tour))
        .toList();
    await CacheNetwork.insertToCache(
      key: "SAVE_TOURS",
      value: jsonEncode(tourModelToJson),
    );
    return unit;
  }
}
