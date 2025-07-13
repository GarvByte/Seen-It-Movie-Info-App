import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/widgets/bottom_nav_bar.dart';
import 'package:movieapp/widgets/watchlist_movies.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:movieapp/utilities/movie_provider.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  @override
  @override
  Widget build(BuildContext context) {
    @override
    final movieprovider = Provider.of<MovieProviderModel>(context);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            radius: 0.8,
            colors: [
              Color.fromARGB(255, 0, 0, 0), //black
              Color.fromARGB(255, 47, 18, 91), //  purple
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  "BINGE WATCH TIME",
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  movieprovider.box.isEmpty
                      ? Center(
                        child: Text(
                          "Currently no movies in your watchlist",
                          style: GoogleFonts.nunito(color: Colors.white),
                        ),
                      )
                      : Container(child: const WatchlistMovies()),
                  Positioned(
                    bottom: 30,
                    left: 80,
                    right: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
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
    );
  }
}
