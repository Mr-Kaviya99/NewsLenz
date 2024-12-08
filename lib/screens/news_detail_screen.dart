import 'package:flutter/material.dart';
import '../models/news_article.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  NewsDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(article.imageUrl ?? 'https://via.placeholder.com/150'),
            SizedBox(height: 10),
            Text(article.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 10),
            Text(article.description ?? 'No description available'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
              },
              child: Text("Read Full Article"),
            ),
          ],
        ),
      ),
    );
  }
}
