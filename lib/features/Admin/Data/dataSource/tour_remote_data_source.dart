import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:opal_app/core/constants/constants.dart';
import 'package:opal_app/core/errors/exceptions.dart';
import '../models/tour_model.dart';
import 'dart:convert';

abstract class TourRemoteDataSource {
  Future<List<TourModel>> getAllTours();
  Future<TourModel> getTourById(String id);
  Future<Unit> addTour(TourModel tour);
  Future<Unit> updateTour(TourModel tour);
  Future<Unit> deleteTour(String id);
}

class TourRemoteDataSourceImpl implements TourRemoteDataSource {
  final http.Client client;

  TourRemoteDataSourceImpl({required this.client});
  @override
  Future<List<TourModel>> getAllTours() async {
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('access_token');

    final response = await client.get(
      Uri.parse('${Base_Url}tours'),
      headers: {'Authorization': 'Bearer $tokenAdmin'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          jsonDecode(response.body) as List<dynamic>;
      print('the tours are: $jsonResponse');
      return jsonResponse.map((json) => TourModel.fromJson(json)).toList();
    } else {
      print("state code is ${response.statusCode}");
      print("body:${response.body}");
      throw ServerException();
    }
  }

  @override
  Future<Unit> addTour(TourModel tour) async {
    final body = {
      'type': tour.type,
      'driverName': tour.driverName,
      'leavesAt': tour.leavesAt.toUtc().toIso8601String(),
      'lineId': tour.line.id,
    };
    print("Request Body: ${jsonEncode(body)}");
    final response = await client.post(
      Uri.parse('${Base_Url}tours'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenAdmin',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return unit;
    } else {
      print("state code add tour is ${response.statusCode}");
      print("body add tour is:${response.body}");
      throw ServerException();
    }
  }

  @override
  Future<Unit> updateTour(TourModel tour) async {
    final tourId = tour.id.toString();
    final body = {
      'type': tour.type,
      'driverName': tour.driverName,
      'leavesAt': tour.leavesAt.toIso8601String(),
      'lineId': tour.line.id,
    };
    final response = await client.put(
      Uri.parse('${Base_Url}tours/${tourId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenAdmin',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("PUT URL: ${Base_Url}tours/${tour.id}");
      print("PUT BODY: $body");
      return unit;
    } else {
      print("state code edit tour is ${response.statusCode}");
      print("PUT URL: ${Base_Url}tours/${tour.id}");
      print("PUT BODY: $body");
      print("body edit tour is:${response.body}");
      throw ServerException();
    }
  }

  @override
  Future<Unit> deleteTour(String id) async {
    final response = await client.delete(
      Uri.parse('${Base_Url}tours/${id.toString()}'),
      headers: {'Authorization': 'Bearer $tokenAdmin'},
    );

    if (response.statusCode == 204) {
      return unit;
    } else {
      print("state code is ${response.statusCode}");
      print("body:${response.body}");
      throw ServerException();
    }
  }

  @override
  Future<TourModel> getTourById(String id) async {
    final response = await client.get(
      Uri.parse('${Base_Url}tours/${id}'),
      headers: {'Authorization': 'Bearer $tokenUser'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('the tour is: $jsonResponse');
      final tour = TourModel.fromJson(jsonResponse);

      return tour;
    } else {
      print("state code is ${response.statusCode}");
      print("body:${response.body}");
      throw ServerException();
    }
  }
}
