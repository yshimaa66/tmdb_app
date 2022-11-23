import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_app/features/popular_person_details/widgets/about.dart';
import 'package:tmdb_app/features/popular_person_details/widgets/credit.dart';
import 'package:tmdb_app/features/popular_person_details/widgets/images.dart';
import 'package:tmdb_app/features/popular_person_details/widgets/sliver_app_bar_delegate.dart';
import 'package:tmdb_app/features/popular_person_details/widgets/text_container.dart';
import 'package:tmdb_app/features/popular_persons/data/models/popular_person/popular_person.dart';
import 'package:tmdb_app/utilities/index.dart';

class Details extends StatelessWidget {
  final PopularPerson popularPerson;
  const Details({Key? key, required this.popularPerson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 280.0,
              floating: false,
              pinned: true,
              title: Text("${popularPerson.name}"),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12,
                              spreadRadius: 0.5),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.black.withOpacity(1),
                          ],
                          begin: Alignment.center,
                          stops: const [0, 1],
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 120,
                              width: 120,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                  "https://image.tmdb.org/t/p/w500${popularPerson.profilePath}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${popularPerson.name}",
                              style: customTextStyleTitle.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomTextContainer(
                                  text: "${popularPerson.knownForDepartment}",
                                  textColor: Theme.of(context).primaryColor,
                                ),
                                // const SizedBox(width: 8),
                                CustomTextContainer(
                                  text: "${popularPerson.popularity} Known Credits",
                                  textColor: Colors.white54,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
              ),
            ),
            SliverPersistentHeader(
              delegate: SliverAppBarDelegate(
                TabBar(
                    labelColor: Theme.of(context).textTheme.bodyText1?.color,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w800),
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Theme.of(context).backgroundColor,
                    indicatorWeight: 10,
                    isScrollable: true,
                    tabs: const [
                      Tab(text: "About"),
                      Tab(text: "Images"),
                      Tab(text: "Movies"),
                      Tab(text: "TV Shows"),
                    ],
                  ),
                ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          children: [
            AboutWidget(popularPerson: popularPerson),
            ImagesWidget(images: popularPerson.otherImages),
            CreditWidget(casts: popularPerson.movieCasts),
            CreditWidget(casts: popularPerson.tvCasts),
          ],
        ),
      ),
    );
  }
}
