import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/utilities/movie_provider.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  
  Widget build(BuildContext context) {
    final movieprovider = Provider.of<MovieProviderModel>(context);
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(40, 254, 254, 254),
      selectedItemColor: const Color.fromARGB(255, 134, 91, 255),
      unselectedItemColor: Colors.grey,
      currentIndex: movieprovider.selectedIndex,
      selectedLabelStyle: GoogleFonts.nunito(fontWeight: FontWeight.bold),
      unselectedLabelStyle: GoogleFonts.nunito(fontWeight: FontWeight.bold),

      onTap: (index) {
        if (movieprovider.selectedIndex != index) {
          movieprovider.toggleNavBar(index);
        }
        
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.movie_filter),
          label: "Watchlist",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
      ],
    );
  }
}
