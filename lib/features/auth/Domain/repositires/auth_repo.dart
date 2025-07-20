import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/auth/Domain/entities/authentity.dart';
import 'package:opal_app/features/auth/Domain/entities/login_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, RegisterEntity>> register(
    RegisterEntity registerEntity,
  );
  Future<Either<Failure, LoginEntity>> login(
    String phone,
    String universityCardId,
  );
}
