import 'package:opal_app/features/user/Domain/entities/university_entity.dart';

abstract class GetUniversityByIdState {}

class getUniversityByIdInitial extends GetUniversityByIdState {}

class getUniversityByIdLoading extends GetUniversityByIdState {}

class getUniversityByIdSuccess extends GetUniversityByIdState {
  UniversityEntity university;
  getUniversityByIdSuccess(this.university);
}

class getUniversityByIdError extends GetUniversityByIdState {
  final String message;
  getUniversityByIdError(this.message);
}
