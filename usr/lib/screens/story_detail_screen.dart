import 'package:flutter/material.dart';
import '../models.dart';

class StoryDetailScreen extends StatefulWidget {
  final Story story;

  const StoryDetailScreen({super.key, required this.story});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  late Story _story;

  @override
  void initState() {
    super.initState();
    _story = widget.story;
  }

  void _refreshStory() {
    setState(() {
      _story = repository.getStory(_story.id)!;
    });
  }

  void _editSynopsis() {
    showDialog(
      context: context,
      builder: (context) {
        String synopsis = _story.synopsis;
        return AlertDialog(
          title: const Text('Edit Synopsis'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'What is this story about?',
            ),
            controller: TextEditingController(text: synopsis),
            maxLines: 5,
            onChanged: (value) => synopsis = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                repository.updateStorySynopsis(_story.id, synopsis);
                _refreshStory();
                Navigator.pop(context);
              },
              child: const Text('Save'),
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
        title: Text(_story.title),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Synopsis',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _editSynopsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _story.synopsis.isEmpty
                        ? 'No synopsis yet.'
                        : _story.synopsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chapters (${_story.chapters.length})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            '/editor',
                            arguments: {
                              'story': _story,
                            },
                          );
                          _refreshStory();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('New Chapter'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final chapter = _story.chapters[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(chapter.title.isEmpty ? 'Untitled Chapter' : chapter.title),
                  subtitle: Text(
                    'Last updated: ${chapter.lastModified.toString().split('.')[0]}',
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      '/editor',
                      arguments: {
                        'story': _story,
                        'chapter': chapter,
                      },
                    );
                    _refreshStory();
                  },
                );
              },
              childCount: _story.chapters.length,
            ),
          ),
        ],
      ),
    );
  }
}
