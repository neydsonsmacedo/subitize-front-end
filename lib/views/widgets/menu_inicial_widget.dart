import 'package:flutter/material.dart';

import '../../models/modo_jogo.dart';

class MenuInicialWidget extends StatelessWidget {
  final ValueChanged<ModoJogo> onSelecionarModo;
  final VoidCallback? onVoltar;

  const MenuInicialWidget({
    super.key,
    required this.onSelecionarModo,
    this.onVoltar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'MODO CLÁSSICO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Escolha o modo de jogo',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 16),
              ),
              const SizedBox(height: 32),
              _ModoCard(
                titulo: 'Casual',
                subtitulo:
                    '3 vidas • Tolerância de ±1 bolinha (não perde vida e ganha 30% da base).',
                icone: Icons.psychology_outlined,
                corDestaque: Colors.cyanAccent,
                onTap: () => onSelecionarModo(ModoJogo.treino),
              ),
              const SizedBox(height: 16),
              _ModoCard(
                titulo: 'Competitivo',
                subtitulo:
                    '3 vidas • Quantidade aleatória (1 a 11) com aceleração igual para todos por rodada. ±1 zera o Streak sem perder vida.',
                icone: Icons.bolt_rounded,
                corDestaque: Colors.amberAccent,
                onTap: () => onSelecionarModo(ModoJogo.arcade),
              ),
              if (onVoltar != null) ...[
                const SizedBox(height: 24),
                TextButton.icon(
                  onPressed: onVoltar,
                  icon: const Icon(Icons.arrow_back, color: Colors.white70),
                  label: const Text(
                    'Voltar às modalidades',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ModoCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icone;
  final Color corDestaque;
  final VoidCallback onTap;

  const _ModoCard({
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.corDestaque,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: corDestaque.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Icon(icone, color: corDestaque, size: 36),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        color: corDestaque,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitulo,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, color: corDestaque, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
