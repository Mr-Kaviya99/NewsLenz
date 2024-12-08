import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';
import '../models/news_article.dart';
import 'api_service.dart';

class NewsProvider with ChangeNotifier {
  List<NewsArticle> _articles = [];
  List<NewsArticle> _favorites = [];
  bool _isDarkTheme = false;

  List<NewsArticle> get articles => _articles;
  List<NewsArticle> get favorites => _favorites;
  bool get isDarkTheme => _isDarkTheme;

  NewsProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadTheme();
    await loadFavorites();
  }

  Future<void> fetchArticles() async {
    _articles = await ApiService().fetchArticles();
    notifyListeners();
  }

  Future<void> fetchArticlesByCategory(String category) async {
    _articles = await ApiService().fetchArticlesByCategory(category);
    notifyListeners();
  }

  Future<void> searchArticles(String query) async {
    _articles = await ApiService().searchArticles(query);
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    _favorites = await DatabaseHelper.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(NewsArticle article) async {
    final isFavorite = _favorites.any((fav) => fav.title == article.title);

    if (isFavorite) {
      await DatabaseHelper.removeFavorite(article.title);
      _favorites.removeWhere((fav) => fav.title == article.title);
    } else {
      await DatabaseHelper.insertFavorite(article);
      _favorites.add(article);
    }

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkTheme = !_isDarkTheme;
    prefs.setBool('isDarkTheme', _isDarkTheme);
    notifyListeners();
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    notifyListeners();
  }
}
