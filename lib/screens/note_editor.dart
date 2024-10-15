import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/db_helper.dart';

class NoteEditor extends StatefulWidget {
  final Note? note;
  final Function onSave;

  const NoteEditor({super.key, this.note, required this.onSave});

  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void _saveNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      return;
    }
    final newNote = Note(
      id: widget.note?.id,
      title: _titleController.text,
      content: _contentController.text,
      date: DateTime.now().toIso8601String(),
    );

    if (widget.note == null) {
      await DBHelper().insertNote(newNote);
    } else {
      await DBHelper().updateNote(newNote);
    }

    widget.onSave();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Content',
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
