import 'modo_jogo.dart';

enum TipoAcerto {
  exato,
  parcial,
  erro,
}

class DetalhesPontuacao {
  final int baseN;
  final double fatorExposicao;
  final double bonusRapidez;
  final double multiplicadorStreak;
  final int pontosFinais;

  const DetalhesPontuacao({
    required this.baseN,
    required this.fatorExposicao,
    required this.bonusRapidez,
    required this.multiplicadorStreak,
    required this.pontosFinais,
  });
}

class ResultadoRodada {
  final int alvoDaRodada;
  final int palpiteUsuario;
  final ModoJogo modo;
  final Duration tempoResposta;
  final TipoAcerto tipoAcerto;
  final DetalhesPontuacao detalhesPontuacao;
  final int streakAtual;
  final int vidasRestantes;
  final bool gameOver;

  const ResultadoRodada({
    required this.alvoDaRodada,
    required this.palpiteUsuario,
    required this.modo,
    required this.tempoResposta,
    required this.tipoAcerto,
    required this.detalhesPontuacao,
    required this.streakAtual,
    required this.vidasRestantes,
    required this.gameOver,
  });

  bool get acertou => tipoAcerto == TipoAcerto.exato;
  int get diferenca => (alvoDaRodada - palpiteUsuario).abs();
}
