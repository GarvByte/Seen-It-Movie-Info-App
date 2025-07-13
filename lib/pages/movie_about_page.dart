import 'package:flutter/material.dart';
import 'package:movieapp/utilities/movie_provider.dart';
import 'package:movieapp/widgets/watch_providers.dart';
import 'package:movieapp/widgets/watchlist_button.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/widgets/genre.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieAboutPage extends StatefulWidget {
  const MovieAboutPage({super.key});

  @override
  State<MovieAboutPage> createState() => _MovieAboutPageState();
}

class _MovieAboutPageState extends State<MovieAboutPage> {
  @override
  Widget build(BuildContext context) {
    final movieprovider = Provider.of<MovieProviderModel>(context);

    return Scaffold(
      bottomNavigationBar: const WatchlistButton(),
      backgroundColor: Colors.black,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl:
                      "https://image.tmdb.org/t/p/w500${movieprovider.onClickMovie['backdrop_path']}",
                  fit: BoxFit.cover,
                  height: 200,
                  placeholder:
                      (context, url) => Container(
                        color: Colors.grey[800],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(88, 255, 255, 255),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        movieprovider.onClickMovie['title'],
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: Icon(
                              Icons.star,
                              color: Colors.amberAccent,
                              size: 22,
                            ),
                          ),
                          Text(
                            "${movieprovider.onClickMovie['vote_average']}/10",
                            style: GoogleFonts.nunito(
                              color: const Color.fromARGB(255, 213, 213, 213),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 6,
                      ),
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 36, 10, 0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (movieprovider.onClickMovie['adult_movie'] ?? false)
                            ? "18+"
                            : "NA",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 222, 222, 222),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(child: Genre()),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "About",
                    style: GoogleFonts.nunito(
                      color: const Color.fromARGB(255, 134, 91, 255),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Wrap(
                  children: [
                    Text(
                      movieprovider.onClickMovie['overview'],
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Watch Providers",
                    style: GoogleFonts.nunito(
                      color: const Color.fromARGB(255, 134, 91, 255),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const WatchProviders(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
