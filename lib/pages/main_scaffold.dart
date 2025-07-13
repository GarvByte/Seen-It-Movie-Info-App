import 'package:flutter/material.dart';
import 'package:movieapp/pages/home_page.dart';
import 'package:movieapp/pages/trending_page.dart';
import 'package:movieapp/pages/watchlist_page.dart';
import 'package:movieapp/utilities/movie_provider.dart';
import 'package:provider/provider.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    final movieprovider = Provider.of<MovieProviderModel>(context);
    return Scaffold(
      body: IndexedStack(
        index: movieprovider.selectedIndex,
        children: const [HomePage(), WatchlistPage(), TrendingPage()],
      ),
      // bottomNavigationBar: BottomNavBar(),///
    );
  }
}
