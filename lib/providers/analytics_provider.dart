import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/hive_service.dart';

class AnalyticsProvider with ChangeNotifier {
  List<Transaction> _transactions = [];

  double get totalToday {
    final now = DateTime.now();
    return _transactions
        .where((t) => 
            t.timestamp.year == now.year && 
            t.timestamp.month == now.month && 
            t.timestamp.day == now.day)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalWeekly {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    return _transactions
        .where((t) => t.timestamp.isAfter(sevenDaysAgo))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  void loadTransactions() {
    _transactions = HiveService.getAllTransactions();
    notifyListeners();
  }

  Map<DateTime, double> getDailyRevenueLast7Days() {
    final Map<DateTime, double> revenue = {};
    final now = DateTime.now();
    
    for (int i = 0; i < 7; i++) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final dailyTotal = _transactions
          .where((t) => 
              t.timestamp.year == date.year && 
              t.timestamp.month == date.month && 
              t.timestamp.day == date.day)
          .fold(0.0, (sum, t) => sum + t.amount);
      revenue[date] = dailyTotal;
    }
    return revenue;
  }
}
