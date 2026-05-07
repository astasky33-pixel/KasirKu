import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/analytics_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final calculator = Provider.of<CalculatorProvider>(context);
    final analytics = Provider.of<AnalyticsProvider>(context, listen: false);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Display Area
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      alignment: Alignment.bottomRight,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            calculator.history.isEmpty ? 'Total Belanja' : calculator.history,
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              calculator.display,
                              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Calculator Buttons
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          _buildButtonRow(context, ['7', '8', '9', '/']),
                          _buildButtonRow(context, ['4', '5', '6', '*']),
                          _buildButtonRow(context, ['1', '2', '3', '-']),
                          _buildButtonRow(context, ['C', '0', '=', '+']),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  bool success = await calculator.saveTransaction();
                                  if (success) {
                                    analytics.loadTransactions();
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Transaksi disimpan!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  } else {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Masukkan nominal belanja (lebih dari 0)'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.save),
                                label: const Text('Simpan Transaksi', style: TextStyle(fontSize: 16)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonRow(BuildContext context, List<String> labels) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: labels.map((label) => _buildButton(context, label)).toList(),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label) {
    final calculator = Provider.of<CalculatorProvider>(context, listen: false);
    bool isOperator = ['/', '*', '-', '+', '=', 'C'].contains(label);
    
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: OutlinedButton(
          onPressed: () {
            if (label == 'C') {
              calculator.clear();
            } else if (label == '=') {
              calculator.calculate();
            } else if (['/', '*', '-', '+'].contains(label)) {
              calculator.append(' $label ');
            } else {
              calculator.append(label);
            }
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: isOperator 
                ? Theme.of(context).colorScheme.secondaryContainer 
                : Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isOperator 
                  ? Theme.of(context).colorScheme.onSecondaryContainer 
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
