import 'package:flutter/material.dart';

class Chapter {
  final String id;
  String title;
  String content;
  final DateTime createdAt;
  DateTime updatedAt;

  Chapter({
    required this.id,
    required this.title,
    this.content = '',
    required this.createdAt,
    required this.updatedAt,
  });
  
  int get wordCount {
    if (content.trim().isEmpty) return 0;
    return content.trim().split(RegExp(r'\s+')).length;
  }
}

class Story {
  final String id;
  String title;
  String fandom;
  String summary;
  final List<Chapter> chapters;
  final DateTime createdAt;
  DateTime updatedAt;

  Story({
    required this.id,
    required this.title,
    this.fandom = '',
    this.summary = '',
    List<Chapter>? chapters,
    required this.createdAt,
    required this.updatedAt,
  }) : chapters = chapters ?? [];

  int get totalWordCount {
    return chapters.fold(0, (sum, chapter) => sum + chapter.wordCount);
  }
}

class StoryRepository extends ChangeNotifier {
  final List<Story> _stories = [];

  List<Story> get stories => List.unmodifiable(_stories);

  void addStory(Story story) {
    _stories.add(story);
    notifyListeners();
  }

  void updateStory(Story story) {
    story.updatedAt = DateTime.now();
    notifyListeners();
  }

  void deleteStory(String id) {
    _stories.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  Story? getStory(String id) {
    try {
      return _stories.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  void addChapter(String storyId, Chapter chapter) {
    final story = getStory(storyId);
    if (story != null) {
      story.chapters.add(chapter);
      story.updatedAt = DateTime.now();
      notifyListeners();
    }
  }

  void updateChapter(String storyId, Chapter chapter) {
    final story = getStory(storyId);
    if (story != null) {
      final index = story.chapters.indexWhere((c) => c.id == chapter.id);
      if (index != -1) {
        story.chapters[index] = chapter;
        story.updatedAt = DateTime.now();
        notifyListeners();
      }
    }
  }

  void deleteChapter(String storyId, String chapterId) {
    final story = getStory(storyId);
    if (story != null) {
      story.chapters.removeWhere((c) => c.id == chapterId);
      story.updatedAt = DateTime.now();
      notifyListeners();
    }
  }
}
