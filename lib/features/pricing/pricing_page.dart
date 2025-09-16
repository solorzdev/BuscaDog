import 'package:flutter/material.dart';

class PricingPage extends StatelessWidget {
  const PricingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: const [
          _PlanCard(
            name: 'Gratis',
            price: '\$0',
            features: ['Publicar caso', 'Mapa básico'],
          ),
          _PlanCard(
            name: 'Pro',
            price: '\$99/mes',
            features: ['Mayor alcance', 'Soporte prioritario'],
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String name, price;
  final List<String> features;
  const _PlanCard({
    required this.name,
    required this.price,
    required this.features,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(price, style: Theme.of(context).textTheme.headlineMedium),
              const Divider(),
              for (final f in features)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check, size: 18),
                      const SizedBox(width: 6),
                      Text(f),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              FilledButton(onPressed: () {}, child: const Text('Elegir')),
            ],
          ),
        ),
      ),
    );
  }
}
