import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newzzy/db/bloc/local_db_bloc.dart';
import 'package:newzzy/db/bloc/repository/repository.dart';
import 'package:newzzy/homepage/bloc/news_bloc.dart';
import 'package:newzzy/homepage/models/top_headlines_by_country.dart'
    as headline_model;
import 'package:newzzy/homepage/repository/news_repository.dart';
import 'package:newzzy/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

import 'package:timeago/timeago.dart' as timeago;

class NewsCard extends StatefulWidget {
  final headline_model.Articles model;
  const NewsCard({Key? key, required this.model}) : super(key: key);

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    // final date = DateTime.parse(model.publishedAt.toString());
    // final timeaAgo = timeago.format(date);

    // final format = DateFormat('yyyy-MM-DD');
    // final formatted = format.parse(date.toString().split(' ')[0]);

    return Container(
      // key: Key.(widget.model.url),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      // height: 150,
      child: Card(
        elevation: 12,
        color: white,
        child: ListTile(
          onLongPress: (() {
            BlocProvider.of<LocalDbBloc>(context)
                .add(CreateArticleTable(model: widget.model));
          }),
          onTap: (() {
            Navigator.pushNamed(context, '/newsDetail',
                arguments: {'model': widget.model});
          }),

          contentPadding: const EdgeInsets.all(10),
          isThreeLine: true,
          // leading: Icon(Icons.booma),
          trailing: AspectRatio(
            aspectRatio: 1,
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              height: 100,
              // height: 150,
              // width: 150,
              imageUrl: widget.model.urlToImage.toString(),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,

                    // scale: 1,
                  ),
                ),
              ),
              placeholder: (context, url) => SizedBox(
                // width: 200.0,
                height: 130.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.red,
                  highlightColor: Colors.yellow,
                  child: const Text(
                    '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          title: Text(
            widget.model.source!.name.toString(),
            style: const TextStyle(
                color: textColor3, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.model.title.toString(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: textColor4,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
                maxLines: 3,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.model.publishedAt.toString(),
                style: const TextStyle(
                    color: textColor5,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              )
            ],
          ),
        ),
      ),
    );
  }
}
