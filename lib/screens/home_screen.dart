import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../models/note.dart';
import 'note_editor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Note>> _noteList;

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  void _refreshNotes() {
    setState(() {
      _noteList = DBHelper().getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
      ),
      body: FutureBuilder<List<Note>>(
        future: _noteList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Note note = snapshot.data![index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        NoteEditor(note: note, onSave: _refreshNotes),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    DBHelper().deleteNote(note.id!);
                    _refreshNotes();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NoteEditor(onSave: _refreshNotes),
          ),
        ),
      ),
    );
  }
}
