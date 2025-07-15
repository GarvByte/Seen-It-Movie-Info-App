import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

class MovieProviderModel extends ChangeNotifier {
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
    "https://movie-backend-server.onrender.com/api/top-rated?page=1",
    "https://movie-backend-server.onrender.com/api/popular?page=1",
    "https://movie-backend-server.onrender.com/api/now_playing?page=1",
    "https://movie-backend-server.onrender.com/api/upcoming?page=1",
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
    'type': '',
  };

  List searchedMovie = [];
  List searchedTvShow = [];
  String lastMovieQuery = '';
  String lastTvShowQuery = '';
  List trending = [];
  bool tvShowButton = false;
  bool? tvShowFound;
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
        // headers: {
        //   'accept': 'application/json',
        //   'Authorization': 'Bearer $authToken',
        // },
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
        onClickMovie['type'] = 'movie';
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
        if (item['type'] == onClickMovie['type']) {
          if (item['id'] == onClickMovie['id']) {
            alreadyExists = true;
            break;
          }
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
      if (item['type'] == onClickMovie['type']) {
        if (item['id'] == onClickMovie['id']) {
          final key = box.keyAt(i);
          print("Deleting movie '${item['title']}' with key: $key");
          box.delete(key);
          break;
        }
      }
    }
    inWatchlist = false;
    notifyListeners();
  }

  void seeDuplicacy() {
    for (int i = 0; i < box.length; i++) {
      final item = box.getAt(i);
      if (item['type'] == onClickMovie['type']) {
        if (item['id'] == onClickMovie['id']) {
          inWatchlist = true;
          return;
        }
      }
    }
    inWatchlist = false;
    // onClickMovie['uniqueKey'] = '';
  }

  void toggleNavBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<void> searchMovie(String name) async {
    if (name.trim() == lastMovieQuery.trim()) {
      print("Skipping duplicate movie search for '$name'");
      movieFound = true;
      notifyListeners();
      return;
    }

    movieFound = null; // Show loading spinner
    notifyListeners();

    final String searchUrl =
        "https://movie-backend-server.onrender.com/api/search?query=$name";

    try {
      final response = await http.get(Uri.parse(searchUrl));
      if (response.statusCode == 200) {
        final searchedMovieData = json.decode(response.body);
        if (searchedMovieData['total_results'] == 0) {
          searchedMovie = [];
          movieFound = false;
        } else {
          searchedMovie = searchedMovieData['results'];
          movieFound = true;
          lastMovieQuery = name; // ✅ Update last query
        }
      } else {
        print("API error: ${response.statusCode}");
        movieFound = false;
      }
    } catch (e) {
      print("Error during movie search: $e");
      movieFound = false;
    }

    notifyListeners();
  }

  Future<void> searchedShow(String showName) async {
    if (showName.trim() == lastTvShowQuery.trim()) {
      print("Skipping duplicate TV show search for '$showName'");
      tvShowFound = true;
      notifyListeners();
      return;
    }

    tvShowFound = null;
    notifyListeners();

    final tvshowurl =
        'https://movie-backend-server.onrender.com/api/search/tv?query=$showName';

    try {
      final response = await http.get(Uri.parse(tvshowurl));
      if (response.statusCode == 200) {
        final searchedTvShowData = json.decode(response.body);
        if (searchedTvShowData['total_results'] == 0) {
          searchedTvShow = [];
          tvShowFound = false;
        } else {
          searchedTvShow = searchedTvShowData['results'];
          tvShowFound = true;
          lastTvShowQuery = showName;
          print(
            "watch provider tv shghow = ${searchedTvShowData['results']}",
          ); // ✅ Update last query
        }
      } else {
        print("API error: ${response.statusCode}");
        tvShowFound = false;
      }
    } catch (e) {
      print("Exception during TV show search: $e");
      tvShowFound = false;
    }

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
      "https://movie-backend-server.onrender.com/api/trending",
      "https://movie-backend-server.onrender.com/api/trending?page=2",
    ];
    for (var i = 0; i < trendingUrl.length; i++) {
      final response = await http.get(
        Uri.parse(trendingUrl[i]),
        // headers: {
        //   'accept': 'application/json',
        //   'Authorization': 'Bearer $authToken',
        // },
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
      final type = onClickMovie['type'];
      final url =
          type == "movie"
              ? "https://movie-backend-server.onrender.com/api/providers/$id"
              : "https://movie-backend-server.onrender.com/api/tv/providers/$id";

      final response = await http.get(Uri.parse(url));

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
