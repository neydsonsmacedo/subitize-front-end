import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/bolinha.dart';

class BolinhasPainter extends CustomPainter {
  final ValueListenable<List<Bolinha>> bolinhasListenable;

  BolinhasPainter({required this.bolinhasListenable})
    : super(repaint: bolinhasListenable);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final bolinha in bolinhasListenable.value) {
      final centro = Offset(
        bolinha.posicaoNormalizada.dx * size.width,
        bolinha.posicaoNormalizada.dy * size.height,
      );
      canvas.drawCircle(centro, bolinha.raio, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BolinhasPainter oldDelegate) =>
      oldDelegate.bolinhasListenable != bolinhasListenable;
}
