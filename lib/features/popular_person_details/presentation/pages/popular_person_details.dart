import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_app/core/services/services_locator.dart';
import 'package:tmdb_app/core/utils/app_strings.dart';
import 'package:tmdb_app/core/utils/enums.dart';
import 'package:tmdb_app/features/popular_person_details/data/models/popular_person_details.dart';
import 'package:tmdb_app/features/popular_person_details/domain/usecases/get_local_popular_person_details_usecase.dart';
import 'package:tmdb_app/features/popular_person_details/domain/usecases/get_popular_person_details_usecase.dart';
import 'package:tmdb_app/features/popular_person_details/domain/usecases/store_popular_person_details_usecase.dart';
import 'package:tmdb_app/features/popular_person_details/presentation/bloc/popular_person_details_bloc.dart';
import 'package:tmdb_app/features/popular_person_details/presentation/widgets/details.dart';
import 'package:tmdb_app/features/popular_persons/presentation/bloc/popular_persons_bloc.dart';
import 'package:tmdb_app/features/popular_persons/presentation/widgets/error_message_widget.dart';

class PopularPersonsDetailsScreen extends StatelessWidget {
  final int personId;
  final String name;

  const PopularPersonsDetailsScreen(
      {Key? key, required this.personId, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late PopularPersonDetailsBloc popularPersonDetailsBloc;
    Widget getBodyWidget(PopularPersonDetailsState state) {
      switch (state.requestState) {
        case RequestState.error:
          return ErrorMessageWidget(
              btnText: "Retry",
              textStr:
                  'Error: Cannot Get Popular Persons \n${state.errorMessage}',
              onPressed: () {
                popularPersonDetailsBloc
                    .add(GetPopularPersonDetails(personId: personId));
              });
        case RequestState.loaded:
          if (state.popularPersonDetailsEntity == null) {
            return ErrorMessageWidget(
                btnText: "Refresh",
                textStr: 'No Popular Person Found',
                onPressed: () {
                  popularPersonDetailsBloc
                      .add(GetPopularPersonDetails(personId: personId));
                });
          }
          return Details(
              popularPersonDetailsEntity: state.popularPersonDetailsEntity!);
        case RequestState.loading:
          return const Center(child: CircularProgressIndicator());
      }
    }

    return BlocProvider<PopularPersonDetailsBloc>(
        create: (context) => PopularPersonDetailsBloc(
            sl<GetPopularPersonDetailsUseCase>(),
            sl<StorePopularPersonDetailsUseCase>(),
            sl<GetLocalPopularPersonDetailsUseCase>())
          ..add(GetPopularPersonDetails(personId: personId)),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppStrings.personInfoScreenTitle(name),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          body:
              BlocConsumer<PopularPersonDetailsBloc, PopularPersonDetailsState>(
                  buildWhen: (previousState, nextState) =>
                      previousState.requestState != nextState.requestState,
                  listener: (context, state) async {
                    if (state.requestState == RequestState.error) {
                      if (state.dataSource == DataSource.remote) {
                        popularPersonDetailsBloc
                            .add(GetLocalPopularPersonDetails(personId: personId));
                      }
                    }
                  },
                  builder: (context, state) {
                    popularPersonDetailsBloc =
                        BlocProvider.of<PopularPersonDetailsBloc>(context);
                    return getBodyWidget(state);
                  }),
        ));
  }
}
