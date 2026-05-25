import 'package:flutter/material.dart';
import '../models.dart';

class ChapterEditorScreen extends StatefulWidget {
  final Story story;
  final Chapter? chapter;

  const ChapterEditorScreen({
    super.key,
    required this.story,
    this.chapter,
  });

  @override
  State<ChapterEditorScreen> createState() => _ChapterEditorScreenState();
}

class _ChapterEditorScreenState extends State<ChapterEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Chapter _currentChapter;
  bool _isNew = false;

  @override
  void initState() {
    super.initState();
    if (widget.chapter == null) {
      _isNew = true;
      _currentChapter = repository.createChapter(widget.story.id, '', '');
    } else {
      _currentChapter = widget.chapter!;
    }
    
    _titleController = TextEditingController(text: _currentChapter.title);
    _contentController = TextEditingController(text: _currentChapter.content);

    _contentController.addListener(_save);
    _titleController.addListener(_save);
  }

  void _save() {
    repository.updateChapter(
      widget.story.id,
      _currentChapter.id,
      _titleController.text,
      _contentController.text,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: 'Chapter Title',
            border: InputBorder.none,
          ),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: 'Done',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _contentController,
          maxLines: null,
          expands: true,
          decoration: const InputDecoration(
            hintText: 'Start writing your chapter here...',
            border: InputBorder.none,
          ),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.5,
          ),
          textAlignVertical: TextAlignVertical.top,
        ),
      ),
    );
  }
}
