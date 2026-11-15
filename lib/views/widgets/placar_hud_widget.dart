import 'package:flutter/material.dart';

import '../../models/modo_jogo.dart';

class PlacarHudWidget extends StatelessWidget {
  final ModoJogo modo;
  final int pontuacaoTotal;
  final int streak;
  final double multiplicador;
  final VoidCallback onVoltarAoMenu;

  const PlacarHudWidget({
    super.key,
    required this.modo,
    required this.pontuacaoTotal,
    required this.streak,
    required this.multiplicador,
    required this.onVoltarAoMenu,
  });

  @override
  Widget build(BuildContext context) {
    final isArcade = modo == ModoJogo.arcade;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onVoltarAoMenu,
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white70,
                  ),
                  tooltip: 'Voltar ao Menu',
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isArcade
                        ? Colors.amberAccent.withValues(alpha: 0.18)
                        : Colors.cyanAccent.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isArcade ? 'ARCADE' : 'TREINO',
                    style: TextStyle(
                      color: isArcade ? Colors.amberAccent : Colors.cyanAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$pontuacaoTotal pts',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Streak: $streak (${multiplicador.toStringAsFixed(1)}x)',
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
