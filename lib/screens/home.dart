import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _loanController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _termController = TextEditingController();

  double? _monthlyPayment;
  double? _totalPayment;
  double? _totalInterest;

  void _calculateMortgage() {
    final double loanAmount = double.tryParse(_loanController.text) ?? 0;
    final double annualRate = double.tryParse(_interestController.text) ?? 0;
    final int termYears = int.tryParse(_termController.text) ?? 0;

    if (loanAmount <= 0 || annualRate <= 0 || termYears <= 0) return;

    final monthlyRate = annualRate / 100 / 12;
    final months = termYears * 12;

    final monthlyPayment = (loanAmount * monthlyRate) /
        (1 - pow(1 + monthlyRate, -months));

    setState(() {
      _monthlyPayment = monthlyPayment;
      _totalPayment = monthlyPayment * months;
      _totalInterest = _totalPayment! - loanAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mortgage Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Loan Amount
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Loan Amount',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _loanController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(hintText: 'Enter loan amount'),
                    ),
                  ],
                ),
              ),
            ),
            // Interest Rate
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Annual Interest Rate (%)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _interestController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(hintText: 'Enter interest rate'),
                    ),
                  ],
                ),
              ),
            ),
            // Term Years
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Term (Years)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _termController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(hintText: 'Enter term in years'),
                    ),
                  ],
                ),
              ),
            ),
            // Calculate Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: _calculateMortgage,
                child: const Text('Calculate'),
              ),
            ),
            // Results
            if (_monthlyPayment != null)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Payment: \$${_monthlyPayment!.toStringAsFixed(2)}',
                      ),
                      Text(
                        'Total Payment: \$${_totalPayment!.toStringAsFixed(2)}',
                      ),
                      Text(
                        'Total Interest: \$${_totalInterest!.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
