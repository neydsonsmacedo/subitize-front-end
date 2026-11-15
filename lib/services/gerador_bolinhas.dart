import 'dart:math';
import 'dart:ui';

import '../models/bolinha.dart';
import '../models/configuracao_jogo.dart';

abstract interface class IGeradorBolinhas {
  List<Bolinha> gerarLote({
    required int quantidade,
    required ConfiguracaoJogo configuracao,
  });
}

class GeradorBolinhasSemSobreposicao implements IGeradorBolinhas {
  final Random _random;

  GeradorBolinhasSemSobreposicao({Random? random})
    : _random = random ?? Random();

  @override
  List<Bolinha> gerarLote({
    required int quantidade,
    required ConfiguracaoJogo configuracao,
  }) {
    final List<Bolinha> geradas = [];
    final double margem = configuracao.margemSegura;
    final double distanciaMinima = configuracao.distanciaMinima;

    for (int i = 0; i < quantidade; i++) {
      Offset candidata;
      int tentativas = 0;

      do {
        candidata = Offset(
          margem + _random.nextDouble() * (1 - 2 * margem),
          margem + _random.nextDouble() * (1 - 2 * margem),
        );
        tentativas++;
      } while (tentativas < configuracao.maxTentativasPosicionamento &&
          geradas.any(
            (b) =>
                (b.posicaoNormalizada - candidata).distance < distanciaMinima,
          ));

      geradas.add(
        Bolinha(
          posicaoNormalizada: candidata,
          raio: configuracao.raioBolinha,
        ),
      );
    }

    return List.unmodifiable(geradas);
  }
}
