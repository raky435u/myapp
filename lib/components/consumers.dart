import 'package:flutter/material.dart';

class ConsumerDashboard extends StatefulWidget {
  const ConsumerDashboard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConsumerDashboardState createState() => _ConsumerDashboardState();
}

class _ConsumerDashboardState extends State<ConsumerDashboard> {
  // Placeholder list of products
  final List<String> products = [
    'Tomatoes',
    'Potatoes',
    'Onions',
    'Carrots',
    'Broccoli',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consumer Dashboard'),
        // Applying a consistent color (example: using primary color from theme)
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary, // For text/icons on the AppBar
      ),
      body: ListView.separated( // Using ListView.separated for dividers
        padding: const EdgeInsets.all(8.0), // Add padding around the list
        itemCount: products.length,
        separatorBuilder: (context, index) => const Divider(), // Add a divider between items
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index]),
            onTap: () {
            },
          );
        },
      ),
    );
  }
}