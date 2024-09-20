import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:music_api/model/news.dart';

class NewsController extends ChangeNotifier {
  List<Articles> userList = [];

  Future<void> fetchUsers() async {
    http.Response response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=tesla&from=2024-08-09&sortBy=publishedAt&apiKey=1a0cd4b148de44568e7bf3c986ce7709'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final newsData = News.fromJson(responseData);
      userList = newsData.articles ?? [];
      notifyListeners();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
