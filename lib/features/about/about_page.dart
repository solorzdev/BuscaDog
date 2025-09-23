import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

/// AboutPage — versión Flutter del layout Blade compartido
///
/// Navegación esperada:
///   - "/map"     → Mapa de búsquedas
///   - "/pricing" → Planes de rescate
/// Ajusta los routes según tu router (MaterialApp.routes, GoRouter, Beamer, etc.).
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _brandBlue = Color(0xFF32BAEA);
  static const _brandPurple = Color(0xFF5642BB);
  static const _brandYellow = Color(0xFFFBB03B);
  static const _brandBgDark = Color(0xFF0B1220);
  static const _accentRed = Color(0xFFE53C49);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            _HeroSection(),
            _FeaturedStorySection(),
            _FounderSection(),
            _CtaMapSection(),
            _TestimonialsSection(),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  static const _brandBlue = Color(0xFF32BAEA);
  static const _brandPurple = Color(0xFF5642BB);
  static const _brandYellow = Color(0xFFFBB03B);
  static const _brandBgDark = Color(0xFF0B1220);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 960;

    return Container(
      color: _brandBlue,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Expanded(flex: 7, child: _HeroText()),
                      SizedBox(width: 24),
                      Expanded(flex: 5, child: _HeroMedia()),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _HeroText(),
                      SizedBox(height: 24),
                      _HeroMedia(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText();

  static const _brandPurple = Color(0xFF5642BB);
  static const _brandYellow = Color(0xFFFBB03B);
  static const _brandBgDark = Color(0xFF0B1220);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nuestra razón de ser',
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: _brandPurple,
            height: 1.05,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Transformamos la angustia en esperanza. Reunimos familias con sus mascotas mediante alertas geolocalizadas.',
          style: textTheme.titleMedium?.copyWith(
            color: Colors.white.withOpacity(.9),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              onPressed: () => Navigator.of(context).pushNamed('/map'),
              child: const Text('Ver mapa de búsquedas'),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => Navigator.of(context).pushNamed('/pricing'),
              child: const Text('Planes de rescate'),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroMedia extends StatelessWidget {
  const _HeroMedia();
  static const _brandYellow = Color(0xFFFBB03B);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Fondo con blur sutil tipo "backdrop-blur"
                  Container(
                    height: math.min(460, c.maxWidth * 0.75),
                    width: c.maxWidth,
                    color: Colors.white.withOpacity(.4),
                  ),
                  Positioned.fill(
                    child: Image.network(
                      'https://placedog.net/900/640?random',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                      child: const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 16,
              bottom: -18,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: _brandYellow,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '✓',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Familia ',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text: '¡Reunida!',
                                style: TextStyle(
                                  color: Color(0xFFE53C49),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'en 72 horas',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FeaturedStorySection extends StatelessWidget {
  const _FeaturedStorySection();

  static const _brandPurple = Color(0xFF5642BB);
  static const _accentRed = Color(0xFFE53C49);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 960;

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1568572933382-74d440642117?q=80&w=1200&auto=format&fit=crop',
            fit: BoxFit.cover,
            height: 380,
            width: double.infinity,
          ),
          Positioned(
            left: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Text(
                '🐾 Historias reales cada semana',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pepper, nuestra inspiración',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: _brandPurple,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'En 2021, durante una mudanza, Ana perdió a Pepper.\nSin resultados por días, activó una alerta geolocalizada. Ese mismo día, un vecino vio el aviso y llamó.\nEl reencuentro nos marcó: de ahí nace BuscaDog.',
          style: TextStyle(color: Colors.black87, height: 1.35),
        ),
        const SizedBox(height: 18),
        const Text(
          'Escucha la historia completa:',
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            _PlayCircle(),
            SizedBox(width: 12),
            _EqualizerBars(),
          ],
        ),
      ],
    );

    return Container(
      color: const Color(0xFFF9FAFB),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: image),
                    const SizedBox(width: 24),
                    Expanded(child: text),
                  ],
                )
              : Column(children: [image, const SizedBox(height: 20), text]),
        ),
      ),
    );
  }
}

class _PlayCircle extends StatelessWidget {
  const _PlayCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Color(0xFFE53C49),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
    );
  }
}

class _EqualizerBars extends StatefulWidget {
  const _EqualizerBars();

  @override
  State<_EqualizerBars> createState() => _EqualizerBarsState();
}

