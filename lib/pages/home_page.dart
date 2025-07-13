import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/utilities/movie_provider.dart';
import 'package:movieapp/widgets/caraousel.dart';
import 'package:movieapp/widgets/search_button.dart';
import 'package:provider/provider.dart';
import 'package:movieapp/widgets/movie_row.dart';
import 'package:movieapp/widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Call API on startup
    Future.microtask(() {
      Provider.of<MovieProviderModel>(context, listen: false).getMovieData();
      Provider.of<MovieProviderModel>(context, listen: false).getTrendingPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final movieprovider = Provider.of<MovieProviderModel>(context);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 0.8,
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  const Color.fromARGB(255, 47, 18, 91), // deep purple
                  // magenta
                ],
              ),
            ),
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Image.asset(
                        "assets/transparent_logo.png",
                        height: 40,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // margin: EdgeInsets.only(right: 10),
                        child: SearchButton(),
                      ),
                    ),
                  ],
                ),

                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Center(
                    child: Text(
                      "Now Playing",
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Caraousel(),
                MovieRow(category: "top_rated"),
                MovieRow(category: "popular"),
                MovieRow(category: "now_playing"),
                MovieRow(category: "upcoming"),
              ],
            ),
          ),
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
                  // margin: EdgeInsets.symmetric(horizontal: 70),
                  child: const BottomNavBar(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
