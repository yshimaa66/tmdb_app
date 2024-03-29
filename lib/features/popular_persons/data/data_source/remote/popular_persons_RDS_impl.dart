import 'package:injectable/injectable.dart';
import 'package:tmdb_app/core/API/api_consumer.dart';
import 'package:tmdb_app/core/API/end_points.dart';
import 'package:tmdb_app/features/popular_persons/data/data_source/remote/popular_persons_RDS.dart';
import 'package:tmdb_app/features/popular_persons/data/models/all_popular_persons/all_popular_persons.dart';

@LazySingleton(as: PopularPersonsRemoteDataSource)
class PopularPersonsRemoteDataSourceImpl
    implements PopularPersonsRemoteDataSource {
  final ApiConsumer apiConsumer;

  PopularPersonsRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<AllPopularPersons?> getAllPopularPersons({int page = 1}) async {
    Map<String, dynamic> result = Map<String, dynamic>.from(
      await apiConsumer.get(EndPoints.peopleUrl, queryParameters: {
        "page": page,
      }),
    );
    final AllPopularPersons popular = AllPopularPersons.fromJson(result);
    return popular;
  }
}
