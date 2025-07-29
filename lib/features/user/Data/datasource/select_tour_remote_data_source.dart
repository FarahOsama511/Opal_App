import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:opal_app/core/errors/exceptions.dart';
import 'package:opal_app/features/Admin/Data/models/tour_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SelectTourRemoteDataSource {
  Future<TourModel> SelectionTour(String tourId);
  Future<Unit> UnconfirmTourByUser(String tourId);
}

const Base_Url =
    'http://student-bus-service-api-oi5yen-ed9bc9-74-161-160-200.traefik.me/';

class SelectTourRemoteDataSourceImpl implements SelectTourRemoteDataSource {
  final http.Client client;

  SelectTourRemoteDataSourceImpl({required this.client});
  @override
  Future<TourModel> SelectionTour(String tourId) async {
    final prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('access_token');
    final response = await client.post(
      Uri.parse('${Base_Url}tours/${tourId}/registration'),
      headers: {'Authorization': 'Bearer ${userToken}'},
    );
    print("=== Selection tour: ${response.statusCode} ===");
    print("=== Selection tour: ${response.body} ===");
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return TourModel.fromJson(jsonResponse);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> UnconfirmTourByUser(String tourId) async {
    final prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('access_token');
    final response = await client.delete(
      Uri.parse('${Base_Url}tours/${tourId}/registration}'),
      headers: {'Authorization': 'Bearer $userToken'},
    );

    if (response.statusCode == 200) {
      return unit;
    } else {
      print("state code UNCONFIRMED is ${response.statusCode}");
      print("body:${response.body}");
      throw ServerException();
    }
  }
}
