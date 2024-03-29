import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:tmdb_app/core/error/exceptions.dart';
import 'package:tmdb_app/core/error/failure.dart';
import 'package:tmdb_app/core/network/network_info.dart';
import 'package:tmdb_app/core/services/injection.dart';
import 'package:tmdb_app/features/popular_person_details/data/data_source/local/popular_person_details_LDS.dart';
import 'package:tmdb_app/features/popular_person_details/data/data_source/remote/popular_person_details_RDS.dart';
import 'package:tmdb_app/features/popular_person_details/data/models/movie_credits.dart';
import 'package:tmdb_app/features/popular_person_details/data/models/other_images.dart';
import 'package:tmdb_app/features/popular_person_details/data/models/popular_person_details.dart';
import 'package:tmdb_app/features/popular_person_details/data/models/tv_credits.dart';
import 'package:tmdb_app/features/popular_person_details/domain/entities/cast_entity.dart';
import 'package:tmdb_app/features/popular_person_details/domain/entities/popular_person_details_entity.dart';
import 'package:tmdb_app/features/popular_person_details/domain/repository/popular_person_details_repo.dart';

@LazySingleton(as: PopularPersonDetailsRepo)
class PopularPersonDetailsRepoImpl implements PopularPersonDetailsRepo {
  @override
  Either<Failure, PopularPersonDetailsEntity?> getLocalPopularPersonDetails(
      int personId) {
    try {
      final result = getIt<PopularPersonDetailsLocalDataSource>()
          .getLocalPopularPersonDetails(personId);
      return Right(result!);
    } on LocalDatabaseException catch (failure) {
      return Left(Failure(failureMessage: failure.errorMessage ?? ""));
    }
  }

  @override
  Future<Either<Failure, PopularPersonDetailsEntity?>> getPopularPersonDetails(
      int personId) async {
    debugPrint("PopularPersonDetailsRepoImpl");
    final bool isConnected = await getIt<NetworkInfo>().isConnected;
    if (isConnected) {
      try {
        final PopularPersonDetails? result =
            await getIt<PopularPersonDetailsRemoteDataSource>()
                .getPopularPersonDetails(personId);
        debugPrint("PopularPersonDetailsRepoImpl Right $result");
        return Right(result!.toDomain());
      } catch (e) {
        debugPrint("PopularPersonDetailsRepoImpl Failure ${e.toString()}");
        return Left(Failure(failureMessage: e.toString()));
      }
    }
    debugPrint("PopularPersonsRepoImpl No Internet Connection");
    return Left(Failure(failureMessage: "No Internet Connection"));
  }

  @override
  Future storePopularPersonDetails(
      PopularPersonDetailsEntity popularPersonDetailsEntity) async {
    debugPrint("repo impl storeAllPopularPersons $PopularPersonDetailsEntity");
    await getIt<PopularPersonDetailsLocalDataSource>()
        .storePopularPersonDetails(popularPersonDetailsEntity);
  }

  @override
  Future<Either<Failure, PopularPersonDetailsEntity?>> getPopularPersonImages(
      PopularPersonDetailsEntity popularPersonDetailsEntity) async {
    debugPrint("PopularPersonDetailsRepoImpl getPopularPersonImages");
    final bool isConnected = await getIt<NetworkInfo>().isConnected;
    if (isConnected) {
      try {
        final OtherImages? result =
            await getIt<PopularPersonDetailsRemoteDataSource>()
                .getPopularPersonImages(popularPersonDetailsEntity.id!);
        PopularPersonDetailsEntity newPopularPersonDetailsEntity =
            popularPersonDetailsEntity.copyWith(
          images: result!.profiles!.map((e) => e.filePath ?? "").toList(),
        );
        debugPrint("PopularPersonDetailsRepoImpl Right $result");
        return Right(newPopularPersonDetailsEntity);
      } catch (e) {
        debugPrint("PopularPersonDetailsRepoImpl Failure ${e.toString()}");
        return Left(Failure(failureMessage: e.toString()));
      }
    }
    debugPrint("PopularPersonsRepoImpl No Internet Connection");
    return Left(Failure(failureMessage: "No Internet Connection"));
  }

  @override
  Future<Either<Failure, PopularPersonDetailsEntity?>> getPopularPersonMovies(
      PopularPersonDetailsEntity popularPersonDetailsEntity) async {
    debugPrint("PopularPersonDetailsRepoImpl getPopularPersonMovies");
    final bool isConnected = await getIt<NetworkInfo>().isConnected;
    if (isConnected) {
      try {
        final MovieCredits? result =
            await getIt<PopularPersonDetailsRemoteDataSource>()
                .getPopularPersonMovies(popularPersonDetailsEntity.id!);
        PopularPersonDetailsEntity newPopularPersonDetailsEntity =
            popularPersonDetailsEntity.copyWith(
          movieCreditCasts: result!.cast!
              .map((e) => CastEntity(
                    name: '',
                    title: e.title,
                    posterPath: e.posterPath,
                    backdropPath: e.backdropPath,
                    voteAverage: e.voteAverage,
                    voteCount: e.voteCount,
                  ))
              .toList(),
        );
        debugPrint("PopularPersonDetailsRepoImpl Right $result");
        return Right(newPopularPersonDetailsEntity);
      } catch (e) {
        debugPrint("PopularPersonDetailsRepoImpl Failure ${e.toString()}");
        return Left(Failure(failureMessage: e.toString()));
      }
    }
    debugPrint("PopularPersonsRepoImpl No Internet Connection");
    return Left(Failure(failureMessage: "No Internet Connection"));
  }

  @override
  Future<Either<Failure, PopularPersonDetailsEntity?>> getPopularPersonTVShows(
      PopularPersonDetailsEntity popularPersonDetailsEntity) async {
    debugPrint("PopularPersonDetailsRepoImpl getPopularPersonTVShows");
    final bool isConnected = await getIt<NetworkInfo>().isConnected;
    if (isConnected) {
      try {
        final TVCredits? result =
            await getIt<PopularPersonDetailsRemoteDataSource>()
                .getPopularPersonTVShows(popularPersonDetailsEntity.id!);
        PopularPersonDetailsEntity newPopularPersonDetailsEntity =
            popularPersonDetailsEntity.copyWith(
          tvCreditCasts: result!.cast!
              .map((e) => CastEntity(
                    name: e.name,
                    title: "",
                    posterPath: e.posterPath,
                    backdropPath: e.backdropPath,
                    voteAverage: e.voteAverage,
                    voteCount: e.voteCount,
                  ))
              .toList(),
        );
        debugPrint("PopularPersonDetailsRepoImpl Right $result");
        return Right(newPopularPersonDetailsEntity);
      } catch (e) {
        debugPrint("PopularPersonDetailsRepoImpl Failure ${e.toString()}");
        return Left(Failure(failureMessage: e.toString()));
      }
    }
    debugPrint("PopularPersonsRepoImpl No Internet Connection");
    return Left(Failure(failureMessage: "No Internet Connection"));
  }
}
