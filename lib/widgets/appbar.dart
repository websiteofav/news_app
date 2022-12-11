import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newzzy/homepage/bloc/news_bloc.dart';
import 'package:newzzy/homepage/screens/filter_bottomsheet.dart';
import 'package:newzzy/homepage/screens/filter_sources.dart';
import 'package:newzzy/utils/colors.dart';
import 'package:newzzy/utils/json_maps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonAppBar extends StatefulWidget {
  final String location;
  final boolShowLocation;
  const CommonAppBar(
      {Key? key, this.location = 'India', this.boolShowLocation = true})
      : super(key: key);

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  String? chosenLocation;
  SharedPreferences? _preferences;
  String countryCode = 'in';

  @override
  void initState() {
    _getCountryName();

    chosenLocation = widget.location;

    super.initState();
  }

  Future<String> _getCountryName() async {
    _preferences = await SharedPreferences.getInstance();
    countryCode = _preferences!.get('country_value').toString();

    chosenLocation = countryCodes.keys.firstWhere(
        (k) => countryCodes[k] == countryCode,
        orElse: () => 'India');

    return countryCode;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewsBloc, NewsState>(
      listener: (context, state) {},
      child: AppBar(
          // alignment: Alignment.bottomLeft,
          backgroundColor: appBarColor,
          titleSpacing: 15,
          title: Container(
            height: 200,
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (widget.boolShowLocation)
                  const Text(
                    'Location',
                    style: TextStyle(
                      color: white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.end,
                  ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MyNEWS',
                        style: TextStyle(
                            color: white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      if (widget.boolShowLocation)
                        FutureBuilder<String?>(
                          future: _getCountryName(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GestureDetector(
                                onTap: () async {
                                  String? data = await showModalBottomSheet(
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
                                        height: 450,
                                        child: FilterBottomSheet(
                                            currentLocation: countryCode),
                                      );
                                    },
                                  );

                                  if (data != null) {
                                    var splitteddata =
                                        data.toString().split(':');
                                    if (splitteddata[0] == 'changed') {
                                      setState(() {
                                        chosenLocation = countryCodes.keys
                                            .firstWhere(
                                                (k) =>
                                                    countryCodes[k] ==
                                                    splitteddata[1],
                                                orElse: () => 'India');
                                      });
                                    }
                                  }
                                },
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      const WidgetSpan(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: Icon(Icons.location_on,
                                              color: white, size: 18),
                                        ),
                                      ),
                                      TextSpan(
                                        text: chosenLocation ?? '',
                                        style: const TextStyle(
                                            color: white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                        )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
