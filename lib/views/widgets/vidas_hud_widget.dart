import 'package:flutter/material.dart';

class VidasHudWidget extends StatelessWidget {
  final int vidasRestantes;
  final int vidasTotais;

  const VidasHudWidget({
    super.key,
    required this.vidasRestantes,
    required this.vidasTotais,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(vidasTotais, (index) {
          final ativa = index < vidasRestantes;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              ativa ? Icons.favorite : Icons.favorite_border,
              color: ativa ? Colors.redAccent : Colors.white24,
              size: 26,
            ),
          );
        }),
      ),
    );
  }
}
