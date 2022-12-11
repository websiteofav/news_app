import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newzzy/utils/colors.dart';
import 'package:newzzy/homepage/models/top_headlines_by_country.dart'
    as headline_model;
import 'package:newzzy/widgets/webview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class NewsDetail extends StatefulWidget {
  // final headline_model.Articles model;

  const NewsDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments! as Map;
    headline_model.Articles articleModel = arguments['model'];
    bool source = arguments['source'] ?? true;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBar(
          backgroundColor: appBarColor,
        ),
      ),
      body: ListView(children: [
        Stack(children: [
          articleModel.url == null
              ? CircleAvatar()
              : CachedNetworkImage(
                  height: 250,
                  imageUrl: articleModel.urlToImage.toString(),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        colorFilter: const ColorFilter.mode(
                            Colors.red, BlendMode.dstATop),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
          // Positioned(
          //   top: 200,
          //   left: 20,
          //   right: 20,
          //   child: Text(articleModel.title.toString(),
          //       overflow: TextOverflow.ellipsis,
          //       maxLines: 3,
          //       style: const TextStyle(
          //           color: white, fontSize: 18, backgroundColor: black)),
          // )
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 15,
          ),
          child: Text(
            source
                ? articleModel.source!.name.toString()
                : articleModel.sourceName.toString(),
            style: TextStyle(
                color: textColor3, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 15,
          ),
          child: Text(
            articleModel.publishedAt.toString(),
            style: const TextStyle(
                color: textColor5, fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 15,
          ),
          child: Text(
            articleModel.description.toString(),
            style: const TextStyle(
                color: textColor4, fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommonWebview(
                  articleUrl: articleModel.url,
                ),
              ), // selectedDate //selectedIndex.month.toString()
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 15,
            ),
            child: Text(
              'See full story...',
              style: TextStyle(
                  color: appBarColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ),
        ),
      ]),
    );
  }
}
