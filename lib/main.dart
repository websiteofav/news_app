import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newzzy/db/bloc/local_db_bloc.dart';
import 'package:newzzy/db/bloc/repository/repository.dart';
import 'package:newzzy/homepage/bloc/news_bloc.dart';
import 'package:newzzy/homepage/repository/news_repository.dart';
import 'package:newzzy/homepage/screens/news_detail.dart';
import 'package:newzzy/homepage/screens/news_list.dart';
import 'package:newzzy/utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future main() async {
  runApp(const MyApp());
  await dotenv.load(fileName: ".env");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsBloc(
            repository: NewsRepository(),
          ),
        ),
        BlocProvider(
          create: (context) => LocalDbBloc(
            repository: LocalDBRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          unselectedWidgetColor: textColor1,
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],

          // Define the default font family.
          fontFamily: 'Georgia',

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        home: const NewsList(),
        routes: {
          '/home': (context) => const NewsList(),
          '/newsDetail': (context) => const NewsDetail(),
        },
      ),
    );
  }
}
