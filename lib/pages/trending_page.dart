import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/utilities/movie_provider.dart';
import 'package:movieapp/widgets/bottom_nav_bar.dart';
import 'package:movieapp/widgets/search_button.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  @override
  Widget build(BuildContext context) {
    @override
    final movieprovider = Provider.of<MovieProviderModel>(context);

    // print("list trending length= ${movieprovider.trending[0].lenth}");
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            radius: 0.9,
            colors: [
              Color.fromARGB(255, 47, 18, 91), // black
              Color.fromARGB(255, 0, 0, 0), // purple
            ],
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Image.asset("assets/transparent_logo.png", height: 40),
                  ),
                  Expanded(
                    child: Container(
                      
                      // margin: EdgeInsets.only(right: 10),
                      child: SearchButton(),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            child: Text(
                              "Trending",
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.6,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            // final movie =
                            //     movieprovider
                            //         .data['trending']['results'][index];
                            final movie = movieprovider.trending[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/movie_about_page.dart",
                                  );

                                  Future.microtask(() {
                                    movieprovider.onClickMovie = Map.from(
                                      movie,
                                    );
                                    movieprovider.convertGenre(
                                      movie['genre_ids'],
                                    );
                                    movieprovider.seeDuplicacy();
                                    movieprovider.getWatchprovider(movie['id']);
                                  });
                                  // print(
                                  //   "onclikmovie = ${movieprovider.onClickMovie}",
                                  // );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://image.tmdb.org/t/p/w500${movie['poster_path']}",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    placeholder:
                                        (context, url) => Container(
                                          color: Colors.grey[800],
                                          child: Center(
                                            child:
                                                const CircularProgressIndicator(),
                                          ),
                                        ),
                                    errorWidget:
                                        (context, url, error) => Container(
                                          color: Colors.grey[800],
                                          child: const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                            );
                          }, childCount: movieprovider.trending.length),
                        ),
                      ],
                    ),
                    // Bottom Navigation Bar
                    Positioned(
                      bottom: 30,
                      left: 80,
                      right: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: SizedBox(
                            width: 50,
                            child: const BottomNavBar(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
