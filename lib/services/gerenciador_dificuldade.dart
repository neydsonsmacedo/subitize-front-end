import '../models/configuracao_jogo.dart';
import '../models/modo_jogo.dart';
import '../models/parametros_rodada.dart';

abstract interface class IGerenciadorDificuldade {
  ParametrosRodada obterParametros({
    required ModoJogo modo,
    required int numeroRodada,
    required ConfiguracaoJogo configuracao,
  });
}

class GerenciadorDificuldadePorModo implements IGerenciadorDificuldade {
  const GerenciadorDificuldadePorModo();

  Duration _exposicaoArcadePorRodada(int numeroRodada) {
    if (numeroRodada <= 5) return const Duration(milliseconds: 350);
    if (numeroRodada <= 10) return const Duration(milliseconds: 300);
    if (numeroRodada <= 15) return const Duration(milliseconds: 250);
    return const Duration(milliseconds: 200);
  }

  @override
  ParametrosRodada obterParametros({
    required ModoJogo modo,
    required int numeroRodada,
    required ConfiguracaoJogo configuracao,
  }) {
    if (modo == ModoJogo.arcade) {
      return ParametrosRodada(
        minBolinhas: configuracao.minBolinhas,
        maxBolinhas: configuracao.maxBolinhas,
        tempoDeExposicao: _exposicaoArcadePorRodada(numeroRodada),
        exibirPontoFixacao: false,
        evitarRepeticao: false,
      );
    }

    // Modo Treino: curva de progressão + ponto de fixação + anti-repetição
    if (numeroRodada <= 3) {
      return ParametrosRodada(
        minBolinhas: configuracao.minBolinhas,
        maxBolinhas: 4.clamp(configuracao.minBolinhas, configuracao.maxBolinhas),
        tempoDeExposicao: const Duration(milliseconds: 500),
        exibirPontoFixacao: true,
        evitarRepeticao: true,
      );
    }

    if (numeroRodada <= 7) {
      return ParametrosRodada(
        minBolinhas: 4.clamp(configuracao.minBolinhas, configuracao.maxBolinhas),
        maxBolinhas: 8.clamp(configuracao.minBolinhas, configuracao.maxBolinhas),
        tempoDeExposicao: const Duration(milliseconds: 350),
        exibirPontoFixacao: true,
        evitarRepeticao: true,
      );
    }

    if (numeroRodada <= 11) {
      return ParametrosRodada(
        minBolinhas: 5.clamp(configuracao.minBolinhas, configuracao.maxBolinhas),
        maxBolinhas: configuracao.maxBolinhas,
        tempoDeExposicao: const Duration(milliseconds: 250),
        exibirPontoFixacao: true,
        evitarRepeticao: true,
      );
    }

    return ParametrosRodada(
      minBolinhas: configuracao.minBolinhas,
      maxBolinhas: configuracao.maxBolinhas,
      tempoDeExposicao: const Duration(milliseconds: 220),
      exibirPontoFixacao: true,
      evitarRepeticao: true,
    );
  }
}
