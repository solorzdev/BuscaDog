import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> with SingleTickerProviderStateMixin {
  // Colores de marca
  static const colorCeleste = Color(0xFF32BAEA);
  static const colorMorado = Color(0xFF5642BB);
  static const colorAmarillo = Color(0xFFFBB03B);
  static const colorTextoOsc = Color(0xFF0B1220);

  final ScrollController _scroll = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  // Keys para scroll a secciones
  final _keys = <String, GlobalKey>{
    'publicar': GlobalKey(),
    'pagos': GlobalKey(),
    'mapa': GlobalKey(),
    'cuenta': GlobalKey(),
  };

  late final AnimationController _bobCtrl;
  late final Animation<double> _bob;

  // Datos
  final List<_Category> _cats = const [
    _Category(
      id: 'publicar',
      title: 'Publicar alerta',
      desc: 'Crea tu anuncio',
    ),
    _Category(
      id: 'pagos',
      title: 'Pagos y planes',
      desc: 'Precios y facturación',
    ),
    _Category(id: 'mapa', title: 'Mapa y reportes', desc: 'Cómo funciona'),
    _Category(id: 'cuenta', title: 'Cuenta y soporte', desc: 'Acceso y ayuda'),
  ];

  final Map<String, List<_Faq>> _faqs = const {
    'publicar': [
      _Faq(
        q: '¿Cómo publico una alerta de mi mascota?',
        a: 'Ve a “Crear alerta”, sube 2 a 5 fotos claras, describe señas particulares y marca en el mapa la última ubicación. Publica y comparte el enlace.',
      ),
      _Faq(
        q: '¿Qué fotos funcionan mejor?',
        a: 'Primer plano del rostro, cuerpo completo y alguna con accesorio (collar, arnés). Evita fotos oscuras o borrosas.',
      ),
      _Faq(
        q: '¿Puedo editar mi alerta después?',
        a: 'Sí. Desde “Mis alertas” puedes actualizar texto, fotos y zona. Los cambios se reflejan en segundos.',
      ),
    ],
    'pagos': [
      _Faq(
        q: '¿BuscaDog es gratis?',
        a: 'La publicación básica es gratuita en esta demo. Ofrecemos planes de difusión con mayor alcance y reportes priorizados.',
      ),
      _Faq(
        q: '¿Qué medios de pago aceptan?',
        a: 'Tarjeta de crédito/débito. En el lanzamiento consideraremos transferencias locales.',
      ),
      _Faq(
        q: '¿Puedo pedir factura?',
        a: 'Sí, al completar el pago podrás cargar datos fiscales para generar tu comprobante.',
      ),
    ],
    'mapa': [
      _Faq(
        q: '¿Cómo funciona el mapa colaborativo?',
        a: 'Concentra reportes por zona. Puedes filtrar por especie, fecha y radio de búsqueda. Próximamente: notificaciones por colonia.',
      ),
      _Faq(
        q: '¿Puedo reportar un avistamiento?',
        a: 'Sí, desde cualquier alerta puedes presionar “Reportar avistamiento”, adjuntar foto y ubicación aproximada.',
      ),
      _Faq(
        q: '¿Cada cuánto se actualiza?',
        a: 'En tiempo casi real. Los nuevos reportes aparecen al instante y los filtros no requieren recargar la página.',
      ),
    ],
    'cuenta': [
      _Faq(
        q: 'Olvidé mi contraseña',
        a: 'Usa “Recuperar acceso” para recibir un correo de restablecimiento.',
      ),
      _Faq(
        q: '¿Cómo contacto soporte?',
        a: 'Escríbenos desde el botón “Ayuda” o al correo soporte@BuscaDog.demo. Respondemos en horario laboral.',
      ),
      _Faq(
        q: '¿Puedo eliminar mi cuenta?',
        a: 'Sí. Desde Ajustes > Privacidad puedes solicitar la eliminación y desindexación de tus alertas.',
      ),
    ],
  };

  final List<_Testimonial> _testimonials = const [
    _Testimonial(
      img: 'https://i.pravatar.cc/100?img=32',
      name: 'Miriam Torres',
      caption: 'Encontró a su gata',
      text:
          'Excelente servicio, incluso en festivo. Mi gata volvió al día siguiente. Eternamente agradecida.',
      dark: false,
    ),
    _Testimonial(
      img: 'https://i.pravatar.cc/100?img=18',
      name: 'Brenda Montenegro',
      caption: 'Encontró a su perro',
      text:
          '¡Todo fue rápido! La difusión ayudó muchísimo a encontrar a mi pequeño. Recomendado ❤️',
      dark: true, // Esta será la central (morado)
    ),
    _Testimonial(
      img: 'https://i.pravatar.cc/100?img=11',
      name: 'Marianela Miguens',
      caption: 'Encontró a su perro',
      text:
          'Estuvo perdido 4 días. Gracias a la publicación, lo hallamos a 12 km. ¡Felices!',
      dark: false,
    ),
  ];

  String _q = '';

  @override
  void initState() {
    super.initState();
    _bobCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat(reverse: true);
    _bob = Tween<double>(
      begin: 0,
      end: -8,
    ).animate(CurvedAnimation(parent: _bobCtrl, curve: Curves.easeInOut));
    _searchCtrl.addListener(() {
      setState(() => _q = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _bobCtrl.dispose();
    _searchCtrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _scrollTo(String sectionId) async {
    final key = _keys[sectionId];
    if (key == null) return;
    final context = key.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scrollbar(
      controller: _scroll,
      child: ListView(
        controller: _scroll,
        padding: EdgeInsets.zero,
        children: [
          // =================== HERO ===================
          _HeroSection(bob: _bob),

          // =================== CATEGORÍAS ===================
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: LayoutBuilder(
              builder: (ctx, c) {
                final isLg = c.maxWidth >= 1024;
                final isSm = c.maxWidth >= 600;
                final cross = isLg ? 4 : (isSm ? 2 : 1);
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _cats.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3.3,
                  ),
                  itemBuilder: (_, i) {
                    final cat = _cats[i];
                    return InkWell(
                      onTap: () => _scrollTo(cat.id),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: colorCeleste.withOpacity(.3),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorMorado,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cat.desc,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // =================== BUSCADOR ===================
          Container(
            color: const Color(0xFFFFF7E6).withOpacity(.5), // #FBB03B/5 approx
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Busca en las preguntas…',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorCeleste.withOpacity(.25)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorCeleste.withOpacity(.25)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: colorCeleste, width: 1.4),
                ),
              ),
            ),
          ),

          // =================== LISTA DE FAQS ===================
          Container(
            color: const Color(0xFFFFF7E6).withOpacity(.5), // #FBB03B/5 approx
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              children: [
                ..._faqs.entries.map((entry) {
                  final catId = entry.key;
                  final items = entry.value;
                  final filtered = _q.isEmpty
                      ? items
                      : items
                            .where(
                              (f) =>
                                  f.q.toLowerCase().contains(_q) ||
                                  f.a.toLowerCase().contains(_q),
                            )
                            .toList();

                  return Column(
                    key: _keys[catId],
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          _catTitle(catId),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorMorado,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: colorCeleste.withOpacity(.25),
                          ),
                        ),
                        child: Column(
                          children: [
                            for (int i = 0; i < filtered.length; i++) ...[
                              _FaqTile(faq: filtered[i]),
                              if (i != filtered.length - 1)
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: colorCeleste.withOpacity(.2),
                                ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (entry.key != _faqs.keys.last)
                        Divider(
                          height: 32,
                          thickness: 1,
                          color: colorCeleste.withOpacity(.2),
                        ),
                    ],
                  );
                }).toList(),
                if (_q.isNotEmpty &&
                    !_faqs.values.any(
                      (l) => l.any(
                        (f) =>
                            f.q.toLowerCase().contains(_q) ||
                            f.a.toLowerCase().contains(_q),
                      ),
                    ))
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'No hay resultados para “$_q”.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // =================== CTA FINAL ===================
          Container(
            color: colorMorado,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 12,
                  children: [
                    Text(
                      '¿No resolvimos tu duda?',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorAmarillo,
                        foregroundColor: colorTextoOsc,
                        elevation: 6,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        // TODO: reemplaza por tu navegación real
                        Navigator.of(context).pushNamed('/map');
                      },
                      child: const Text(
                        'Ver mapa de búsquedas',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'También puedes escribir a soporte@BuscaDog.demo.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(.85),
                  ),
                ),
              ],
            ),
          ),

          // ===== TESTIMONIOS =====
          Container(
            color: const Color(0xFFF7F7F8),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 36),
            child: Column(
              children: [
                Text(
                  'No estás solo. Otras familias lo lograron.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorMorado,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (ctx, c) {
                    final cross = c.maxWidth >= 900
                        ? 3
                        : (c.maxWidth >= 600 ? 2 : 1);
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _testimonials.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cross,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1.05,
                      ),
                      itemBuilder: (_, i) {
                        final t = _testimonials[i];
                        final isMiddle = i == 1;
                        final BoxDecoration deco;
                        final Color textColor;
                        if (isMiddle) {
                          deco = BoxDecoration(
                            color: colorMorado,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: colorMorado),
                            boxShadow: kElevationToShadow[1],
                          );
                          textColor = Colors.white;
                        } else if (t.dark) {
                          deco = BoxDecoration(
                            color: colorCeleste,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: colorCeleste),
                            boxShadow: kElevationToShadow[1],
                          );
                          textColor = Colors.white;
                        } else {
                          deco = BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: colorCeleste.withOpacity(.3),
                            ),
                            boxShadow: kElevationToShadow[1],
                          );
                          textColor = Colors.black87;
                        }

                        final subColor = isMiddle
                            ? Colors.white70
                            : (t.dark ? Colors.white70 : Colors.grey[600]);

                        return Container(
                          decoration: deco,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(t.img),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        t.name,
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        t.caption,
                                        style: TextStyle(
                                          color: subColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: Text(
                                  t.text,
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) => const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 1,
                                        ),
                                        child: Icon(
                                          Icons.star,
                                          size: 18,
                                          color: colorAmarillo,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '”',
                                    style: TextStyle(
                                      color: isMiddle
                                          ? Colors.white60
                                          : (t.dark
                                                ? Colors.white70
                                                : Colors.grey[300]),
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _catTitle(String id) {
    switch (id) {
      case 'publicar':
        return 'Publicar alerta';
      case 'pagos':
        return 'Pagos y planes';
      case 'mapa':
        return 'Mapa y reportes';
      case 'cuenta':
        return 'Cuenta y soporte';
      default:
        return id;
    }
  }
}

// ---------- Widgets auxiliares ----------

class _HeroSection extends StatelessWidget {
  final Animation<double> bob;
  const _HeroSection({required this.bob});

  static const colorCeleste = Color(0xFF32BAEA);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: colorCeleste,
      child: Stack(
        children: [
          // Contenido central
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 320),
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Preguntas frecuentes',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Respuestas rápidas sobre cómo usar BuscaDog, pagos y el mapa.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Perrito izquierdo
          Positioned.fill(
            left: 12,
            child: LayoutBuilder(
              builder: (ctx, c) {
                final show = c.maxWidth >= 768; // md+
                if (!show) return const SizedBox.shrink();
                return Align(
                  alignment: Alignment.centerLeft,
                  child: _BobbingEmoji(bob: bob, rotateDeg: -6, emoji: '🐶'),
                );
              },
            ),
          ),
          // Perrito derecho
          Positioned.fill(
            right: 12,
            child: LayoutBuilder(
              builder: (ctx, c) {
                final show = c.maxWidth >= 768; // md+
                if (!show) return const SizedBox.shrink();
                return Align(
                  alignment: Alignment.centerRight,
                  child: _BobbingEmoji(bob: bob, rotateDeg: 6, emoji: '🐕'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BobbingEmoji extends StatelessWidget {
  final Animation<double> bob;
  final double rotateDeg;
  final String emoji;
  const _BobbingEmoji({
    required this.bob,
    required this.rotateDeg,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size.width >= 1280 ? 96.0 : 80.0;
    return AnimatedBuilder(
      animation: bob,
      builder: (_, __) {
        return Transform.translate(
          offset: Offset(0, bob.value),
          child: Transform.rotate(
            angle: rotateDeg * 3.1415926 / 180,
            child: Container(
              width: sz + 32,
              height: sz + 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.85),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 24,
                    spreadRadius: -2,
                    color: Colors.black26,
                    offset: Offset(0, 12),
                  ),
                ],
                border: Border.all(color: Colors.black.withOpacity(.05)),
              ),
              child: Center(
                child: Text(emoji, style: TextStyle(fontSize: sz)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FaqTile extends StatefulWidget {
  final _Faq faq;
  const _FaqTile({required this.faq});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          onExpansionChanged: (v) => setState(() => _open = v),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          trailing: AnimatedRotation(
            turns: _open ? 0.125 : 0, // 45° cuando está abierto (+)
            duration: const Duration(milliseconds: 200),
            child: const Text(
              '+',
              style: TextStyle(
                color: _FaqPageColors.celeste,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          title: Text(
            widget.faq.q,
            style: const TextStyle(
              color: _FaqPageColors.morado,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.faq.a,
                style: TextStyle(color: Colors.grey[800]),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _FaqPageColors {
  static const celeste = Color(0xFF32BAEA);
  static const morado = Color(0xFF5642BB);
}

// ---------- Modelos simples ----------

class _Category {
  final String id, title, desc;
  const _Category({required this.id, required this.title, required this.desc});
}

class _Faq {
  final String q, a;
  const _Faq({required this.q, required this.a});
}

class _Testimonial {
  final String img, name, caption, text;
  final bool dark;
  const _Testimonial({
    required this.img,
    required this.name,
    required this.caption,
    required this.text,
    required this.dark,
  });
}
