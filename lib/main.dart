import 'package:flutter/material.dart';

void main() {
  runApp(const CardStoreApp());
}

class CardStoreApp extends StatelessWidget {
  const CardStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grand Slam Cards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const OrderPage(),
    );
  }
}

// A simple class to hold each item's name and price.
class CardItem {
  final String name;
  final double price;
  final IconData icon;

  const CardItem(this.name, this.price, this.icon);
}

const List<CardItem> items = [
  CardItem('Baseball Pack', 4.99, Icons.sports_baseball),
  CardItem('Basketball Pack', 5.99, Icons.sports_basketball),
  CardItem('Football Box', 24.99, Icons.sports_football),
  CardItem('Hockey Pack', 3.99, Icons.sports_hockey),
];

const double sleevesPrice = 2.00;

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // State: which items are selected, and whether sleeves are added.
  List<bool> selected = [false, false, false, false];
  bool addSleeves = false;

  double get total {
    double sum = 0;
    for (int i = 0; i < items.length; i++) {
      if (selected[i]) {
        sum += items[i].price;
      }
    }
    if (addSleeves) {
      sum += sleevesPrice;
    }
    return sum;
  }

  void placeOrder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Placed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < items.length; i++)
              if (selected[i]) Text('• ${items[i].name}'),
            if (addSleeves) const Text('• Card sleeves'),
            const SizedBox(height: 12),
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                selected = [false, false, false, false];
                addSleeves = false;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grand Slam Cards'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const StoreHeader(),
          const SizedBox(height: 16),
          for (int i = 0; i < items.length; i++)
            ItemRow(
              item: items[i],
              isSelected: selected[i],
              onChanged: (value) => setState(() => selected[i] = value!),
            ),
          SwitchListTile(
            title: const Text('Add card sleeves'),
            value: addSleeves,
            onChanged: (value) => setState(() => addSleeves = value),
          ),
          // Conditional UI: only shown when the switch is on.
          if (addSleeves)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Sleeves added for \$2.00. Your cards will stay safe!',
                style: TextStyle(color: Colors.green),
              ),
            ),
          // NEW UI ELEMENT: Divider draws a line to separate the total.
          const Divider(height: 32),
          TotalSection(
            total: total,
            canOrder: selected.contains(true),
            onOrder: placeOrder,
          ),
        ],
      ),
    );
  }
}

// Reusable widget for the banner at the top of the screen.
class StoreHeader extends StatelessWidget {
  const StoreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.style, size: 56, color: Colors.amber),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pick your packs',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Rip a pack, chase a rookie!',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable widget for the total price and the order button.
class TotalSection extends StatelessWidget {
  final double total;
  final bool canOrder;
  final VoidCallback onOrder;

  const TotalSection({
    super.key,
    required this.total,
    required this.canOrder,
    required this.onOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Total: \$${total.toStringAsFixed(2)}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        // Conditional UI: hint only shows until an item is picked.
        if (!canOrder)
          const Text(
            'Select at least one item to order.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: canOrder ? onOrder : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
          ),
          child: const Text('Place Order', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}

// Reusable widget for one item in the list.
class ItemRow extends StatelessWidget {
  final CardItem item;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const ItemRow({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        secondary: Icon(item.icon, color: Colors.indigo, size: 32),
        title: Text(item.name),
        subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
        value: isSelected,
        onChanged: onChanged,
      ),
    );
  }
}
