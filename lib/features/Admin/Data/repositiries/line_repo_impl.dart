import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../Domain/entities/line_entity.dart';
import '../../Domain/reporistires/line_repo.dart';
import '../dataSource/line_local_data_source.dart';
import '../dataSource/line_remote_data_source.dart';
import '../models/line_model.dart';

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
    try {
      if (await networkInfo.isConnected) {
        final remoteLines = await remoteDataSource.getAllLines();
        await lineLocalDataSource.saveLines(remoteLines);
        return Right(remoteLines);
      }
      final localLines = await lineLocalDataSource.getLines();
      if (localLines.isNotEmpty) {
        return Right(localLines);
      } else {
        return Left(EmptyCacheFailure());
      }
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure());
      } else {
        return Left(EmptyCacheFailure());
      }
    }
  }

  Future<Either<Failure, Unit>> AddLine(LineEntity Line) async {
    final LineModel lineModel = LineModel(name: Line.name, notes: Line.notes);
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addLine(lineModel);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLine(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteLine(id);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
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
  Future<Either<Failure, Unit>> updateLine(LineEntity line) async {
    final LineModel lineModel = LineModel(
      name: line.name,
      notes: line.notes,
      id: line.id,
    );
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateLine(lineModel);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
