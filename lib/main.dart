import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const UnaLuzApp());
}

class UnaLuzApp extends StatelessWidget {
  const UnaLuzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Una Luz',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Georgia',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4A34A),
          secondary: Color(0xFFF1E7C5),
          surface: Color(0xFF18213C),
        ),
      ),
      home: const CardGameScreen(),
    );
  }
}

class CardGameScreen extends StatefulWidget {
  const CardGameScreen({super.key});

  @override
  State<CardGameScreen> createState() => _CardGameScreenState();
}

class _CardGameScreenState extends State<CardGameScreen> {
  final List<BibleCard> _cards = const [
    BibleCard(
      character: 'Moises',
      verse: 'Exodo 14:14',
      quote: 'El Senor peleara por ustedes; ustedes quedense tranquilos.',
      lesson:
          'Confiar en Dios en medio del miedo abre camino donde parecia imposible.',
      challenge: 'Ora 1 minuto por algo que hoy te da temor.',
      imagePath: 'assets/images/moises.png',
      type: BibleCharacterType.moses,
    ),
    BibleCard(
      character: 'Ester',
      verse: 'Ester 4:14',
      quote: 'Y quien sabe si para esta hora has llegado al reino.',
      lesson:
          'Tu posicion actual puede ser una mision divina para bendecir a otros.',
      challenge: 'Haz hoy un acto valiente de bondad.',
      imagePath: 'assets/images/ester.png',
      type: BibleCharacterType.esther,
    ),
    BibleCard(
      character: 'David',
      verse: '1 Samuel 17:45',
      quote: 'Yo vengo a ti en el nombre del Senor de los ejercitos.',
      lesson: 'La fe no niega gigantes, los enfrenta con identidad.',
      challenge: 'Escribe tu gigante y una accion pequena para enfrentarlo.',
      imagePath: 'assets/images/david.png',
      type: BibleCharacterType.david,
    ),
    BibleCard(
      character: 'Maria',
      verse: 'Lucas 1:38',
      quote:
          'He aqui la sierva del Senor; hagase conmigo conforme a tu palabra.',
      lesson: 'La obediencia humilde abre espacio a milagros.',
      challenge: 'Di "si" a una tarea correcta que has postergado.',
      imagePath: 'assets/images/maria.png',
      type: BibleCharacterType.mary,
    ),
    BibleCard(
      character: 'Jesus',
      verse: 'Juan 8:12',
      quote: 'Yo soy la luz del mundo; el que me sigue no andara en tinieblas.',
      lesson:
          'Seguir a Jesus transforma decisiones diarias con direccion y esperanza.',
      challenge: 'Toma hoy una decision guiada por amor y verdad.',
      imagePath: 'assets/images/jesus.png',
      type: BibleCharacterType.jesus,
    ),
  ];

  int _index = 0;
  bool _showFront = false;
  bool _advanceOnNextReveal = false;

  void _flipCard() {
    setState(() {
      if (_showFront) {
        _showFront = false;
        _advanceOnNextReveal = true;
      } else {
        if (_advanceOnNextReveal) {
          _index = (_index + 1) % _cards.length;
          _advanceOnNextReveal = false;
        }
        _showFront = true;
      }
    });
  }

