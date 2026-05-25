import 'package:flutter/material.dart';

import 'models.dart';
import 'screens/home_screen.dart';
import 'screens/story_detail_screen.dart';
import 'screens/chapter_editor_screen.dart';

void main() {
  runApp(const FanficWriterApp());
}

class FanficWriterApp extends StatelessWidget {
  const FanficWriterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fanfic Writer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/story') {
          final story = settings.arguments as Story;
          return MaterialPageRoute(
            builder: (context) => StoryDetailScreen(story: story),
          );
        } else if (settings.name == '/editor') {
          final args = settings.arguments as Map<String, dynamic>;
          final story = args['story'] as Story;
          final chapter = args['chapter'] as Chapter?;
          return MaterialPageRoute(
            builder: (context) => ChapterEditorScreen(
              story: story,
              chapter: chapter,
            ),
          );
        }
        return null;
      },
    );
  }
}
