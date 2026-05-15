import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/analytics_provider.dart';
import '../widgets/currency_utils.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = Provider.of<AnalyticsProvider>(context);
    final dailyRevenue = analytics.getDailyRevenueLast7Days();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context, 
                    'Total Hari Ini', 
                    CurrencyUtils.format(analytics.totalToday), 
                    Colors.blue
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    context, 
                    'Total Minggu Ini', 
                    CurrencyUtils.format(analytics.totalWeekly), 
                    Colors.green
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Chart Section
            const Text(
              'Pendapatan 7 Hari Terakhir',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            AspectRatio(
              aspectRatio: 1.5,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: _getMaxY(dailyRevenue),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final date = dailyRevenue.keys.elementAt(6 - groupIndex);
                          return BarTooltipItem(
                            '${DateFormat('dd MMM').format(date)}\n',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: CurrencyUtils.format(rod.toY),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < 7) {
                              final date = dailyRevenue.keys.elementAt(6 - index);
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  DateFormat('dd/MM').format(date),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: _generateBarGroups(dailyRevenue),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // List of recent transactions or more info can be added here
          ],
        ),
      ),
    );
  }

  double _getMaxY(Map<DateTime, double> data) {
    double max = data.values.fold(0, (prev, element) => element > prev ? element : prev);
    return max == 0 ? 100 : max * 1.2;
  }

  List<BarChartGroupData> _generateBarGroups(Map<DateTime, double> data) {
    List<BarChartGroupData> groups = [];
    final keys = data.keys.toList().reversed.toList(); // Oldest to newest
    
    for (int i = 0; i < keys.length; i++) {
      final value = data[keys[i]] ?? 0;
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: value,
              color: Colors.blueAccent,
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }
    return groups;
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: color.withOpacity(0.8)),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold, 
                color: color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
