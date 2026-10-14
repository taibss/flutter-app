import 'package:flutter/material.dart';

void main() => runApp(const FurnitureApp());

const List<String> categories = [
  'All',
  'Living',
  'Bedroom',
  'Dining',
  'Office',
  'Decor',
];

class Product {
  const Product({
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
    required this.color,
    required this.description,
  });

  final String name;
  final String category;
  final int price;
  final IconData icon;
  final Color color;
  final String description;
}

const List<Product> products = [
  Product(
    name: 'Oslo Sofa',
    category: 'Living',
    price: 24999,
    icon: Icons.weekend,
    color: Color(0xFFD7C4A3),
    description:
        'A three-seater sofa with soft fabric upholstery and solid wood legs.',
  ),
  Product(
    name: 'Nordic Bed',
    category: 'Bedroom',
    price: 32999,
    icon: Icons.bed,
    color: Color(0xFFC9D6DF),
    description: 'Queen-size bed with a padded headboard and under-bed storage.',
  ),
  Product(
    name: 'Oak Dining Table',
    category: 'Dining',
    price: 18999,
    icon: Icons.table_restaurant,
    color: Color(0xFFE3CBA8),
    description: 'Six-seater dining table in natural oak with a matte finish.',
  ),
  Product(
    name: 'Lounge Chair',
    category: 'Living',
    price: 8499,
    icon: Icons.chair_alt,
    color: Color(0xFFE8C4B8),
    description: 'Comfortable accent chair with a curved back and cushioned seat.',
  ),
  Product(
    name: 'Study Desk',
    category: 'Office',
    price: 9999,
    icon: Icons.desk,
    color: Color(0xFFCFD8C5),
    description: 'Compact work desk with a cable hole and two side drawers.',
  ),
  Product(
    name: 'Bookshelf',
    category: 'Office',
    price: 6499,
    icon: Icons.shelves,
    color: Color(0xFFD9CFE3),
    description: 'Five-tier open bookshelf in engineered wood with a walnut look.',
  ),
  Product(
    name: 'Arc Floor Lamp',
    category: 'Decor',
    price: 3999,
    icon: Icons.light,
    color: Color(0xFFF2E2A9),
    description: 'Warm-light floor lamp with a tall arc stand and fabric shade.',
  ),
  Product(
    name: 'Bedside Table',
    category: 'Bedroom',
    price: 2999,
    icon: Icons.bedroom_parent,
    color: Color(0xFFD6D1C4),
    description: 'Small bedside table with one drawer and an open shelf.',
  ),
];

final ValueNotifier<List<Product>> cart =
    ValueNotifier<List<Product>>(<Product>[]);

String rupees(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    buffer.write(digits[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return '₹$buffer';
}

class FurnitureApp extends StatelessWidget {
  const FurnitureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cozy Corner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8D6E63)),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selected = 'All';

  @override
  Widget build(BuildContext context) {
    final visible = _selected == 'All'
        ? products
        : products.where((p) => p.category == _selected).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cozy Corner'),
        actions: [
          ValueListenableBuilder<List<Product>>(
            valueListenable: cart,
            builder: (context, items, _) {
              return IconButton(
                tooltip: 'Cart',
                icon: Badge(
                  isLabelVisible: items.isNotEmpty,
                  label: Text('${items.length}'),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const CartPage()),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                for (final c in categories)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: c == _selected,
                      onSelected: (_) => setState(() => _selected = c),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: visible.length,
              itemBuilder: (context, i) => ProductCard(product: visible[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DetailPage(product: product),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                color: product.color,
                child: Icon(
                  product.icon,
                  size: 64,
                  color: Colors.brown.shade700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(rupees(product.price), style: textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: ListView(
        children: [
          Container(
            height: 240,
            alignment: Alignment.center,
            color: product.color,
            child: Icon(
              product.icon,
              size: 120,
              color: Colors.brown.shade700,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(product.category, style: textTheme.labelLarge),
                const SizedBox(height: 12),
                Text(rupees(product.price), style: textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(product.description),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    cart.value = [...cart.value, product];
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} added to cart')),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add to cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your cart')),
      body: ValueListenableBuilder<List<Product>>(
        valueListenable: cart,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }
          final total = items.fold<int>(0, (sum, p) => sum + p.price);
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final p = items[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: p.color,
                        child: Icon(p.icon, color: Colors.brown.shade700),
                      ),
                      title: Text(p.name),
                      subtitle: Text(rupees(p.price)),
                      trailing: IconButton(
                        tooltip: 'Remove',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          final updated = [...items]..removeAt(i);
                          cart.value = updated;
                        },
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'Total: ${rupees(total)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: () {
                          final messenger = ScaffoldMessenger.of(context);
                          cart.value = <Product>[];
                          Navigator.of(context).pop();
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Order placed (demo)'),
                            ),
                          );
                        },
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}