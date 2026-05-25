import 'package:flutter/material.dart';
import '../models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Story> _stories = [];

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  void _loadStories() {
    setState(() {
      _stories = repository.getAllStories();
    });
  }

  void _createNewStory() {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        String fandom = '';
        return AlertDialog(
          title: const Text('New Story'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) => title = value,
                autofocus: true,
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(labelText: 'Fandom (optional)'),
                onChanged: (value) => fandom = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  repository.createStory(title, fandom);
                  _loadStories();
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Fanfictions'),
        centerTitle: true,
      ),
      body: _stories.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_stories, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('No stories yet. Start writing!'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _stories.length,
              itemBuilder: (context, index) {
                final story = _stories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      story.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        if (story.fandom.isNotEmpty) ...[
                          Chip(
                            label: Text(story.fandom),
                            visualDensity: VisualDensity.compact,
                          ),
                          const SizedBox(height: 8),
                        ],
                        Text(
                          '${story.chapters.length} chapter${story.chapters.length == 1 ? '' : 's'}',
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        '/story',
                        arguments: story,
                      );
                      _loadStories();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewStory,
        icon: const Icon(Icons.add),
        label: const Text('New Story'),
      ),
    );
  }
}