  void _nextCard() {
    setState(() {
      _index = (_index + 1) % _cards.length;
      _showFront = false;
      _advanceOnNextReveal = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final BibleCard current = _cards[_index];
    final Size size = MediaQuery.of(context).size;
    final bool compact = size.width < 700;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B1122), Color(0xFF1A2854), Color(0xFF3A2552)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -80,
              child: _GlowOrb(
                size: compact ? 230 : 320,
                color: const Color(0x66FFD57A),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -120,
              child: _GlowOrb(
                size: compact ? 260 : 360,
                color: const Color(0x664DA9FF),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 40,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 980),
                          child: Column(
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'UNA LUZ',
                                style: TextStyle(
                                  letterSpacing: 5,
                                  color: const Color(0xFFF8E7B7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: compact ? 26 : 34,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Cartas biblicas para aprender y aplicar',
                                style: TextStyle(
                                  color: const Color(0xFFE4DCC8),
                                  fontSize: compact ? 14 : 16,
                                ),
                              ),
                              const SizedBox(height: 22),
                              GestureDetector(
                                onTap: _flipCard,
                                child: AnimatedSwitcher(
                                  duration: const Duration(
                                    milliseconds: 450,
                                  ),
                                  transitionBuilder: (child, animation) {
                                    final rotate =
                                        Tween<double>(begin: math.pi, end: 0)
                                            .animate(animation);
                                    return AnimatedBuilder(
                                      animation: rotate,
                                      child: child,
                                      builder: (context, childWidget) {
                                        final isUnder = childWidget!.key !=
                                            ValueKey(_showFront);
                                        final rotation = isUnder
                                            ? math.min(rotate.value, math.pi / 2)
                                            : rotate.value;
                                        return Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.identity()
                                            ..setEntry(3, 2, 0.001)
                                            ..rotateY(rotation),
                                          child: childWidget,
                                        );
                                      },
                                    );
                                  },
                                  layoutBuilder: (currentChild, previousChildren) {
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        ...previousChildren,
                                        if (currentChild != null) currentChild,
                                      ],
                                    );
                                  },
                                  child: _showFront
                                      ? CardFront(
                                          key: const ValueKey(true),
                                          card: current,
                                          compact: compact,
                                        )
                                      : CardBack(
                                          key: const ValueKey(false),
                                          compact: compact,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _showFront
                                    ? 'Toca la carta para volver'
                                    : 'Toca la carta para revelar',
                                style: const TextStyle(color: Color(0xFFD6D0BF)),
                              ),
                              const SizedBox(height: 22),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                alignment: WrapAlignment.center,
                                children: [
                                  FilledButton.icon(
                                    onPressed: _flipCard,
                                    icon: const Icon(Icons.flip),
                                    label: Text(_showFront ? 'Ocultar' : 'Revelar'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xFFD4A34A),
                                      foregroundColor: const Color(0xFF1B1B1B),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: _nextCard,
                                    icon: const Icon(Icons.auto_awesome),
                                    label: const Text('Siguiente carta'),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color(0xFFD4A34A),
                                        width: 1.2,
                                      ),
                                      foregroundColor: const Color(0xFFF7EBD2),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardBack extends StatelessWidget {
  const CardBack({
    required this.compact,
    super.key,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      compact: compact,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wb_incandescent_rounded,
            color: Color(0xFFF4D07D),
            size: 56,
          ),
          const SizedBox(height: 16),
          Text(
            'Una Luz',
            style: TextStyle(
              color: const Color(0xFFF6E9C7),
              fontSize: compact ? 30 : 40,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: const Color(0x66F6D89A)),
              color: const Color(0x22F6D89A),
            ),
            child: const Text(
              'Carta de Sabiduria',
              style: TextStyle(color: Color(0xFFFAEECB)),
            ),
          ),
        ],
      ),
    );
  }
}

class CardFront extends StatelessWidget {
  const CardFront({
    required this.card,
    required this.compact,
    super.key,
  });

  final BibleCard card;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      compact: compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  card.character,
                  style: TextStyle(
                    color: const Color(0xFFFFE2A4),
                    fontSize: compact ? 28 : 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                card.verse,
                style: const TextStyle(
                  color: Color(0xFFEFD9A5),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2C2246), Color(0xFF3F2B59), Color(0xFF1E355E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 18,
                    offset: Offset(0, 8),
                    color: Color(0x55000000),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        card.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: CustomPaint(
                              painter: BiblicalFigurePainter(card.type),
                              size: Size(compact ? 220 : 300, compact ? 220 : 300),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x18000000), Color(0x66000000)],
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 14,
                    right: 14,
                    child: Icon(
                      Icons.auto_awesome,
                      color: Color(0xFFFFE4AE),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '"${card.quote}"',
            style: const TextStyle(
              color: Color(0xFFF8EBD0),
              fontStyle: FontStyle.italic,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            card.lesson,
            style: const TextStyle(
              color: Color(0xFFE0E4F2),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Reto: ${card.challenge}',
            style: const TextStyle(
              color: Color(0xFFFEDFA0),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({
    required this.child,
    required this.compact,
  });

  final Widget child;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: compact ? 340 : 520,
      height: compact ? 520 : 680,
      padding: EdgeInsets.all(compact ? 18 : 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0x66F1D597), width: 1.4),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B1D3A), Color(0xFF13253F), Color(0xFF291A44)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x99000000),
            offset: Offset(0, 18),
            blurRadius: 30,
          ),
          BoxShadow(
            color: Color(0x33FFE6AE),
            offset: Offset(0, 0),
            blurRadius: 8,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

enum BibleCharacterType { jesus, moses, esther, david, mary }

class BibleCard {
  const BibleCard({
    required this.character,
    required this.verse,
    required this.quote,
    required this.lesson,
    required this.challenge,
    required this.imagePath,
    required this.type,
  });

  final String character;
  final String verse;
  final String quote;
  final String lesson;
  final String challenge;
  final String imagePath;
  final BibleCharacterType type;
}

class BiblicalFigurePainter extends CustomPainter {
  BiblicalFigurePainter(this.type);

  final BibleCharacterType type;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Paint halo = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xCCFFE7A8), Color(0x11FFE7A8), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.46));
    canvas.drawCircle(center, size.width * 0.46, halo);

    final Paint silhouette = Paint()..color = const Color(0xFFE6D9B8);
    final Paint stroke = Paint()
      ..color = const Color(0xFF0B142D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8;

    final Path body = Path()
      ..moveTo(size.width * 0.36, size.height * 0.85)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.55,
        size.width * 0.64,
        size.height * 0.85,
      )
      ..close();
    canvas.drawPath(body, silhouette);
    canvas.drawPath(body, stroke);

    final double headRadius = size.width * 0.1;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.36), headRadius, silhouette);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.36), headRadius, stroke);

    switch (type) {
      case BibleCharacterType.jesus:
        _drawJesus(canvas, size, stroke);
      case BibleCharacterType.moses:
        _drawMoses(canvas, size, stroke);
      case BibleCharacterType.esther:
        _drawEsther(canvas, size, stroke);
      case BibleCharacterType.david:
        _drawDavid(canvas, size);
      case BibleCharacterType.mary:
        _drawMary(canvas, size, stroke);
    }
  }

  void _drawJesus(Canvas canvas, Size size, Paint stroke) {
    final Path sash = Path()
      ..moveTo(size.width * 0.42, size.height * 0.52)
      ..lineTo(size.width * 0.58, size.height * 0.78);
    canvas.drawPath(
      sash,
      Paint()
        ..color = const Color(0xFFB84C4C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12,
    );
    canvas.drawPath(sash, stroke);
  }

  void _drawMoses(Canvas canvas, Size size, Paint stroke) {
    final Path staff = Path()
      ..moveTo(size.width * 0.73, size.height * 0.17)
      ..lineTo(size.width * 0.73, size.height * 0.82);
    canvas.drawPath(
      staff,
      Paint()
        ..color = const Color(0xFFAA8447)
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(staff, stroke);
  }

  void _drawEsther(Canvas canvas, Size size, Paint stroke) {
    final Paint crownPaint = Paint()..color = const Color(0xFFFFD66E);
    final Path crown = Path()
      ..moveTo(size.width * 0.42, size.height * 0.22)
      ..lineTo(size.width * 0.46, size.height * 0.14)
      ..lineTo(size.width * 0.5, size.height * 0.22)
      ..lineTo(size.width * 0.54, size.height * 0.14)
      ..lineTo(size.width * 0.58, size.height * 0.22)
      ..close();
    canvas.drawPath(crown, crownPaint);
    canvas.drawPath(crown, stroke);
  }

  void _drawDavid(Canvas canvas, Size size) {
    final Paint sling = Paint()
      ..color = const Color(0xFFB0884A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.67, size.height * 0.42),
        width: size.width * 0.2,
        height: size.height * 0.28,
      ),
      math.pi * 0.2,
      math.pi * 0.92,
      false,
      sling,
    );
    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.32),
      8,
      Paint()..color = const Color(0xFFFFD274),
    );
  }

  void _drawMary(Canvas canvas, Size size, Paint stroke) {
    final Path veil = Path()
      ..moveTo(size.width * 0.39, size.height * 0.46)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.2,
        size.width * 0.61,
        size.height * 0.46,
      )
      ..lineTo(size.width * 0.57, size.height * 0.75)
      ..lineTo(size.width * 0.43, size.height * 0.75)
      ..close();
    canvas.drawPath(veil, Paint()..color = const Color(0xFF9CC3E6));
    canvas.drawPath(veil, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
