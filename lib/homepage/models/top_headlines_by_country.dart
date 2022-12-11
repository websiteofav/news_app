class HeadlineByCountry {
  HeadlineByCountry({
    required this.status,
    required this.totalResults,
    required this.articles,
  });
  late final String status;
  late final int totalResults;
  late final List<Articles> articles;

  HeadlineByCountry.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResults = json['totalResults'];
    articles =
        List.from(json['articles']).map((e) => Articles.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['totalResults'] = totalResults;
    data['articles'] = articles.map((e) => e.toJson()).toList();
    return data;
  }
}

class ArticleDetailsFields {
  static const String source = "source";
  static const String author = "author";

  static const String title = "title";

  static const String description = "description";
  static const String urlToImage = "urlToImage";
  static const String content = "content";
  static const String publishedAt = "publishedAt";

  static const String url = "url";
  static const String sourceName = "source_name";

  static final List<String> values = [
    source,
    title,
    description,
    url,
    author,
    publishedAt,
    urlToImage,
    content,
  ];
}

class Articles {
  Articles({
    required this.source,
    required this.author,
    this.title,
    this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    this.content,
  });
  late final Source? source;
  late final String? author;
  late final String? title;
  late final String? description;
  late final String? url;
  late final String? urlToImage;
  late final String? publishedAt;
  late final String? content;
  late final String? sourceName;

  Articles.fromJson(Map<String, dynamic> json, {addSource = true}) {
    if (addSource) source = Source.fromJson(json['source']);
    if (!addSource) sourceName = json['source_name'];
    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    publishedAt = json['publishedAt'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['source_name'] = sourceName;
    data['author'] = author;
    data['title'] = title;
    data['description'] = description;
    data['url'] = url;
    data['urlToImage'] = urlToImage;
    data['publishedAt'] = publishedAt;
    data['content'] = content;
    return data;
  }
}

class Source {
  Source({
    this.id,
    required this.name,
  });
  late final String? id;
  late final String? name;

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<dynamic, dynamic> toJson() {
    final data = <dynamic, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
