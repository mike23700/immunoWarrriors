// HoloSimulateurCombat amélioré avec toutes les fonctionnalités demandées
import 'dart:math';
import 'package:flutter/material.dart';

class HoloSimulateurCombat extends StatefulWidget {
  const HoloSimulateurCombat({Key? key}) : super(key: key);

  @override
  State<HoloSimulateurCombat> createState() => _HoloSimulateurCombatState();
}

class _HoloSimulateurCombatState extends State<HoloSimulateurCombat>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Unit> immuneUnits = [];
  List<Unit> enemyUnits = [];
  List<FloatingDamage> damages = [];
  List<String> combatLog = [];
  bool combatEnded = false;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(hours: 1))
      ..addListener(() {
        updateSimulation();
      })
      ..repeat();

    immuneUnits = List.generate(
      5,
      (index) => Unit(
        name: 'Anticorps ${index + 1}',
        position: Offset(100, 100.0 + index * 60),
        direction: Offset(1, 0),
        color: Colors.cyanAccent,
        isImmune: true,
      ),
    );

    enemyUnits = List.generate(
      5,
      (index) => Unit(
        name: 'Pathogène ${index + 1}',
        position: Offset(600, 100.0 + index * 60),
        direction: Offset(-1, 0),
        color: Colors.pinkAccent,
        isImmune: false,
      ),
    );
  }

  void updateSimulation() {
    setState(() {
      for (var unit in [...immuneUnits, ...enemyUnits]) {
        unit.move();
      }

      for (var unit in immuneUnits) {
        if (enemyUnits.isNotEmpty) {
          var target = enemyUnits[random.nextInt(enemyUnits.length)];
          target.hp -= 1;
          damages.add(FloatingDamage(position: target.position, amount: '-1'));
          combatLog.add('${unit.name} attaque ${target.name}');
          if (target.hp <= 0) {
            combatLog.add('${target.name} a été détruit.');
            enemyUnits.remove(target);
          }
        }
      }

      for (var unit in enemyUnits) {
        if (immuneUnits.isNotEmpty) {
          var target = immuneUnits[random.nextInt(immuneUnits.length)];
          target.hp -= 1;
          damages.add(FloatingDamage(position: target.position, amount: '-1'));
          combatLog.add('${unit.name} attaque ${target.name}');
          if (target.hp <= 0) {
            combatLog.add('${target.name} a été détruit.');
            immuneUnits.remove(target);
          }
        }
      }

      damages.forEach((d) => d.update());
      damages.removeWhere((d) => d.opacity <= 0);

      if ((immuneUnits.isEmpty || enemyUnits.isEmpty) && !combatEnded) {
        combatEnded = true;
        _controller.stop();
        combatLog.add('--- Fin du combat ---');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("HoloSimulateur Combat",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 8),
          Text("Status : ${combatEnded ? 'Terminé' : 'En cours...'}",
              style: TextStyle(color: combatEnded ? Colors.red : Colors.greenAccent)),
          const Text("Tactique : Défensive",
              style: TextStyle(color: Colors.cyanAccent)),
          const SizedBox(height: 12),
          const Text("Chroniques de combat :",
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 4),
          SizedBox(
            height: 120,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: combatLog.map((e) => Text(e, style: const TextStyle(color: Colors.grey, fontSize: 12))).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 700,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blueGrey.shade900,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: CustomPaint(
                painter: CombatPainter(
                  immuneUnits: immuneUnits,
                  enemyUnits: enemyUnits,
                  damages: damages,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 30,
            child: buildControlPanel(),
          ),
        ],
      ),
    );
  }
}

class Unit {
  Offset position;
  Offset direction;
  final Color color;
  final String name;
  int hp = 10;
  final double speed = 0.5;
  final bool isImmune;

  Unit({
    required this.name,
    required this.position,
    required this.direction,
    required this.color,
    required this.isImmune,
  });

  void move() {
    position += direction * speed;
  }
}

class FloatingDamage {
  Offset position;
  String amount;
  double opacity = 1.0;
  double rise = 0.0;

  FloatingDamage({required this.position, required this.amount});

  void update() {
    rise += 0.5;
    opacity -= 0.02;
  }
}

class CombatPainter extends CustomPainter {
  final List<Unit> immuneUnits;
  final List<Unit> enemyUnits;
  final List<FloatingDamage> damages;

  CombatPainter({required this.immuneUnits, required this.enemyUnits, required this.damages});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.1)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (var unit in [...immuneUnits, ...enemyUnits]) {
      final paint = Paint()..color = unit.color;
      if (unit.isImmune) {
        canvas.drawCircle(unit.position, 10, paint);
      } else {
        canvas.drawRect(
            Rect.fromCenter(center: unit.position, width: 20, height: 20), paint);
      }

      // Draw HP bar
      final hpBarWidth = 30.0;
      final hpBarHeight = 4.0;
      final hpBarX = unit.position.dx - hpBarWidth / 2;
      final hpBarY = unit.position.dy - 18;

      final hpBackground = Paint()..color = Colors.grey;
      final hpForeground = Paint()..color = Colors.greenAccent;
      canvas.drawRect(
          Rect.fromLTWH(hpBarX, hpBarY, hpBarWidth, hpBarHeight), hpBackground);
      canvas.drawRect(
          Rect.fromLTWH(hpBarX, hpBarY, hpBarWidth * (unit.hp / 10), hpBarHeight), hpForeground);
    }

    for (var damage in damages) {
      final textStyle = TextStyle(color: Colors.red.withOpacity(damage.opacity), fontSize: 12);
      final painter = TextPainter(
        text: TextSpan(text: damage.amount, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      painter.layout();
      painter.paint(canvas, damage.position.translate(-8, -20 - damage.rise));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
