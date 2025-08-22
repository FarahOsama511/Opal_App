import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/user/Domain/entities/authentity.dart';
import 'package:opal_app/features/user/Domain/entities/login_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, RegisterEntity>> register(
    RegisterEntity registerEntity,
  );
  Future<Either<Failure, LoginEntity>> loginStudent(
    String phone,
    String cardId,
  );
  Future<Either<Failure, LoginEntity>> loginAdmin(
    String email,
    String password,
    String role,
  );
}
