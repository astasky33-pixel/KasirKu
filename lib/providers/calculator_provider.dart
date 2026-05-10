import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import '../models/transaction.dart';
import '../services/hive_service.dart';
import 'package:uuid/uuid.dart';

class CalculatorProvider with ChangeNotifier {
  String _display = '0';
  String _history = '';

  String get display => _display;
  String get history => _history;

  void append(String value) {
    if (_display == '0') {
      if (value == '0' || value == '00') {
        _display = '0';
      } else {
        _display = value;
      }
    } else {
      _display += value;
    }
    notifyListeners();
  }

  void clear() {
    _display = '0';
    _history = '';
    notifyListeners();
  }

  void delete() {
    if (_display.isNotEmpty && _display != '0') {
      if (_display.endsWith(' ')) {
        // Remove operator and surrounding spaces
        _display = _display.substring(0, _display.length - 3);
      } else {
        _display = _display.substring(0, _display.length - 1);
      }
      
      if (_display.isEmpty) {
        _display = '0';
      }
    }
    notifyListeners();
  }

  void calculate() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_display);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      
      _history = _display;
      _display = eval.toStringAsFixed(0);
      if (_display.endsWith('.0')) {
        _display = _display.substring(0, _display.length - 2);
      }
    } catch (e) {
      _display = 'Error';
    }
    notifyListeners();
  }

  Future<bool> saveTransaction() async {
    double? amount = double.tryParse(_display);
    if (amount != null && amount > 0) {
      final transaction = Transaction(
        id: const Uuid().v4(),
        amount: amount,
        timestamp: DateTime.now(),
      );
      await HiveService.addTransaction(transaction);
      clear();
      return true;
    }
    return false;
  }
}
