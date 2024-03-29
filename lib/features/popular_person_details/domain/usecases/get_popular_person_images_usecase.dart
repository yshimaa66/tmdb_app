import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:tmdb_app/core/error/failure.dart';
import 'package:tmdb_app/core/services/injection.dart';
import 'package:tmdb_app/core/usecase/base_usecase.dart';
import 'package:tmdb_app/features/popular_person_details/domain/entities/popular_person_details_entity.dart';
import 'package:tmdb_app/features/popular_person_details/domain/repository/popular_person_details_repo.dart';

@lazySingleton
class GetPopularPersonImagesUseCase
    implements
        BaseUseCase<Future<Either<Failure, PopularPersonDetailsEntity?>>,
            GetPopularPersonImagesParameters> {
  Future<Either<Failure, PopularPersonDetailsEntity?>> call(
      GetPopularPersonImagesParameters parameters) {
    debugPrint('GetPopularPersonImagesUseCase');
    return getIt<PopularPersonDetailsRepo>().getPopularPersonImages(
        parameters.popularPersonDetailsEntity);
  }
}

class GetPopularPersonImagesParameters extends Equatable {
  final PopularPersonDetailsEntity popularPersonDetailsEntity;

  GetPopularPersonImagesParameters(this.popularPersonDetailsEntity);

  @override
  List<Object?> get props => [popularPersonDetailsEntity];
}
