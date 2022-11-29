import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_app/features/popular_person_details/data/models/popular_person_details.dart';
import 'package:tmdb_app/features/popular_persons/data/models/popular_person/popular_person.dart';
import 'package:tmdb_app/features/popular_persons/presentation/widgets/error_message_widget.dart';
import 'package:tmdb_app/features/popular_person_details/cubit/cubit.dart';
import 'package:tmdb_app/features/popular_person_details/cubit/states.dart';
import 'package:tmdb_app/features/popular_person_details/widgets/details.dart';

class PopularPersonsDetailsScreen extends StatefulWidget {
  final int popularPersonId;
  const PopularPersonsDetailsScreen({Key? key,
    this.popularPersonId=-1}) : super(key: key);

  @override
  State<PopularPersonsDetailsScreen> createState() => _PopularPersonsDetailsScreenState();
}

class _PopularPersonsDetailsScreenState extends State<PopularPersonsDetailsScreen> {

  late PopularPersonDetailsCubit popularPersonDetailsCubit;

  bool? isSuccess;
  String errorStr = "";

  PopularPersonDetails? popularPersonDetails;

  @override
  Widget build(BuildContext context) {

    Widget getBodyWidget(){
      if(popularPersonDetailsCubit.loadingDetails){
        return const Center(child: CircularProgressIndicator());
      }
      else if(!(isSuccess!) || popularPersonDetails==null){
        return ErrorMessageWidget(
            textStr: 'Error: Cannot get Person Details \n$errorStr',
            btnText: 'Retry',
            onPressed: popularPersonDetailsCubit.getPopularPersonDetail(widget.popularPersonId));
      }else{
        return Details(popularPersonDetails: popularPersonDetails!);
      }
    }


    return BlocProvider<PopularPersonDetailsCubit>(
        create: (context) => PopularPersonDetailsCubit()
          ..getPopularPersonDetail(widget.popularPersonId),
        child: BlocConsumer<PopularPersonDetailsCubit, PopularPersonDetailsStates>(
            listener: (context, state) async {

              if(state is PopularPersonDetailsError){
                isSuccess = false;
                errorStr = state.error;
              }

              if(state is PopularPersonDetailsSuccess){
                isSuccess = true;
                popularPersonDetails = state.popularPersonDetails;
              }

            },builder: (context, state){

          popularPersonDetailsCubit = BlocProvider.of<PopularPersonDetailsCubit>(context);
          return Scaffold(
              body: getBodyWidget(),
            );
          }));
  }
}