class _EqualizerBarsState extends State<_EqualizerBars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(6, (i) {
          final delay = i * .1;
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = (_controller.value + delay) % 1.0;
              final h = 6.0 + 12.0 * math.sin(2 * math.pi * t).abs();
              return Container(
                width: 6,
                height: h,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class _FounderSection extends StatelessWidget {
  const _FounderSection();

  static const _brandPurple = Color(0xFF5642BB);
  static const _brandYellow = Color(0xFFFBB03B);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 960;

    final titleAndAvatar = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nuestro fundador',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: _brandPurple,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage('https://i.pravatar.cc/120?img=15'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Santiago Elizalde',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(height: 2),
                Text(
                  'CEO y creador de BuscaDog',
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    final quote = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: _brandYellow.withOpacity(.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _brandYellow.withOpacity(.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Text(
        '“Sé lo que se siente perder a un integrante de la familia. No vamos a detenernos hasta reunir cada historia.”',
        style: TextStyle(
          fontSize: 22,
          height: 1.35,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: titleAndAvatar),
                    const SizedBox(width: 24),
                    Expanded(flex: 7, child: quote),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [titleAndAvatar, const SizedBox(height: 20), quote],
                ),
        ),
      ),
    );
  }
}

class _CtaMapSection extends StatelessWidget {
  const _CtaMapSection();
  static const _brandPurple = Color(0xFF5642BB);
  static const _brandYellow = Color(0xFFFBB03B);
  static const _brandBgDark = Color(0xFF0B1220);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 960;

    final heading = Text(
      'Únete al mapa de búsquedas y reencuentros',
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.w900,
        color: Colors.white,
        height: 1.1,
      ),
    );

    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _brandYellow,
        foregroundColor: _brandBgDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        elevation: 3,
      ),
      onPressed: () => Navigator.of(context).pushNamed('/map'),
      child: const Text('Explorar mapa'),
    );

    return Container(
      color: _brandPurple,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 38),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isWide
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: heading),
                        const SizedBox(width: 24),
                        button,
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [heading, const SizedBox(height: 16), button],
                    ),
              const SizedBox(height: 12),
              Text(
                'Explora búsquedas en tiempo real y celebra cada final feliz.',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestimonialsSection extends StatelessWidget {
  const _TestimonialsSection();

  static const _brandPurple = Color(0xFF5642BB);
  static const _brandBlue = Color(0xFF32BAEA);
  static const _brandYellow = Color(0xFFFBB03B);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1024;

    final cards = <_Testimonial>[
      const _Testimonial(
        img: 'https://i.pravatar.cc/100?img=32',
        name: 'Miriam Torres',
        caption: 'Encontró a su gata',
        text:
            'Excelente servicio, incluso en festivo. Mi gata volvió al día siguiente. Eternamente agradecida.',
      ),
      const _Testimonial(
        img: 'https://i.pravatar.cc/100?img=18',
        name: 'Brenda Montenegro',
        caption: 'Encontró a su perro',
        text:
            '¡Todo fue rápido! La difusión ayudó muchísimo a encontrar a mi pequeño. Recomendado ❤️',
        isPrimary: true,
      ),
      const _Testimonial(
        img: 'https://i.pravatar.cc/100?img=11',
        name: 'Marianela Miguens',
        caption: 'Encontró a su perro',
        text:
            'Estuvo perdido 4 días. Gracias a la publicación, lo hallamos a 12 km. ¡Felices!',
      ),
    ];

    return Container(
      color: const Color(0xFFF9FAFB),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 38),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'No estás solo. Otras familias lo lograron.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                itemCount: cards.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWide ? 3 : 1,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: isWide ? 1.15 : 1.05,
                ),
                itemBuilder: (context, index) =>
                    _TestimonialCard(data: cards[index], index: index),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Testimonial {
  final String img;
  final String name;
  final String caption;
  final String text;
  final bool isPrimary; // el del centro en Blade
  const _Testimonial({
    required this.img,
    required this.name,
    required this.caption,
    required this.text,
    this.isPrimary = false,
  });
}

class _TestimonialCard extends StatelessWidget {
  final _Testimonial data;
  final int index;
  const _TestimonialCard({required this.data, required this.index});

  static const _brandPurple = Color(0xFF5642BB);
  static const _brandBlue = Color(0xFF32BAEA);
  static const _brandYellow = Color(0xFFFBB03B);

  @override
  Widget build(BuildContext context) {
    final isMiddle = data.isPrimary;

    final baseDecoration = BoxDecoration(
      color: isMiddle ? _brandPurple : Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: isMiddle ? _brandPurple : _brandBlue.withOpacity(.4),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 12,
          offset: const Offset(0, 8),
        ),
      ],
    );

    final captionColor = isMiddle
        ? Colors.green.shade100
        : Colors.grey.shade600;
    final quoteColor = isMiddle
        ? Colors.green.shade100.withOpacity(.6)
        : Colors.grey.shade300;

    return Container(
      decoration: baseDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(data.img), radius: 20),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isMiddle ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    data.caption,
                    style: TextStyle(fontSize: 12, color: captionColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            data.text,
            style: TextStyle(color: isMiddle ? Colors.white : Colors.black87),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(
                  5,
                  (i) => const Padding(
                    padding: EdgeInsets.only(right: 2),
                    child: Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: _brandYellow,
                    ),
                  ),
                ),
              ),
              Text('”', style: TextStyle(fontSize: 28, color: quoteColor)),
            ],
          ),
        ],
      ),
    );
  }
}
