class Meme {
  late String postLink;
  late String subreddit;
  late String title;
  late String url;
  late bool nsfw;
  late bool spoiler;
  late String author;
  late int ups;
  late List<String> preview;

  Meme({
    required this.postLink,
    required this.subreddit,
    required this.title,
    required this.url,
    required this.nsfw,
    required this.spoiler,
    required this.author,
    required this.ups,
  });

  Meme.fromJson(Map<String, dynamic> json) {
    postLink = json['postLink'];
    subreddit = json['subreddit'];
    title = json['title'];
    url = json['url'];
    nsfw = json['nsfw'];
    spoiler = json['spoiler'];
    author = json['author'];
    ups = json['ups'];
  }

  @override
  String toString() {
    return 'Meme{postLink: $postLink, subreddit: $subreddit, title: $title, url: $url, nsfw: $nsfw, spoiler: $spoiler, author: $author, ups: $ups}';
  }
}
