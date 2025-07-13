import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/utilities/movie_provider.dart';
import 'package:provider/provider.dart';

class Genre extends StatefulWidget {
  const Genre({super.key});

  @override
  State<Genre> createState() => _GenreState();
}

class _GenreState extends State<Genre> {
  @override
  Widget build(BuildContext context) {
    final movieprovider = Provider.of<MovieProviderModel>(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:
            movieprovider.onClickMovie['genre_ids'] == null
                ? 0
                : movieprovider.onClickMovie['genre_ids'].length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 36, 10, 0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${movieprovider.onClickMovie['genre_ids'][index]}",
              style: GoogleFonts.nunito(
                color: const Color.fromARGB(255, 222, 222, 222),
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }
}
