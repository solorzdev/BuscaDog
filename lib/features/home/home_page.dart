import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    // Colores de referencia
    const cyan = Color(0xFF32BAEA);
    const purple = Color(0xFF5642BB);

    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Perdida no\nsignifica imposible.',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            height: 1.05,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Volvamos a encontrarnos.',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            height: 1.05,
            color: purple,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Lanza una alerta inteligente y conecta con vecinos, rescatistas y familias dispuestas a ayudar.',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white.withOpacity(.95),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 22),

        // Buscador + CTA
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Nombre de tu mascota…',
                  filled: true,
                  fillColor: Colors.white.withOpacity(.28),
                  hintStyle: const TextStyle(color: Colors.white),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.white.withOpacity(.5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(.35),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: purple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              child: const Text('Buscar ahora'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Respondemos al instante y activamos la red de búsqueda.\n✓ Más de 8,900 reencuentros logrados en México mx',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
      ],
    );

    final art = Container(
      height: 280,
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.25),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.09),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.pets, size: 140, color: Colors.white),
      ),
    );

    return ListView(
      children: [
        // HERO
        Container(
          color: cyan,
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 72 : 16,
            vertical: isWide ? 56 : 28,
          ),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: title),
                    const SizedBox(width: 32),
                    art,
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    const SizedBox(height: 24),
                    Center(child: art),
                  ],
                ),
        ),

        // Sección de “cómo funciona” (dummy, puedes editar)
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 72 : 16,
            vertical: 28,
          ),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              _FeatureCard(
                icon: Icons.campaign_outlined,
                title: 'Alerta inmediata',
                text: 'Publica y notificamos a la red de ayuda en tu zona.',
              ),
              _FeatureCard(
                icon: Icons.map_outlined,
                title: 'Mapa en tiempo real',
                text: 'Reportes, avistamientos y veterinarias cercanas.',
              ),
              _FeatureCard(
                icon: Icons.verified_user_outlined,
                title: 'Comunidad verificada',
                text: 'Moderación y reputación para reportes confiables.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 34),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(text),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
