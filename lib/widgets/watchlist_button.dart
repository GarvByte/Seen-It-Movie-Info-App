import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/utilities/movie_provider.dart';
import 'package:provider/provider.dart';

class WatchlistButton extends StatelessWidget {
  const WatchlistButton({super.key});

  @override
  Widget build(BuildContext context) {
    final movieprovider = Provider.of<MovieProviderModel>(context);

    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: double.infinity,
      decoration: BoxDecoration(shape: BoxShape.rectangle),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:  Colors.deepPurple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: () {
          
          movieprovider.inWatchlist ?? false 
              ? movieprovider.deleteFromWatchlist()
              : movieprovider.addToWatchlist();
              
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child:
              movieprovider.inWatchlist ?? false
                  ? Text(
                    "Delete from watchlist",
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
                  : Text(
                    "Add to watchlist",
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
        ),
      ),
    );
  }
}
