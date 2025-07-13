import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/utilities/movie_provider.dart';
import 'package:provider/provider.dart';

class MovieRow extends StatefulWidget {
  final String category;
  const MovieRow({super.key, required this.category});

  @override
  State<MovieRow> createState() => _MovieRowState();
}

class _MovieRowState extends State<MovieRow> {
  @override
  Widget build(BuildContext context) {
    final movieprovider = Provider.of<MovieProviderModel>(context);
    final posters = movieprovider.moviePoster[widget.category] ?? [];
    final Map rowCategory = {
      "top_rated": "Top Rated",
      "popular": "Popular",
      "now_playing": "In Theatres",
      "upcoming": "Upcoming",
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Text(
            rowCategory[widget.category],
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          height: 250,
          margin: const EdgeInsets.only(bottom: 20),

          child:
              posters.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: posters.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          movieprovider.getMovieTitle(
                            widget.category,
                            posters[index],
                          );

                          Future.microtask(() {
                            Navigator.pushNamed(
                              context,
                              "/movie_about_page.dart",
                            );
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://image.tmdb.org/t/p/w500${posters[index]}",
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
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
