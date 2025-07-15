import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/widgets/search_button.dart';
import 'package:provider/provider.dart';
import 'package:movieapp/utilities/movie_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final movieprovider = Provider.of<MovieProviderModel>(context);

    print("LIST LENGTH  = ${movieprovider.searchedMovie.length}");

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      extendBody: true,
      body: Column(
        children: [
          PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                movieprovider.tvShowButton = false;
                movieprovider.mycontroller.clear();
              }
            },
            child: Container(
              // color: Colors.amber,
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(34, 255, 255, 255),
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_rounded),
                          iconSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(child: const SearchButton()),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10, bottom: 10),
                        decoration:
                            movieprovider.tvShowButton
                                ? BoxDecoration(
                                  color: const Color.fromARGB(
                                    34,
                                    255,
                                    255,
                                    255,
                                  ),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                )
                                : BoxDecoration(
                                  color: Colors.deepPurpleAccent,

                                  borderRadius: BorderRadius.circular(40),
                                ),
                        child: TextButton(
                          onPressed: () {
                            // movieprovider.tvShowButton = false;
                            movieprovider.tvShowButton =
                                false; // ✅ switch to movies view
                            movieprovider.searchMovie(
                              movieprovider.mycontroller.text,
                            );
                          },
                          child: Text(
                            "Movies",
                            style: GoogleFonts.nunito(color: Colors.white),
                          ),
                        ),
                      ), //tvshows down
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration:
                            movieprovider.tvShowButton
                                ? BoxDecoration(
                                  color: Colors.deepPurpleAccent,

                                  borderRadius: BorderRadius.circular(40),
                                )
                                : BoxDecoration(
                                  color: const Color.fromARGB(
                                    34,
                                    255,
                                    255,
                                    255,
                                  ),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),

                                  borderRadius: BorderRadius.circular(40),
                                ),
                        child: TextButton(
                          onPressed: () {
                            movieprovider.tvShowButton =
                                true; // ✅ switch to tv show view
                            movieprovider.searchedShow(
                              movieprovider.mycontroller.text,
                            );
                          },
                          child: Text(
                            "Tv shows",
                            style: GoogleFonts.nunito(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                movieprovider.tvShowButton == false
                    ? movieprovider.movieFound == null
                        ? const Center(child: CircularProgressIndicator())
                        : movieprovider.movieFound == false
                        ? Center(
                          child: Text(
                            "No movie found",
                            style: GoogleFonts.nunito(color: Colors.white),
                          ),
                        )
                        : ListView.builder(
                          itemCount:
                              movieprovider.movieFound == true
                                  ? movieprovider.searchedMovie.length
                                  : 0,
                          itemBuilder: (BuildContext context, int index) {
                            return movieprovider.movieFound ?? false
                                ? GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/movie_about_page.dart",
                                    );

                                    Future.microtask(() {
                                      movieprovider.onClickMovie = Map.from(
                                        movieprovider.searchedMovie[index],
                                      );
                                      movieprovider.onClickMovie['type'] =
                                          'movie';
                                      movieprovider.convertGenre(
                                        movieprovider
                                            .searchedMovie[index]['genre_ids'],
                                      );
                                      movieprovider.seeDuplicacy();
                                      movieprovider.getWatchprovider(
                                        movieprovider.onClickMovie['id'],
                                      );
                                    });
                                  },
                                  child: Container(
                                    height: 130,
                                    margin: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color.fromARGB(31, 96, 0, 0),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: Container(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://image.tmdb.org/t/p/w500${movieprovider.searchedMovie[index]['poster_path']}",
                                              height: 130,
                                              width: 100,
                                              fit: BoxFit.cover,
                                              placeholder:
                                                  (context, url) => Container(
                                                    color: Colors.grey[800],
                                                    child: const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                        color: Colors.grey[800],
                                                        child: const Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 20,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  maxLines: 2,
                                                  "${movieprovider.searchedMovie[index]['title']}",
                                                  style: GoogleFonts.nunito(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 9),
                                                Text(
                                                  maxLines: 3,
                                                  "${movieprovider.searchedMovie[index]['overview']}",
                                                  style: GoogleFonts.nunito(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    textStyle: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : Center(child: Text("No movie found"));
                          },
                        )
                    : movieprovider.tvShowFound == null
                    ? const Center(child: CircularProgressIndicator())
                    : movieprovider.tvShowFound == false
                    ? Center(
                      child: Text(
                        "No tv show found",
                        style: GoogleFonts.nunito(color: Colors.white),
                      ),
                    )
                    : ListView.builder(
                      itemCount:
                          movieprovider.tvShowFound == true
                              ? movieprovider.searchedTvShow.length
                              : 0,
                      itemBuilder: (BuildContext context, int index) {
                        return movieprovider.tvShowFound ?? false
                            ? GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  "/movie_about_page.dart",
                                );

                                Future.microtask(() {
                                  movieprovider.onClickMovie = Map.from(
                                    movieprovider.searchedTvShow[index],
                                  );
                                  movieprovider.onClickMovie['title'] =
                                      movieprovider
                                          .searchedTvShow[index]['name'];
                                  movieprovider.onClickMovie['type'] = 'series';
                                  movieprovider.convertGenre(
                                    movieprovider
                                        .searchedTvShow[index]['genre_ids'],
                                  );
                                  movieprovider.seeDuplicacy();
                                  movieprovider.getWatchprovider(
                                    movieprovider.onClickMovie['id'],
                                  );
                                });
                              },
                              child: Container(
                                height: 130,
                                margin: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color.fromARGB(31, 96, 0, 0),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://image.tmdb.org/t/p/w500${movieprovider.searchedTvShow[index]['poster_path']}",
                                          height: 130,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => Container(
                                                color: Colors.grey[800],
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  Container(
                                                    color: Colors.grey[800],
                                                    child: const Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              maxLines: 2,
                                              "${movieprovider.searchedTvShow[index]['name']}",
                                              style: GoogleFonts.nunito(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 9),
                                            Text(
                                              maxLines: 3,
                                              "${movieprovider.searchedTvShow[index]['overview']}",
                                              style: GoogleFonts.nunito(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                textStyle: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            : Center(child: Text("No tv show found"));
                      },
                    ),
              ],
            ),
          ),
        ],
      ),
      // : Center(child: Text("No movies found")),
    );
  }
}
