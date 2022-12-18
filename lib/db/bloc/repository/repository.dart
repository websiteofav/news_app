
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:newzzy/homepage/models/top_headlines_by_country.dart';
import 'package:newzzy/utils/keys.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDBRepository {
  LocalDBRepository();
  static final LocalDBRepository instance = LocalDBRepository._init();

  static Database? _database;
  LocalDBRepository._init();

  Future<Database> get database async {
    try {
      if (_database != null) return _database!;

      _database = await _initDB('news.db');
      return _database!;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Database> _initDB(String filepath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filepath);

      return await openDatabase(
        path,
        version: 1,
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<bool> createArticleDB() async {
    try {
      final Database db = await database;
      const keyType = "TEXT PRIMARY KEY";
      const descriptionType = "TEXT";

      await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Keys.localBookmarkedArticlesTable} (
       ${ArticleDetailsFields.url} $keyType,

       ${ArticleDetailsFields.content} $descriptionType,
       ${ArticleDetailsFields.author} $descriptionType,
       ${ArticleDetailsFields.description} $descriptionType,
       ${ArticleDetailsFields.publishedAt} $descriptionType,
       ${ArticleDetailsFields.source} $descriptionType,
       ${ArticleDetailsFields.title} $descriptionType,
       ${ArticleDetailsFields.urlToImage} $descriptionType,
       ${ArticleDetailsFields.sourceName} $descriptionType

        )

       ''');

      // await db.execute(
      //     '''DROP TABLE IF EXISTS  ${Keys.localBookmarkedArticlesTable}''');

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> insertToBookmarkDB(Articles model, {insert = true}) async {
    try {
      final Database? db = await _database;

      List<Map> count = await db!.query(Keys.localBookmarkedArticlesTable,
          where: "${ArticleDetailsFields.url} = ?", whereArgs: [model.url]);
      int result;
      model.sourceName = model.source!.name;

      if (count.isEmpty) {
        result =
            await db.insert(Keys.localBookmarkedArticlesTable, model.toJson());

        return result > 0 ? true : false;
      } else {
        result = await db.update(
          Keys.localBookmarkedArticlesTable,
          model.toJson(),
          where: '${ArticleDetailsFields.url} = ?',
          whereArgs: [model.url],
        );
        return result > 0 ? true : false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<Articles>> getAllArtiles() async {
    try {
      final Database? db = await database;

      final List<Map<String, dynamic>> articles = await db!.query(
        Keys.localBookmarkedArticlesTable,
      );
      debugPrint(articles.toString());

      if (articles.isNotEmpty) {
        return articles
            .map((e) => Articles.fromJson(e, addSource: false))
            .toList();
      } else {
        throw Exception('No Artciles Found');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw false;
    }
  }

  // user_primary_detail_databse
}
