import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/utilities/movie_provider.dart';
import 'package:provider/provider.dart';

class Caraousel extends StatefulWidget {
  const Caraousel({super.key});

  @override
  State<Caraousel> createState() => _CaraouselState();
}

class _CaraouselState extends State<Caraousel> {
  @override
  Widget build(BuildContext context) {
    final movieprovider = Provider.of<MovieProviderModel>(context);

    List results = [];

    final nowPlayingData = movieprovider.data['now_playing'];
    print("Type of nowPlayingData = ${nowPlayingData.runtimeType}");

    if (nowPlayingData != null &&
        nowPlayingData is Map &&
        nowPlayingData['results'] is List) {
      results = nowPlayingData['results'];
    }

    if (results.isEmpty) {
      return const SizedBox(
        height: 500,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return const Padding(padding: EdgeInsets.all(10), child: _CarouselBody());
  }
}

// ⬇️ Separated widget so we can use const on the Padding above
class _CarouselBody extends StatelessWidget {
  const _CarouselBody({super.key});

  @override
  Widget build(BuildContext context) {
    final movieprovider = Provider.of<MovieProviderModel>(context);
    final results = movieprovider.data['now_playing']['results'];

    return SizedBox(
      height: 500,
      child: CarouselView.weighted(
        onTap: (index) {
          Navigator.pushNamed(context, "/movie_about_page.dart");
          Future.microtask(() {
            movieprovider.getMovieTitle(
              "now_playing",
              results[index]['poster_path'],
            );
          });
        },
        flexWeights: const [1, 5, 1],
        children: List.generate(results.length, (index) {
          return CachedNetworkImage(
            imageUrl:
                "https://image.tmdb.org/t/p/w500${results[index]['poster_path']}",
            fit: BoxFit.cover,
            placeholder:
                (context, url) => Container(
                  color: Colors.grey[800],
                  child: const Center(child: CircularProgressIndicator()),
                ),
            errorWidget:
                (context, url, error) => Container(
                  color: Colors.grey[800],
                  child: const Icon(Icons.error, color: Colors.red),
                ),
          );
        }),
      ),
    );
  }
}
