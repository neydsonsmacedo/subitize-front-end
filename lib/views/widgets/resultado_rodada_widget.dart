import 'package:flutter/material.dart';

import '../../models/modo_jogo.dart';
import '../../models/resultado_rodada.dart';

class ResultadoRodadaWidget extends StatelessWidget {
  final ResultadoRodada resultado;
  final int pontuacaoTotal;
  final VoidCallback onJogarNovamente;
  final VoidCallback onVoltarAoMenu;

  const ResultadoRodadaWidget({
    super.key,
    required this.resultado,
    required this.pontuacaoTotal,
    required this.onJogarNovamente,
    required this.onVoltarAoMenu,
  });

  @override
  Widget build(BuildContext context) {
    final nomeModo = resultado.modo == ModoJogo.arcade ? 'Arcade' : 'Treino';

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Fim de Jogo!',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Modo $nomeModo • Última rodada: ${resultado.alvoDaRodada} bolinhas (você escolheu ${resultado.palpiteUsuario})',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Pontuação Final',
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$pontuacaoTotal pts',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white24),
                    ),
                    onPressed: onVoltarAoMenu,
                    child: const Text('Trocar Modo'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: onJogarNovamente,
                    child: const Text('Jogar Novamente'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
