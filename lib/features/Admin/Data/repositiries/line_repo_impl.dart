import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/Admin/Data/dataSource/line_remote_data_source.dart';
import 'package:opal_app/features/Admin/Data/models/line_model.dart';
import 'package:opal_app/features/Admin/Domain/reporistires/line_repo.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../Domain/entities/line_entity.dart';
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
  @override
  Future<Either<Failure, List<LineEntity>>> getAllLines() async {
    try {
      final localLines = await lineLocalDataSource.getLines();
      if (localLines.isNotEmpty) {
        Future.microtask(() async {
          if (await networkInfo.isConnected) {
            try {
              final remoteLines = await remoteDataSource.getAllLines();
              lineLocalDataSource.saveLines(remoteLines);
            } catch (_) {}
          }
        });
        return Right(localLines);
      }
    } catch (_) {}
    if (await networkInfo.isConnected) {
      try {
        final lines = await remoteDataSource.getAllLines();
        lineLocalDataSource.saveLines(lines);
        return Right(lines);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(EmptyCacheFailure());
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
