import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_api/controllers/news_controller.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  void initState() {
    super.initState();

    Provider.of<NewsController>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    var userController = Provider.of<NewsController>(context, listen: false);
    var articles = userController.userList;
    var limitedArticles = articles.take(10).toList();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: limitedArticles.length,
                itemBuilder: (context, index) {
                  final article = limitedArticles[index];
                  final source = article.source;
                  return ListTile(
                    title: Text(article.title ?? 'No Title'),
                    subtitle: Text(
                        'Source: ${source?.id} - ${source?.name ?? 'Unknown Name'}'),
                  );
                }),
          )
        ],
      ),
    );
  }
}
