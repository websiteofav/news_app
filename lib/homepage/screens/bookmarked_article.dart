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
import 'package:newzzy/widgets/appbar.dart';
import 'package:newzzy/widgets/loading_overlay.dart';
import 'package:shimmer/shimmer.dart';

import 'package:timeago/timeago.dart' as timeago;

class BookMarkedArticleList extends StatefulWidget {
  const BookMarkedArticleList({
    Key? key,
  }) : super(key: key);

  @override
  State<BookMarkedArticleList> createState() => _BookMarkedArticleListState();
}

class _BookMarkedArticleListState extends State<BookMarkedArticleList> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<LocalDbBloc>(context).add(
      GetAllBookMakedArticle(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LoadingOverlay _loadingOverlay = LoadingOverlay();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: CommonAppBar(
            // location: chosenLocation.toString(),
            boolShowLocation: false,
          )),
      body: BlocListener<LocalDbBloc, LocalDbState>(
        listenWhen: (previous, current) {
          previous != current;
          return true;
        },
        listener: (context, state) {
          if (state is NewsLoading) {
            _loadingOverlay.show(context);
          } else {
            _loadingOverlay.hide();
          }
        },
        child: BlocBuilder<LocalDbBloc, LocalDbState>(
          builder: (context, state) {
            if (state is LocalDbInitial) {
              return Container();
            } else if (state is BookmarkedArticleFound) {
              return ListView.builder(
                  itemCount: state.model.length,
                  itemBuilder: ((context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      height: 150,
                      child: Card(
                        elevation: 12,
                        color: white,
                        child: ListTile(
                          onTap: (() => Navigator.pushNamed(
                                context,
                                '/newsDetail',
                                arguments: {
                                  'model': state.model[index],
                                  'source': false,
                                },
                              )),
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
                              imageUrl:
                                  state.model[index].urlToImage.toString(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          title: Text(
                            state.model[index].sourceName.toString(),
                            style: const TextStyle(
                                color: textColor3,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.model[index].title.toString(),
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
                                state.model[index].publishedAt.toString(),
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
                  }));
            } else if (state is BookmarkedArticleNotFound) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                color: backgroundColor,
                child: Text(
                  state.message,
                  style: TextStyle(
                      color: black, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            } else
              return Container();
          },
        ),
      ),
    );
  }
}
