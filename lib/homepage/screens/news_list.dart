import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:newzzy/db/bloc/local_db_bloc.dart';
import 'package:newzzy/homepage/bloc/news_bloc.dart';
import 'package:newzzy/homepage/models/top_headlines_by_country.dart';
import 'package:newzzy/homepage/repository/news_repository.dart';
import 'package:newzzy/homepage/screens/bookmarked_article.dart';

import 'package:newzzy/homepage/screens/news_card.dart';
import 'package:newzzy/utils/colors.dart';
import 'package:newzzy/utils/json_maps.dart';
import 'package:newzzy/widgets/appbar.dart';
import 'package:newzzy/widgets/contact.dart';
import 'package:newzzy/widgets/first_load_error.indicator.dart';
import 'package:newzzy/widgets/loading_overlay.dart';
import 'package:newzzy/widgets/new_page_error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animations/animations.dart';

class NewsList extends StatefulWidget {
  const NewsList({Key? key}) : super(key: key);

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> with TickerProviderStateMixin {
  final TextEditingController _searchEditingController =
      TextEditingController();
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 0);

  final PagingController<int, dynamic> _allNewspagingController =
      PagingController(firstPageKey: 0);
  int page1 = 1;
  int page2 = 1;

  BuildContext? parentContext;
  TabController? _controller;

  List<bool> isChecked = [];

  List<String> newsSources = [];
  List<String> checkedSources = [];

  SharedPreferences? _preferences;

  String? chosenLocation;
  String? bottomError;

  HeadlineByCountry? headlinemodel;
  HeadlineByCountry? allNewsModel;
  int _articlesLimit = 100;

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((page) async {
      if (_searchEditingController.text.trim().isEmpty &&
          checkedSources.isEmpty) {
        _pagingController.error = null;
        _preferences = await SharedPreferences.getInstance();
        var countryCode = _preferences!.get('country_value');

        BlocProvider.of<NewsBloc>(context).add(
          FetchHeadlinesByCountry(
            countryCode: countryCode == null ? 'in' : countryCode.toString(),
            resetPage: false,
            page: page1,
          ),
        );
      }
      // }
      else {
        _pagingController.error = 'All articles found';
      }

      // }
    });

    _allNewspagingController.addPageRequestListener((page) {
      if (_searchEditingController.text.trim().isEmpty) {
        BlocProvider.of<NewsBloc>(context).add(
          FetchAllNews(
              countryCode: 'in'.toString(), resetPage: false, page: page2),
        );
      } else {
        _pagingController.error = 'All articles found';
      }

      // }
    });

