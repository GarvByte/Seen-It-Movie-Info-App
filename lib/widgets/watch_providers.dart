import 'package:flutter/material.dart';
import 'package:movieapp/utilities/movie_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class WatchProviders extends StatefulWidget {
  const WatchProviders({super.key});

  @override
  State<WatchProviders> createState() => _WatchProvidersState();
}

class _WatchProvidersState extends State<WatchProviders> {
  @override
  Widget build(BuildContext context) {
    final movieprovider = Provider.of<MovieProviderModel>(context);
    final watchProvider = movieprovider.onClickMovie['watchProvider'];

    if (watchProvider == null) {
      return const CircularProgressIndicator();
    } else if (watchProvider.isEmpty) {
      return const Text("No providers in India");
    }

    return Column(
      children: List.generate(
        movieprovider.onClickMovie['watchProvider'].length,
        (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 36, 10, 0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(30),
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://image.tmdb.org/t/p/w500${movieprovider.onClickMovie['watchProvider'][index]['logo_path']}",
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorWidget:
                        (context, url, error) => Container(
                          color: Colors.grey[800],
                          child: Center(
                            child: const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    movieprovider
                        .onClickMovie['watchProvider'][index]['provider_name'],
                    style: GoogleFonts.nunito(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
