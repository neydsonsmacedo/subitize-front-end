import 'dart:math';

abstract interface class ISorteadorQuantidade {
  int sortear({required int min, required int max, int? excluir});
}

class SorteadorQuantidadeAleatoria implements ISorteadorQuantidade {
  final Random _random;

  SorteadorQuantidadeAleatoria({Random? random}) : _random = random ?? Random();

  @override
  int sortear({required int min, required int max, int? excluir}) {
    if (excluir != null && max > min && excluir >= min && excluir <= max) {
      final sorteado = min + _random.nextInt(max - min);
      return sorteado >= excluir ? sorteado + 1 : sorteado;
    }
    return min + _random.nextInt(max - min + 1);
  }
}
