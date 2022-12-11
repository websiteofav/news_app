import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:newzzy/homepage/models/error_model.dart';
import 'package:newzzy/homepage/models/top_headlines_by_country.dart';
import 'package:newzzy/utils/apis.dart';
import 'package:newzzy/utils/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsRepository {
  SharedPreferences? _preferences;

  static const pageLimit = 5;

  static const domains = 'bbc.co.uk,techcrunch.com,engadget.com';

  Future<Either<HeadlineByCountry, ErrorModel>> getTopHeadlinesByCountry(
      {required countryCode, required page}) async {
    try {
      _preferences = await SharedPreferences.getInstance();

      await _preferences!.setString("country_value", countryCode);
      Uri url = Uri.parse(
          "https://newsapi.org/v2/top-headlines?pageSize=$pageLimit&page=$page&country=$countryCode");

      var response = await http.get(
        url,
        headers: {
          "X-Api-Key": dotenv.env['API_KEY'].toString(),
        },
      );

      var data = json.decode(response.body);
      debugPrint(data.toString());

      if (data['status'].toString() == 'ok') {
        HeadlineByCountry model = HeadlineByCountry.fromJson(data);
        return left<HeadlineByCountry, ErrorModel>(model);
      } else {
        ErrorModel model = ErrorModel.fromJson(data);
        return right<HeadlineByCountry, ErrorModel>(model);
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Either<HeadlineByCountry, ErrorModel>> getAllNews(
      {required countryCode, required page}) async {
    try {
      _preferences = await SharedPreferences.getInstance();

      await _preferences!.setString("country_value", countryCode);
      Uri url = Uri.parse(
          "https://newsapi.org/v2/everything?pageSize=$pageLimit&page=$page&domains=$domains");

      var response = await http.get(
        url,
        headers: {"X-Api-Key": dotenv.env['API_KEY'].toString()},
      );

      var data = json.decode(response.body);
      debugPrint(data.toString());

      if (data['status'].toString() == 'ok') {
        HeadlineByCountry model = HeadlineByCountry.fromJson(data);
        return left<HeadlineByCountry, ErrorModel>(model);
      } else {
        ErrorModel model = ErrorModel.fromJson(data);
        return right<HeadlineByCountry, ErrorModel>(model);
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
