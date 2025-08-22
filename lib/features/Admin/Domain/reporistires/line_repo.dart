import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/failure.dart';

import '../entities/line_entity.dart';

abstract class LineRepo {
  Future<Either<Failure, List<LineEntity>>> getAllLines();
  Future<Either<Failure, LineEntity>> getLineById(String id);
  Future<Either<Failure, Unit>> AddLine(LineEntity lineEntity);
  Future<Either<Failure, Unit>> updateLine(LineEntity lineEntity);
  Future<Either<Failure, Unit>> deleteLine(String id);
}
