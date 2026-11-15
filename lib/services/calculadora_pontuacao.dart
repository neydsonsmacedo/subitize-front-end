import '../models/modo_jogo.dart';
import '../models/resultado_rodada.dart';

abstract interface class ICalculadoraPontuacao {
  double calcularMultiplicadorStreak(int streak);

  DetalhesPontuacao calcular({
    required int alvoDaRodada,
    required int palpiteUsuario,
    required Duration tempoExposicao,
    required Duration tempoResposta,
    required int streakAtual,
    required ModoJogo modo,
  });
}

class CalculadoraPontuacaoCognitiva implements ICalculadoraPontuacao {
  static const int _referenciaExposicaoMs = 500;
  static const int _limiteRapidezMaximaMs = 800;
  static const int _limiteRapidezMinimaMs = 3000;
  static const double _tetoMultiplicadorStreak = 3.0;
  static const double _percentualProximidadeTreino = 0.30;

  const CalculadoraPontuacaoCognitiva();

  /// Complexidade (Subitizing <= 4 vs Pattern Grouping >= 5).
  int _calcularBaseN(int n) {
    if (n <= 4) {
      return n * 100;
    }
    return n * n * 25;
  }

  /// Dificuldade de exposição: 500ms / T_exp.
  double _calcularFatorExposicao(Duration tempoExposicao) {
    final ms = tempoExposicao.inMilliseconds.clamp(50, 10000);
    return _referenciaExposicaoMs / ms;
  }

  /// Decaimento suave entre 1.5x (<= 0.8s) até 1.0x (>= 3.0s).
  double _calcularBonusRapidez(Duration tempoResposta) {
    final ms = tempoResposta.inMilliseconds;
    if (ms <= _limiteRapidezMaximaMs) return 1.5;
    if (ms >= _limiteRapidezMinimaMs) return 1.0;

    final progresso =
        (ms - _limiteRapidezMaximaMs) /
        (_limiteRapidezMinimaMs - _limiteRapidezMaximaMs);
    return 1.5 - (0.5 * progresso);
  }

  /// Progressão: 1 -> 1.0x, 2 -> 1.2x, 3 -> 1.5x, depois +0.3x até teto de 3.0x.
  @override
  double calcularMultiplicadorStreak(int streak) {
    if (streak <= 1) return 1.0;
    if (streak == 2) return 1.2;
    if (streak == 3) return 1.5;

    final calculado = 1.5 + ((streak - 3) * 0.3);
    return calculado.clamp(1.0, _tetoMultiplicadorStreak);
  }

  @override
  DetalhesPontuacao calcular({
    required int alvoDaRodada,
    required int palpiteUsuario,
    required Duration tempoExposicao,
    required Duration tempoResposta,
    required int streakAtual,
    required ModoJogo modo,
  }) {
    final baseN = _calcularBaseN(alvoDaRodada);
    final fatorExposicao = _calcularFatorExposicao(tempoExposicao);
    final bonusRapidez = _calcularBonusRapidez(tempoResposta);
    final erro = (alvoDaRodada - palpiteUsuario).abs();

    if (erro == 0) {
      final multiplicadorStreak = calcularMultiplicadorStreak(streakAtual);
      final pontos =
          (baseN * fatorExposicao * bonusRapidez * multiplicadorStreak).round();

      return DetalhesPontuacao(
        baseN: baseN,
        fatorExposicao: fatorExposicao,
        bonusRapidez: bonusRapidez,
        multiplicadorStreak: multiplicadorStreak,
        pontosFinais: pontos,
      );
    }

    if (modo == ModoJogo.treino && erro == 1) {
      final pontosParciais = (baseN * _percentualProximidadeTreino).round();
      return DetalhesPontuacao(
        baseN: baseN,
        fatorExposicao: fatorExposicao,
        bonusRapidez: bonusRapidez,
        multiplicadorStreak: 1.0,
        pontosFinais: pontosParciais,
      );
    }

    return DetalhesPontuacao(
      baseN: baseN,
      fatorExposicao: fatorExposicao,
      bonusRapidez: bonusRapidez,
      multiplicadorStreak: 1.0,
      pontosFinais: 0,
    );
  }
}
