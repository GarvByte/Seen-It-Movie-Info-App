import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

class MovieProviderModel extends ChangeNotifier {
  final apiKey = "8640f2ca8cdabbe1b782b22430016f97";
  final authToken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4NjQwZjJjYThjZGFiYmUxYjc4MmIyMjQzMDAxNmY5NyIsIm5iZiI6MTc1MTUzNjIyNC4xNjUsInN1YiI6IjY4NjY1MjYwM2FmMzA0YTM0MjMxZjk4MyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0rcPNVHiKsTYuF1Npgk10SQEhTdmyNolb298EoKF8NY";
  final box = Hive.box('hiveBox');
  int selectedIndex = 0;
  TextEditingController mycontroller = TextEditingController();

  Map<String, List<String>> moviePoster = {
    'top_rated': [],
    'popular': [],
    'now_playing': [],
    'upcoming': [],
  };

  final List<String> urls = [
    "https://api.themoviedb.org/3/movie/top_rated?page=1",
    "https://api.themoviedb.org/3/movie/popular?page=1",
    "https://api.themoviedb.org/3/movie/now_playing?page=1",
    "https://api.themoviedb.org/3/movie/upcoming?page=1",
    // "https://api.themoviedb.org/3/trending/movie/day?language=en-US",
  ];

  final List<String> categories = [
    'top_rated',
    'popular',
    'now_playing',
    'upcoming',
    // 'trending',
  ];

  Map<String, dynamic> data = {
    'top_rated': {},
    'popular': {},
    'now_playing': {},
    'upcoming': {},
    // 'trending': {},
  };

  Map onClickMovie = {
    'genre_ids': <dynamic>[],
    'overview': 'Loading',
    'backdrop_path': 'Loading image',
    'title': 'Loading',
    'vote_average': 0,
    'adultMovie': false,
    'poster_path': 'Laoding image',
    'id': 00000000,
    'watchProvider': null,
  };

  List searchedMovie = [];
  List trending = [];
  bool? movieFound;
  bool? inWatchlist;

