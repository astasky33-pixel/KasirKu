import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../models/note.dart';

class HiveService {
  static const String transactionBoxName = 'transactions';
  static const String noteBoxName = 'notes';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters (will be available after build_runner)
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(TransactionAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(NoteAdapter());

    // Open Boxes
    await Hive.openBox<Transaction>(transactionBoxName);
    await Hive.openBox<Note>(noteBoxName);
  }

  // Transaction operations
  static Box<Transaction> getTransactionBox() => Hive.box<Transaction>(transactionBoxName);
  
  static Future<void> addTransaction(Transaction transaction) async {
    await getTransactionBox().add(transaction);
  }

  static List<Transaction> getAllTransactions() {
    return getTransactionBox().values.toList();
  }

  // Note operations
  static Box<Note> getNoteBox() => Hive.box<Note>(noteBoxName);

  static Future<void> addNote(Note note) async {
    await getNoteBox().add(note);
  }

  static Future<void> updateNote(int index, Note note) async {
    await getNoteBox().putAt(index, note);
  }

  static Future<void> deleteNote(int index) async {
    await getNoteBox().deleteAt(index);
  }

  static List<Note> getAllNotes() {
    return getNoteBox().values.toList();
  }
}
