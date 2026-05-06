import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _display = '0';
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  void _onNumberPressed(String value) {
    setState(() {
      if (_display == '0') {
        _display = value;
      } else {
        _display += value;
      }
    });
  }

  void _onOperatorPressed(String operator) {
    // Basic operator logic will be handled by Provider in Phase 3
    // For Phase 2, we just update the UI
    setState(() {
      _display += ' $operator ';
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          const Text(
                            'Total Belanja',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _display,
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
                          _buildButtonRow(['7', '8', '9', '/']),
                          _buildButtonRow(['4', '5', '6', '*']),
                          _buildButtonRow(['1', '2', '3', '-']),
                          _buildButtonRow(['C', '0', '=', '+']),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50, // Slightly reduced height
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Logic to save transaction
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

  Widget _buildButtonRow(List<String> labels) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: labels.map((label) => _buildButton(label)).toList(),
      ),
    );
  }

  Widget _buildButton(String label) {
    bool isOperator = ['/', '*', '-', '+', '=', 'C'].contains(label);
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: OutlinedButton(
          onPressed: () {
            if (label == 'C') {
              _clear();
            } else if (isOperator) {
              _onOperatorPressed(label);
            } else {
              _onNumberPressed(label);
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
