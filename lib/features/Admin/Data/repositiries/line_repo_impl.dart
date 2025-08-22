import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/Admin/Data/dataSource/line_remote_data_source.dart';
import 'package:opal_app/features/Admin/Data/models/line_model.dart';
import 'package:opal_app/features/Admin/Domain/reporistires/line_repo.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../Domain/entities/line_entity.dart';
import '../../Domain/entities/tour.dart';
import '../dataSource/line_local_data_source.dart';

class LineRepoImpl extends LineRepo {
  final LineLocalDataSource lineLocalDataSource;
  final LineRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  LineRepoImpl(
    this.networkInfo, {
    required this.remoteDataSource,
    required this.lineLocalDataSource,
  });
  @override
  Future<Either<Failure, List<LineEntity>>> getAllLines() async {
    if (await networkInfo.isConnected) {
      try {
        final Lines = await remoteDataSource.getAllLines();
        lineLocalDataSource.saveLines(Lines);
        return Right(Lines);
      } catch (e) {
        try {
          final localLines = await lineLocalDataSource.getLines();
          print("========${localLines.length}==========");
          return Right(localLines);
        } on EmptyCacheException {
          return Left(EmptyCacheFailure());
        }
      }
    } else {
      final localLines = await lineLocalDataSource.getLines();
      try {
        return Right(localLines);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  Future<Either<Failure, Unit>> AddLine(LineEntity Line) async {
    final LineModel lineModel = LineModel(name: Line.name);
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.AddLine(lineModel);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLine(String id) {
    // TODO: implement deleteLine
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, LineEntity>> getLineById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final line = await remoteDataSource.getLineById(id);
        return Right(line);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateLine(LineEntity lineEntity) {
    // TODO: implement updateLine
    throw UnimplementedError();
  }
}
