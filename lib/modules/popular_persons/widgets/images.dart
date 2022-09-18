import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_app/models/popular_person/popular_person.dart';
import 'package:tmdb_app/shared/navigation.dart';

class PopularPersonImagesWidget extends StatelessWidget {
  final OtherImages? images;
  const PopularPersonImagesWidget({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        (context, index) => GestureDetector(
          onTap: () {

          },
          child: Container(
            margin: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl:
                    "https://image.tmdb.org/t/p/w500${images?.profiles?[index].filePath}",
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        childCount: images?.profiles?.length ?? 0,
      ),
    );
  }
}