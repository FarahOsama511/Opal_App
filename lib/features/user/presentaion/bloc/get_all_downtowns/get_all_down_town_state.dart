import 'package:opal_app/features/Admin/Domain/entities/down_town_entity.dart';

abstract class GetAllDownTownState {}

class GetAllDownTownsInitial extends GetAllDownTownState {}

class GetAllDownTownsLoading extends GetAllDownTownState {}

class GetAllDownTownsSuccess extends GetAllDownTownState {
  List<DownTownEntity> getAllDownTowns;
  GetAllDownTownsSuccess(this.getAllDownTowns);
}

class GetAllDownTownsError extends GetAllDownTownState {
  final String message;
  GetAllDownTownsError(this.message);
}
