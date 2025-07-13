import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/utilities/movie_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class WatchlistMovies extends StatefulWidget {
  const WatchlistMovies({super.key});

  @override
  State<WatchlistMovies> createState() => _WatchlistMoviesState();
}

class _WatchlistMoviesState extends State<WatchlistMovies> {
  @override
  Widget build(BuildContext context) {
    final movieprovider = Provider.of<MovieProviderModel>(context);
    final watchlistMovie = movieprovider.box.values.toList();

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: movieprovider.box.keys.length,
      itemBuilder: (BuildContext context, int index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: GestureDetector(
              onTap: () {
                final movie = watchlistMovie[index];
                movieprovider.onClickMovie = Map.from(movie);
                movieprovider.inWatchlist = true;
                // movieprovider.getWatchprovider(movieprovider.onClickMovie['id']);
                Navigator.pushNamed(context, "/movie_about_page.dart");
              },
              child: Container(
                height: 130,
                margin: const EdgeInsets.all(20),
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
                              "https://image.tmdb.org/t/p/w500${watchlistMovie[index]['poster_path']}",
                          height: 130,
                          width: 100,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                color: Colors.grey[800],
                                child: const Center(
                                  child: CircularProgressIndicator(),
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
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              maxLines: 2,
                              "${watchlistMovie[index]['title']}",
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 9),
                            Text(
                              maxLines: 3,
                              "${watchlistMovie[index]['overview']}",
                              style: GoogleFonts.nunito(
                                color: Colors.grey,
                                fontSize: 12,
                                textStyle: TextStyle(
                                  overflow: TextOverflow.ellipsis,
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
            ),
          ),
        );
      },
    );
  }
}
