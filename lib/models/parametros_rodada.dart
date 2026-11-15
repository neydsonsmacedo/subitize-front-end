class ParametrosRodada {
  final int minBolinhas;
  final int maxBolinhas;
  final Duration tempoDeExposicao;
  final bool exibirPontoFixacao;
  final bool evitarRepeticao;

  const ParametrosRodada({
    required this.minBolinhas,
    required this.maxBolinhas,
    required this.tempoDeExposicao,
    required this.exibirPontoFixacao,
    required this.evitarRepeticao,
  });
}
