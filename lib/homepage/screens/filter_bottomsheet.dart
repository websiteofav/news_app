import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newzzy/homepage/bloc/news_bloc.dart';
import 'package:newzzy/utils/colors.dart';
import 'package:newzzy/utils/json_maps.dart';
import 'package:newzzy/widgets/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterBottomSheet extends StatefulWidget {
  String? currentLocation;
  FilterBottomSheet({Key? key, this.currentLocation}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  SharedPreferences? _preferences;

  @override
  void initState() {
    location = widget.currentLocation.toString();

    _getCountryCodeValue();
  }

  _getCountryCodeValue() async {
    _preferences = await SharedPreferences.getInstance();
    location = _preferences!.getString('country_value').toString();
  }

  final LoadingOverlay _loadingOverlay = LoadingOverlay();

  String location = 'in';
  @override
  Widget build(BuildContext context) {
    return BlocListener<NewsBloc, NewsState>(
      listener: (context, state) {
        // if (state is NewsLoading) {
        //   _loadingOverlay.show(context);
        // } else {
        //   _loadingOverlay.hide();
        // }
      },
      child: Stack(
        children: [
          Container(
            height: 300,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: ListView(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Choose your location',
                      style: TextStyle(
                          color: textColor2,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 12, top: 10),
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
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: countryCodes.length,
                  itemBuilder: ((context, index) {
                    return _radioItem(countryCodes.keys.elementAt(index),
                        countryCodes.values.elementAt(index));
                  })),
            ]),
          ),
          Positioned.fill(
            top: 300,
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
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, 'changed:$location');
                  BlocProvider.of<NewsBloc>(context).add(
                      FetchHeadlinesByCountry(
                          countryCode: location, resetPage: true, page: 1));
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(150, 50)),
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
      ),
    );
  }

  Widget _radioItem(title, value) {
    return InkWell(
      onTap: () {
        setState(() {
          location = value.toString();
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: value == location
                  ? appBarColor
                  : Theme.of(context).unselectedWidgetColor,
              fontSize: 16,
            ),
          ),
          Radio<String>(
              activeColor: appBarColor,
              value: value,
              groupValue: location,
              onChanged: (onChanged) {
                setState(() {
                  location = onChanged.toString();
                });
              })
        ],
      ),
    );
  }
}
