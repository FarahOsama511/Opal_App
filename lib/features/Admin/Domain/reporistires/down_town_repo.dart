import 'package:dartz/dartz.dart';
import 'package:opal_app/features/Admin/Domain/entities/down_town_entity.dart';
import '../../../../core/errors/failure.dart';

abstract class DownTownRepo {
  Future<Either<Failure, List<DownTownEntity>>> getAllDownTown();
  Future<Either<Failure, DownTownEntity>> getDownTownById(String id);
  Future<Either<Failure, Unit>> AddDownTown(DownTownEntity DownTownEntity);
  //  Future<Either<Failure, Unit>> updateLine(DownTownEntity DownTownEntity);
  Future<Either<Failure, Unit>> deleteDownTown(String id);
}
