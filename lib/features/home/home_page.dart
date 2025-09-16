import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  /// Callbacks opcionales para cablear navegación desde AppShell.
  final VoidCallback? onExploreMap;
  final VoidCallback? onViewPlans;

  const HomePage({super.key, this.onExploreMap, this.onViewPlans});

  @override
  Widget build(BuildContext context) {
    // Colores brand
    const cyan = Color(0xFF32BAEA);
    const purple = Color(0xFF5642BB);
    const amber = Color(0xFFFBB03B);
    const red = Color(0xFFE53C49);

    return ListView(
      children: [
        // ---------- HERO ----------
        Container(
          color: cyan,
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: _MaxWidth(
            child: LayoutBuilder(
              builder: (context, c) {
                final isWide = c.maxWidth >= 900;
                final title = _HeroTextBlock(purple: purple);
                final art = _HeroArt();
                return isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: title),
                          const SizedBox(width: 32),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: art,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          title,
                          const SizedBox(height: 24),
                          Center(child: art),
                        ],
                      );
              },
            ),
          ),
        ),

        // ---------- SECCIÓN 2: Tres pasos + imagen ----------
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 36),
          child: _MaxWidth(
            child: LayoutBuilder(
              builder: (context, c) {
                final isWide = c.maxWidth >= 900;
                final leftImg = _RoundedNetworkImage(
                  url:
                      'https://images.unsplash.com/photo-1583337130417-3346a1be7dee',
                  height: 380,
                );

                final rightCol = _StepsAndStats(
                  purple: purple,
                  amber: amber,
                  red: red,
                  onViewPlans: onViewPlans,
                );

                return isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: leftImg),
                          const SizedBox(width: 32),
                          Expanded(child: rightCol),
                        ],
                      )
                    : Column(
                        children: [
                          leftImg,
                          const SizedBox(height: 24),
                          rightCol,
                        ],
                      );
              },
            ),
          ),
        ),

        // ---------- SECCIÓN 3: Testimonios ----------
        Container(
          color: amber.withOpacity(0.10),
          padding: const EdgeInsets.symmetric(vertical: 36),
          child: _MaxWidth(
            child: Column(
              children: [
                Text(
                  'No estás solo. Estas familias lo consiguieron.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: purple,
                  ),
                ),
                const SizedBox(height: 16),
                _TestimonialsGrid(purple: purple),
              ],
            ),
          ),
        ),

        // ---------- SECCIÓN 4: Historias (acordeón) ----------
        Container(
          color: const Color(0xFFE0F7FA),
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: _MaxWidth(
            child: Column(
              children: const [
                Text(
                  'Historias que inspiran',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                _StoriesAccordion(),
              ],
            ),
          ),
        ),

        // ---------- SECCIÓN 5: CTA ----------
        Container(
          color: purple,
          padding: const EdgeInsets.symmetric(vertical: 36),
          child: _MaxWidth(
            child: Column(
              children: [
                const Text(
                  'Únete a nuestra red de búsqueda y reencuentros',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Explora casos en tiempo real y sé parte de una comunidad que ayuda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: amber,
                    foregroundColor: const Color(0xFF0B1220),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    if (onExploreMap != null) {
                      onExploreMap!();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Navegación al mapa pendiente de cablear',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Explorar mapa',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ===================== Sub-widgets =====================

class _HeroTextBlock extends StatelessWidget {
  const _HeroTextBlock({required this.purple});
  final Color purple;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Perdida no significa imposible.',
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
                  fillColor: Colors.white.withOpacity(.20),
                  hintStyle: const TextStyle(color: Colors.white70),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.white.withOpacity(.4)),
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
          'Respondemos al instante y activamos la red de búsqueda.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          '✓ Más de 8,900 reencuentros logrados en México 🇲🇽',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: purple,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _HeroArt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.20),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Image.network(
          'https://cdn-icons-png.flaticon.com/512/616/616408.png',
          width: 160,
          height: 160,
        ),
      ),
    );
  }
}

class _StepsAndStats extends StatelessWidget {
  const _StepsAndStats({
    required this.purple,
    required this.amber,
    required this.red,
    this.onViewPlans,
  });

  final Color purple;
  final Color amber;
  final Color red;
  final VoidCallback? onViewPlans;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tres pasos para un reencuentro rápido',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: purple,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Creamos una alerta geolocalizada que se difunde en redes sociales y canales locales.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: red,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
            onPressed: () {
              if (onViewPlans != null) {
                onViewPlans!();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Navegación a planes pendiente de cablear'),
                  ),
                );
              }
            },
            child: const Text('Ver planes de rescate'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatBlock(
                value: '82+',
                label: 'Búsquedas activas',
                color: purple,
              ),
              const SizedBox(width: 24),
              _StatBlock(value: '48+', label: 'Reencuentros hoy', color: amber),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class _TestimonialsGrid extends StatelessWidget {
  const _TestimonialsGrid({required this.purple});
  final Color purple;

  @override
  Widget build(BuildContext context) {
    final cards = const [
      _TestimonialCard(
        name: 'Javier Ortiz',
        city: 'Aguascalientes',
        text: '“Mi gato se escondió por días…”',
      ),
      _TestimonialCard(
        name: 'David Romero',
        city: 'Hermosillo',
        text: '“Encontramos a nuestro perrito…”',
      ),
      _TestimonialCard(
        name: 'Juan Carlos Pérez',
        city: 'Guadalajara',
        text: '“Gracias a la difusión…”',
      ),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        final isWide = c.maxWidth >= 900;
        final isMid = c.maxWidth >= 600;
        final cross = isWide ? 3 : (isMid ? 2 : 1);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cross,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 4 / 3,
          ),
          itemBuilder: (_, i) => cards[i],
        );
      },
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({
    required this.name,
    required this.city,
    required this.text,
  });

  final String name;
  final String city;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(city, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 8),
              Text(text, style: const TextStyle(color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoriesAccordion extends StatefulWidget {
  const _StoriesAccordion();

  @override
  State<_StoriesAccordion> createState() => _StoriesAccordionState();
}

class _StoriesAccordionState extends State<_StoriesAccordion> {
  int? open = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StoryTile(
          index: 1,
          open: open,
          onToggle: _toggle,
          title: '1. El regreso de Linda con Luciana',
          imageUrl: 'https://images.unsplash.com/photo-1558788353-f76d92427f16',
          story:
              'Luciana contrató el servicio 36 días después de perder a Linda. Gracias a una alerta geolocalizada, la encontraron en solo 4 días.',
          results: const [
            'Un trabajador rural vio el anuncio de Linda.',
            'La alerta alcanzó a 98,000 personas.',
            'Linda volvió sana y salva con su familia.',
          ],
        ),
        const SizedBox(height: 12),
        _StoryTile(
          index: 2,
          open: open,
          onToggle: _toggle,
          title: '2. Chimuelo y su gran amigo Hipo',
          imageUrl:
              'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg',
          story:
              'Después de semanas de angustia, Sebastián lanzó una alerta para encontrar a sus perros. Los vecinos ayudaron rápidamente.',
          results: const [
            'Los vecinos reconocieron a los perros por la foto.',
            'Hipo y Chimuelo fueron encontrados jugando juntos.',
            'Reencuentro con muchas lágrimas y felicidad.',
          ],
        ),
        const SizedBox(height: 12),
        _StoryTile(
          index: 3,
          open: open,
          onToggle: _toggle,
          title: '3. Sam, el viajero inesperado',
          imageUrl:
              'https://images.pexels.com/photos/333083/pexels-photo-333083.jpeg',
          story:
              'Sam fue adoptado temporalmente por otra familia que lo cuidó. Al recibir la alerta, coordinaron su regreso sin problema.',
          results: const [
            'Sam llegó limpio y con collar nuevo.',
            'Ambas familias mantuvieron contacto.',
            'Hoy Sam es doblemente querido.',
          ],
        ),
      ],
    );
  }

  void _toggle(int i) => setState(() => open = (open == i) ? null : i);
}

class _StoryTile extends StatelessWidget {
  const _StoryTile({
    required this.index,
    required this.open,
    required this.onToggle,
    required this.title,
    required this.imageUrl,
    required this.story,
    required this.results,
  });

  final int index;
  final int? open;
  final ValueChanged<int> onToggle;
  final String title;
  final String imageUrl;
  final String story;
  final List<String> results;

  @override
  Widget build(BuildContext context) {
    final isOpen = open == index;
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => onToggle(index),
            child: Container(
              color: const Color(0xFF32BAEA),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    isOpen ? '-' : '+',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: LayoutBuilder(
                builder: (context, c) {
                  final isWide = c.maxWidth >= 900;

                  // Imagen limitada (evita overflow en pantallas anchas)
                  final imgLimited = ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 320, // ancho máx en desktop
                      maxHeight: 180, // alto fijo
                    ),
                    child: _RoundedNetworkImage(url: imageUrl, height: 180),
                  );

                  // Texto
                  final textCol = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Su historia',
                        style: TextStyle(
                          color: Color(0xFF064E3B),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(story),
                      const SizedBox(height: 8),
                      const Text(
                        'Resultados',
                        style: TextStyle(
                          color: Color(0xFF064E3B),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...results.map(
                        (r) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• '),
                            Expanded(child: Text(r)),
                          ],
                        ),
                      ),
                    ],
                  );

                  // Layout responsivo
                  return isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            imgLimited,
                            const SizedBox(width: 16),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: textCol,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // En móvil: ancho completo, pero alto fijo
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 180),
                              child: _RoundedNetworkImage(
                                url: imageUrl,
                                height: 180,
                              ),
                            ),
                            const SizedBox(height: 12),
                            textCol,
                          ],
                        );
                },
              ),
            ),

            crossFadeState: isOpen
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
        ],
      ),
    );
  }
}

class _RoundedNetworkImage extends StatelessWidget {
  const _RoundedNetworkImage({required this.url, this.height});
  final String url;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

/// Contenedor que emula `max-w-6xl` centrado con padding lateral.
class _MaxWidth extends StatelessWidget {
  const _MaxWidth({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1152), // ~6xl Tailwind
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        ),
      ),
    );
  }
}
