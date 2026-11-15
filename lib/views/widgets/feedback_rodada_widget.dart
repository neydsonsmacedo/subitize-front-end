import 'package:flutter/material.dart';

import '../../models/resultado_rodada.dart';

class FeedbackRodadaWidget extends StatelessWidget {
  final ResultadoRodada resultado;

  const FeedbackRodadaWidget({
    super.key,
    required this.resultado,
  });

  @override
  Widget build(BuildContext context) {
    final (texto, icone, cor) = switch (resultado.tipoAcerto) {
      TipoAcerto.exato => (
        'Acertou!',
        Icons.check_circle_outline,
        Colors.greenAccent,
      ),
      TipoAcerto.parcial => (
        'Quase! (±1)',
        Icons.adjust_rounded,
        Colors.amberAccent,
      ),
      TipoAcerto.erro => ('Errou!', Icons.cancel_outlined, Colors.redAccent),
    };

    final labelBolinhas = resultado.alvoDaRodada == 1 ? 'bolinha' : 'bolinhas';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, color: cor, size: 56),
          const SizedBox(height: 12),
          Text(
            texto,
            style: TextStyle(
              color: cor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${resultado.alvoDaRodada} $labelBolinhas',
            style: TextStyle(
              color: cor,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