  Future<void> getMovieData() async {
    print("now_playing data = ${data['now_playing'].runtimeType}");
    print(
      "now_playing results = ${data['now_playing']['results'].runtimeType}",
    );
    for (var i = 0; i < categories.length; i++) {
      final response = await http.get(
        Uri.parse(urls[i]),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      final decoded = json.decode(response.body);
      data[categories[i]] = decoded;
      // final movieData = json.decode(response.body);
      // var results = movieData['results'];
      var results = data["${categories[i]}"]['results'];

      // print("status code of getmoviedata ${response.statusCode}");

      for (var item in results) {
        final path = item['poster_path'];
        if (path != null) {
          moviePoster[categories[i]]?.add(path);
        } else {
          print("value is null");
        }
      }
    }

    notifyListeners();
  }

  void getMovieTitle(category, posterpath) {
    // box.clear();
    // print("data = ${data['$category']['results']}");
    for (var item in data['$category']['results']) {
      // print("item = $item");
      if (item['poster_path'] == posterpath) {
        // print("iterm found");
        // print("Movie Name = ${item['original_title']}");

        onClickMovie['overview'] = item['overview'];
        onClickMovie['backdrop_path'] = item['backdrop_path'];
        onClickMovie['title'] = item['original_title'];
        onClickMovie['vote_average'] = item['vote_average'];
        onClickMovie['adult_movie'] = item['adult'];
        onClickMovie['poster_path'] = item['poster_path'];
        onClickMovie['id'] = item['id'];
        convertGenre(item['genre_ids']);
        getWatchprovider(onClickMovie['id']);
        // onClickMovie['genre_ids'] = (item['genre_ids']);
        seeDuplicacy();
      }
    }
    // print("OnclickMovie = $onClickMovie");
  }

  void addToWatchlist() {
    inWatchlist = true;
    notifyListeners(); // update UI *instantly*

    Future.delayed(Duration.zero, () {
      bool alreadyExists = false;
      for (int i = 0; i < box.length; i++) {
        final item = box.getAt(i);
        if (item['id'] == onClickMovie['id']) {
          alreadyExists = true;
          break;
        }
      }
      if (!alreadyExists) {
        box.add(Map.from(onClickMovie));
      }
    });
  }

  void deleteFromWatchlist() {
    for (int i = 0; i < box.length; i++) {
      final item = box.getAt(i);
      if (item['id'] == onClickMovie['id']) {
        final key = box.keyAt(i);
        print("Deleting movie '${item['title']}' with key: $key");
        box.delete(key);
        break;
      }
    }
    inWatchlist = false;
    notifyListeners();
  }

  void seeDuplicacy() {
    for (int i = 0; i < box.length; i++) {
      final item = box.getAt(i);
      if (item['id'] == onClickMovie['id']) {
        inWatchlist = true;
        return;
      }
    }
    inWatchlist = false;
    // onClickMovie['uniqueKey'] = '';
  }

  void toggleNavBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<void> searchMovie(name) async {
    final String searchUrl =
        "https://api.themoviedb.org/3/search/movie?query=$name&include_adult=false&language=en-US&page=1";
    final response = await http.get(
      Uri.parse(searchUrl),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    if (response.statusCode != 200) {
      print("We are having some problem getting your result");
    }
    if (response.statusCode == 200) {
      final searchedMovieData = json.decode(response.body);
      // print(" body = $searchedMovieData");
      if (searchedMovieData['total_results'] == 0) {
        print("No movie found");
        movieFound = false;
      } else {
        searchedMovie = searchedMovieData['results'];
        movieFound = true;
      }
    }
    // print("searched movie list = $searchedMovie and movifound = $movieFound");
    // print(
    //   "searched movie list status code  = ${response.statusCode} and name = $name",
    // );
    notifyListeners();
  }

  void convertGenre(List<dynamic> genreIds) {
    const genreNames = {
      28: "Action",
      12: "Adventure",
      16: "Animation",
      35: "Comedy",
      80: "Crime",
      99: "Documentary",
      18: "Drama",
      10751: "Family",
      14: "Fantasy",
      36: "History",
      27: "Horror",
      10402: "Music",
      9648: "Mystery",
      10749: "Romance",
      878: "Science Fiction",
      10770: "TV Movie",
      53: "Thriller",
      10752: "War",
      37: "Western",
    };

    List<String> genreLabels = [];

    for (var id in genreIds) {
      if (genreNames.containsKey(id)) {
        genreLabels.add(genreNames[id]!);
      }
    }

    onClickMovie['genre_ids'] = genreLabels;
  }

  Future<void> getTrendingPage() async {
    const trendingUrl = [
      "https://api.themoviedb.org/3/trending/movie/day?language=en-US",
      "https://api.themoviedb.org/3/trending/movie/day?page=2&language=en-US",
    ];
    for (var i = 0; i < trendingUrl.length; i++) {
      final response = await http.get(
        Uri.parse(trendingUrl[i]),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        print("CALLING getTrendingPage AGAIN");
        var decode = json.decode(response.body);
        trending.addAll(decode['results']);
      }
      if (response.statusCode != 200) {
        print("resposne statius  = ${response.statusCode}");
      }
    }
  }

  Future<void> getWatchprovider(id) async {
    try {
      onClickMovie['watchProvider'] = null;
      notifyListeners();
      final url = "https://api.themoviedb.org/3/movie/$id/watch/providers";
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final countryData = decoded['results']?["IN"];

        if (countryData != null && countryData['flatrate'] != null) {
          onClickMovie['watchProvider'] = countryData['flatrate'];
        } else {
          onClickMovie['watchProvider'] = [
            {
              'provider_name':
                  "Currently not available on any streaming platform in India",
            },
          ];
        }
      } else {
        print("Watch provider API error: ${response.statusCode}");
        onClickMovie['watchProvider'] = [];
      }
    } catch (e, stack) {
      print("Error getting watch provider: $e");
      print(stack);
      onClickMovie['watchProvider'] = [];
    }
    print("watchprovider data = ${onClickMovie['watchProvider']}");

    notifyListeners();
  }
}
