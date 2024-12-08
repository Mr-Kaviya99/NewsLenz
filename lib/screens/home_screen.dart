import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/state_manager.dart';
import '../helpers/voice_search.dart';
import '../widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<void> _fetchArticlesFuture;
  final VoiceSearch _voiceSearch = VoiceSearch();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _fetchArticlesFuture =
        Provider.of<NewsProvider>(context, listen: false).fetchArticles();
  }

  void _searchArticles() {
    setState(() {
      _fetchArticlesFuture = Provider.of<NewsProvider>(context, listen: false)
          .searchArticles(_searchController.text);
    });
  }

  void _startVoiceSearch() {
    setState(() {
      _isRecording = true;
    });
    _voiceSearch.listen((recognizedWords) {
      setState(() {
        _searchController.text = recognizedWords;
        _searchArticles();
        _isRecording = false;
      });
    }).catchError((error) {
      setState(() {
        _isRecording = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final articles = Provider.of<NewsProvider>(context).articles;

    return Scaffold(
      appBar: AppBar(
        title: const Text("News Lenz"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Enter search term",
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _searchArticles,
                    ),
                    IconButton(
                      icon: Icon(Icons.mic,
                          color: _isRecording ? Colors.blue : Colors.grey),
                      onPressed: _startVoiceSearch,
                    ),
                  ],
                ),
              ),
              onSubmitted: (value) => _searchArticles(),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _fetchArticlesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error fetching news"));
                } else if (articles.isEmpty) {
                  return const Center(child: Text("No news articles found"));
                } else {
                  return ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return NewsCard(article: articles[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
