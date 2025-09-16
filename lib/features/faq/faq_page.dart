import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        _Faq(
          q: '¿Cómo publico una alerta?',
          a: 'Crea tu cuenta, registra a tu mascota y publica desde el botón “Reportar caso”.',
        ),
        _Faq(
          q: '¿Cómo funciona el mapa?',
          a: 'Mostramos reportes y avistamientos cercanos en tiempo real.',
        ),
        _Faq(
          q: '¿Tiene costo?',
          a: 'Hay plan gratuito y opciones premium con más alcance.',
        ),
      ],
    );
  }
}

class _Faq extends StatelessWidget {
  final String q, a;
  const _Faq({required this.q, required this.a, super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(q, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(a),
      ),
    );
  }
}
