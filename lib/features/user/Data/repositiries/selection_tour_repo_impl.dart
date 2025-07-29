import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/user/Domain/repositires/select_tour_repo.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../datasource/select_tour_remote_data_source.dart';

class SelectionTourRepoImpl extends SelectionTourRepo {
  final SelectTourRemoteDataSource selectTourRemoteDataSource;
  final NetworkInfo networkInfo;

  SelectionTourRepoImpl({
    required this.networkInfo,
    required this.selectTourRemoteDataSource,
  });
  @override
  Future<Either<Failure, Tour>> SelectionTourByUser(String tourId) async {
    if (await networkInfo.isConnected) {
      try {
        final selectTour = await selectTourRemoteDataSource.SelectionTour(
          tourId,
        );
        return Right(selectTour);
      } on ServerException {
        throw ServerFailure();
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> UnConfirmTourByUser(String tourId) async {
    if (await networkInfo.isConnected) {
      try {
        await selectTourRemoteDataSource.UnconfirmTourByUser(tourId);
        return Right(unit);
      } on ServerException {
        throw ServerFailure();
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
