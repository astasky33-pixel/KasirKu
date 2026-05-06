import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/hive_service.dart';
import 'package:uuid/uuid.dart';

class NotesProvider with ChangeNotifier {
  List<Note> _notes = [];
  String _searchQuery = '';

  List<Note> get notes {
    if (_searchQuery.isEmpty) {
      return _notes;
    }
    return _notes.where((note) => 
      note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      note.content.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  void loadNotes() {
    _notes = HiveService.getAllNotes();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addNote(String title, String content) async {
    final note = Note(
      id: const Uuid().v4(),
      title: title,
      content: content,
      timestamp: DateTime.now(),
    );
    await HiveService.addNote(note);
    loadNotes();
  }

  Future<void> updateNote(int index, String title, String content) async {
    final oldNote = _notes[index];
    final updatedNote = Note(
      id: oldNote.id,
      title: title,
      content: content,
      timestamp: DateTime.now(),
    );
    await HiveService.updateNote(index, updatedNote);
    loadNotes();
  }

  Future<void> deleteNote(int index) async {
    await HiveService.deleteNote(index);
    loadNotes();
  }
}
