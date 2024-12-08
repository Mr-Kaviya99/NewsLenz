import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news_article.dart';
import '../helpers/tts_helper.dart';
import '../helpers/state_manager.dart';

class NewsCard extends StatefulWidget {
  final NewsArticle article;

  NewsCard({Key? key, required this.article}) : super(key: key);

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  final TTSHelper _ttsHelper = TTSHelper();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _ttsHelper.setCompletionHandler(_onTTSComplete);
  }

  void _onTTSComplete() {
    setState(() {
      _isPlaying = false;
    });
  }

  void _togglePlayStop() {
    if (_isPlaying) {
      _ttsHelper.stop();
      setState(() {
        _isPlaying = false;
      });
    } else {
      setState(() {
        _isPlaying = true;
      });
      _ttsHelper
          .speak(widget.article.description ?? 'No description available');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = Provider.of<NewsProvider>(context, listen: true)
        .favorites
        .any((fav) => fav.title == widget.article.title);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
              widget.article.imageUrl ?? 'https://via.placeholder.com/150'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.article.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child:
            Text(widget.article.description ?? 'No description available'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                color: _isPlaying ? Colors.green : Colors.grey,
                onPressed: _togglePlayStop,
              ),
              IconButton(
                icon: const Icon(Icons.favorite),
                color: isFavorite ? Colors.red : Colors.grey,
                onPressed: () {
                  Provider.of<NewsProvider>(context, listen: false)
                      .toggleFavorite(widget.article);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

}
