import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/authentity.dart';
import '../entities/login_entity.dart';

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
