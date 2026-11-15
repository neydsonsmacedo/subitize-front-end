import 'dart:ui';

class Bolinha {
  final Offset posicaoNormalizada; // Valores entre 0.0 e 1.0
  final double raio;

  const Bolinha({
    required this.posicaoNormalizada,
    required this.raio,
  });
}
