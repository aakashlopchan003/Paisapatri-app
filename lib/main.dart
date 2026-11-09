import 'package:flutter/material.dart';

void main() {
  runApp(const PaisaPatriApp());
}

// Colours from docs/design-system.md. Widgets use these names, never hex codes.
class AppColors {
  static const brandPrimary = Color(0xFF1A6C56);
  static const mint = Color(0xFFEEFFED);
  static const cream = Color(0xFFFCFBF7);
  static const textPrimary = Color(0xFF121212);
  static const textSecondary = Color(0xFF5F6B66);
  static const income = Color(0xFF0B7A3B);
  static const expense = Color(0xFFC62828);
}

class PaisaPatriApp extends StatelessWidget {
  const PaisaPatriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaisaPatri',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: AppColors.brandPrimary,
          onPrimary: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.cream,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaisaPatri'),
        backgroundColor: AppColors.brandPrimary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SummaryCard(),
          SizedBox(height: 16),
          Text(
            'Recent transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          TransactionTile(
            title: 'Cinema ticket',
            category: 'Entertainment & Leisure',
            amount: -490,
          ),
          TransactionTile(
            title: 'Supermarket',
            category: 'Groceries',
            amount: -1091.90,
          ),
          TransactionTile(
            title: 'Monthly pay',
            category: 'Salary',
            amount: 45000,
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spent this month',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          SizedBox(height: 8),
          Text(
            'Rs. 1,581.90',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.title,
    required this.category,
    required this.amount,
  });

  final String title;
  final String category;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final isIncome = amount > 0;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(category),
      trailing: Text(
        '${isIncome ? '+' : '-'} Rs. ${amount.abs().toStringAsFixed(2)}',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isIncome ? AppColors.income : AppColors.expense,
        ),
      ),
    );
  }
}
