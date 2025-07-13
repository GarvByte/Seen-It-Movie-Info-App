import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:movieapp/pages/main_scaffold.dart';
import 'package:movieapp/pages/movie_about_page.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/utilities/movie_provider.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/pages/search_page.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (details.exception is NoSuchMethodError) {
      print("FULL STACK TRACE: ${details.stack}");
    }
  };
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // Open a box (like a database table)
  await Hive.openBox('hiveBox');
  // final box = await Hive.openBox('hiveBox');
  // await box.clear();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(
    ChangeNotifierProvider(
      create: (_) => MovieProviderModel(),
      child: MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        // home: MainScaffold(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => MainScaffold(),
          '/search_page.dart': (context) => SearchPage(),
          '/movie_about_page.dart': (context) => MovieAboutPage(),
        },
      ),
    ),
  );
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse, // 👈 Enables mouse drag scrolling on web
  };
}