    _controller = TabController(vsync: this, length: 4);
  }

  Future<String> _getCountryName() async {
    _preferences = await SharedPreferences.getInstance();
    String countryCode = _preferences!.get('country_value').toString();

    chosenLocation = countryCodes.keys.firstWhere(
        (k) => countryCodes[k] == countryCode,
        orElse: () => 'India');

    return chosenLocation.toString();
  }

  String? topHeadlinesMessage;
  String? allNewsMessage;

  @override
  Widget build(BuildContext context) {
    parentContext = context;
    return Scaffold(
      floatingActionButton:
          _controller!.index == 0 ? _floatingActionButton() : Container(),
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: FutureBuilder<String>(
          future: _getCountryName(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CommonAppBar(
                location: chosenLocation.toString(),
                boolShowLocation: _controller!.index == 0,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _searchTexfield()),
            SliverToBoxAdapter(
                child: Text(
              '*Long press any article to bookmark it',
              style: TextStyle(color: textColor2, fontSize: 15),
            )),
            SliverToBoxAdapter(
              child: DefaultTabController(
                initialIndex: 1,
                length: 4,
                child: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: textColor4,
                  controller: _controller,
                  labelColor: appBarColor,
                  onTap: (value) {
                    setState(() {});
                  },
                  indicatorColor: borderColor1,
                  tabs: [
                    BlocProvider(
                      create: (context) => NewsBloc(
                        repository: NewsRepository(),
                      ),
                      child: _headingWidget(
                        title: 'Top Headlines',
                      ),
                    ),
                    BlocProvider(
                      create: (context) => NewsBloc(
                        repository: NewsRepository(),
                      ),
                      child: _headingWidget(
                        title: "All News",
                      ),
                    ),
                    _headingWidget(title: 'Bookmarked'),
                    _headingWidget(title: 'Contact Us'),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                child: TabBarView(
                  controller: _controller,
                  children: [
                    _newListWidget(),
                    _newListWidget(),
                    BookMarkedArticleList(),
                    ContactUs()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _floatingActionButton() {
    return GestureDetector(
      onTap: () async {
        await showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              decoration: const BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
              ),
              height: 400,
              child: _filterBySource(),
            );
          },
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: appBarColor,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(15),
        child: const Icon(
          Icons.filter_alt_outlined,
          size: 30,
          color: white,
        ),
      ),
    );
  }

  Widget _searchTexfield() {
    return SizedBox(
      // margin: const EdgeInsets.fromLTRB(10, 40, 10, 20),
      height: 70,
      child: TextField(
        style: const TextStyle(fontWeight: FontWeight.bold, color: textColor1),
        onChanged: (value) {
          if (value.trim().isEmpty) {
            _pagingController.error = null;
            _allNewspagingController.error == null;
          }
          setState(() {});
        },
        controller: _searchEditingController,
        decoration: InputDecoration(
          suffixIcon: Container(
            decoration: const BoxDecoration(
              // color: AppColors.iconColor1,

              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: iconColor1,
              size: 22,
            ),
          ),
          filled: true,
          fillColor: backgroundColor2,
          hintText: 'Search for news, topics...',
          hintStyle:
              const TextStyle(fontWeight: FontWeight.bold, color: textColor1),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.transparent,
              // width: 3.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _headingWidget({required title}) {
    return Container(
      // decoration: BoxDecoration(
      //     color: index == _controller!.index ? borderColor1 : iconColor1),
      padding: const EdgeInsets.symmetric(
        vertical: 30,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                color: textColor2, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _newListWidget() {
    return BlocListener<LocalDbBloc, LocalDbState>(
      listener: (context, state) {
        if (state is ArticletableCreated) {
          BlocProvider.of<LocalDbBloc>(context).add(
            BookMarkArticle(model: state.model),
          );
          debugPrint('called');
        } else if (state is ArticleBookMarked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: successColor,
              content: Text(
                'Article Bookmarked',
              ),
              duration: Duration(seconds: 1),
            ),
          );
        } else if (state is ArticleBookFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: successColor,
              content: Text(
                state.message,
              ),
              duration: Duration(seconds: 1),
            ),
          );
        } else if (state is ArticletableFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: successColor,
              content: Text(
                state.message,
              ),
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      child: BlocListener<NewsBloc, NewsState>(
        listener: (context, state) {
          if (state is TopHeadlinesLoaded && _controller!.index == 0) {
            if (state.reset) {
              _pagingController.refresh();
              page1 = 1;
              newsSources = [];
              checkedSources = [];
              isChecked = [];
              headlinemodel = null;
            }
            _articlesLimit = state.model.totalResults >= 100
                ? 100
                : state.model.totalResults;

            headlinemodel == null
                ? headlinemodel = state.model
                : headlinemodel!.articles.addAll(state.model.articles);

            headlinemodel!.articles.map((e) {
              if (!newsSources.contains(e.source!.name)) {
                newsSources.add(e.source!.name.toString());
              }
            }).toList();

            if (isChecked.isEmpty) {
              isChecked = List.generate(newsSources.length, (index) => false);
            } else {
              int l = isChecked.length;
              isChecked.addAll(
                  List.generate(newsSources.length - l, (index) => false));
            }

            if (_articlesLimit > headlinemodel!.articles.length) {
              page1 = page1 + 1;

              _pagingController.appendPage(state.model.articles, page1);
              // page1+=1;
            } else {
              _pagingController.appendLastPage(state.model.articles);
            }
          } else if (state is AllNewsLoaded && _controller!.index == 1) {
            _articlesLimit = state.model.totalResults >= 100
                ? 100
                : state.model.totalResults;

            allNewsModel == null
                ? allNewsModel = state.model
                : allNewsModel!.articles.addAll(state.model.articles);

            if (_articlesLimit > allNewsModel!.articles.length) {
              page2 = page2 + 1;
              _allNewspagingController.appendPage(state.model.articles, page2);
            } else {
              _allNewspagingController.appendLastPage(state.model.articles);
            }
          } else if (state is TopHeadlinesFailed && _controller!.index == 0) {
            _pagingController.error = state.message;
          } else if (state is AllNewsFailed && _controller!.index == 1) {
            _allNewspagingController.error = state.message;
          }
        },
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (_controller!.index == 1) {
              return PagedListView<int, dynamic>(
                // physics: NeverScrollableScrollPhysics(),
                pagingController: _allNewspagingController,

                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                    newPageErrorIndicatorBuilder: (_) =>
                        NewPageErorr(erroMessage: _pagingController.error),
                    firstPageErrorIndicatorBuilder: (_) => FirstLoadErorr(
                          erroMessage: _allNewspagingController.error,
                          onRefresh: () => _allNewspagingController.refresh(),
                        ),
                    itemBuilder: (context, item, index) {
                      if (item.description != null) {
                        if (item.description.toString().toLowerCase().contains(
                            _searchEditingController.text.toLowerCase())) {
                          return NewsCard(
                            model: item,
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    }),
              );
            } else {
              // _loadingOverlay.hide();
              return PagedListView<int, dynamic>(
                // physics: NeverScrollableScrollPhysics(),
                pagingController: _pagingController,

                physics: ScrollPhysics(),

                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                    newPageErrorIndicatorBuilder: (_) =>
                        NewPageErorr(erroMessage: _pagingController.error),
                    firstPageErrorIndicatorBuilder: (_) => FirstLoadErorr(
                          erroMessage: _pagingController.error,
                          onRefresh: () => _pagingController.refresh(),
                        ),
                    itemBuilder: (context, item, index) {
                      if (item.description != null) {
                        if (item.description.toString().toLowerCase().contains(
                            _searchEditingController.text.toLowerCase())) {
                          if (checkedSources.isNotEmpty) {
                            if (checkedSources.contains(item!.source!.name)) {
                              return NewsCard(
                                model: item,
                              );
                            } else
                              return Container();
                          } else {
                            return NewsCard(
                              model: item,
                            );
                          }
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    }),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _filterBySource() {
    return StatefulBuilder(builder: (ctx, sourceSetState) {
      return Stack(
        children: [
          Container(
            height: 300,
            padding: const EdgeInsets.all(20.0),
            child: ListView(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filter by sources',
                      style: TextStyle(
                          color: textColor2,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 20, top: 10),
                      child: Icon(
                        Icons.close_rounded,
                        color: black,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: newsSources.length,
                  itemBuilder: (context, index) {
                    return _checkbocItem(
                        newsSources[index], index, sourceSetState);
                  }),
            ]),
          ),
          Positioned.fill(
            top: 280,
            // left: MediaQuery.of(context).size.width * 0.4,
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
              // height: 20,
              // width: 100,
              margin: EdgeInsets.only(bottom: 15),
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  new TextEditingController().clear();
                  setState(() {
                    checkedSources = [];
                    for (int i = 0; i < isChecked.length; i++) {
                      if (isChecked[i]) {
                        checkedSources.add(newsSources[i]);
                      }
                    }
                    Navigator.of(context).pop();
                  });
                },
                style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all(const Size(150, 100)),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor)),
                child: const Text(
                  'Apply',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _checkbocItem(title, index, sourceSetState) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isChecked[index]
              ? appBarColor
              : Theme.of(context).unselectedWidgetColor,
          fontSize: 16,
        ),
      ),
      trailing: Checkbox(
          onChanged: (checked) {
            sourceSetState(
              () {
                isChecked[index] = checked!;
                // _title = _getTitle();
              },
            );
          },
          value: isChecked[index]),
    );
  }
}
