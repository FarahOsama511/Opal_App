import '../../../Domain/entities/university_entity.dart';

abstract class GetAllUniversitiesState {}

class GetAllUniversitiesInitial extends GetAllUniversitiesState {}

class GetAllUniversitiesLoading extends GetAllUniversitiesState {}

class GetAllUniversitiesSuccess extends GetAllUniversitiesState {
  List<UniversityEntity> GetAllUniversities;
  GetAllUniversitiesSuccess(this.GetAllUniversities);
}

class GetAllUniversitiesError extends GetAllUniversitiesState {
  final String message;
  GetAllUniversitiesError(this.message);
}
