import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/utilities/movie_provider.dart';
import 'package:provider/provider.dart';

class SearchButton extends StatefulWidget {
  const SearchButton({super.key});

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  // TextEditingController mycontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final movieprovider = Provider.of<MovieProviderModel>(context);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(34, 255, 255, 255),
          borderRadius: BorderRadius.circular(40),
        ),
        child: TextField(
          controller: movieprovider.mycontroller,
          cursorColor: Colors.white,
          style: GoogleFonts.nunito(color: Colors.white),
          onSubmitted: (value) {
            movieprovider.searchMovie(movieprovider.mycontroller.text);
            FocusScope.of(context).unfocus();

            final currentRoute = ModalRoute.of(context)?.settings.name;

            if (currentRoute != "/search_page.dart") {
              Navigator.pushNamed(context, "/search_page.dart");
            } else {
              Navigator.pushReplacementNamed(context, "/search_page.dart");
            }

            movieprovider.selectedIndex = 2;
          },
          decoration: InputDecoration(
            hintText: "Search movies",
            hintStyle: TextStyle(
              color: const Color.fromARGB(255, 193, 193, 193),
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 15, right: 5),
              child: Icon(
                Icons.search_sharp,
                color: Color.fromARGB(255, 193, 193, 193),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
