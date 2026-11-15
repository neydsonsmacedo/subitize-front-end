import 'modo_jogo.dart';

class ConfiguracaoJogo {
  final int minBolinhas;
  final int maxBolinhas;
  final Duration atrasoInicial;
  final Duration tempoDeExposicao;
  final Duration duracaoFeedback;
  final double margemSegura;
  final double distanciaMinima;
  final double raioBolinha;
  final int maxTentativasPosicionamento;
  final int vidasIniciais;
  final ModoJogo modoPadrao;

  const ConfiguracaoJogo({
    this.minBolinhas = 1,
    this.maxBolinhas = 11,
    this.atrasoInicial = const Duration(milliseconds: 600),
    this.tempoDeExposicao = const Duration(milliseconds: 350),
    this.duracaoFeedback = const Duration(milliseconds: 850),
    this.margemSegura = 0.14,
    this.distanciaMinima = 0.16,
    this.raioBolinha = 18.0,
    this.maxTentativasPosicionamento = 100,
    this.vidasIniciais = 3,
    this.modoPadrao = ModoJogo.treino,
  });

  Duration get fimDaExposicao => atrasoInicial + tempoDeExposicao;
}
