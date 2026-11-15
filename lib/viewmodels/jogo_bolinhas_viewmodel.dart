import 'package:flutter/foundation.dart';

import '../models/bolinha.dart';
import '../models/configuracao_jogo.dart';
import '../models/estado_jogo.dart';
import '../models/modo_jogo.dart';
import '../models/parametros_rodada.dart';
import '../models/resultado_rodada.dart';
import '../services/calculadora_pontuacao.dart';
import '../services/gerador_bolinhas.dart';
import '../services/gerenciador_dificuldade.dart';
import '../services/sorteador_quantidade.dart';

class JogoBolinhasViewModel extends ChangeNotifier {
  final IGeradorBolinhas _geradorBolinhas;
  final ISorteadorQuantidade _sorteadorQuantidade;
  final ICalculadoraPontuacao _calculadoraPontuacao;
  final IGerenciadorDificuldade _gerenciadorDificuldade;
  final ConfiguracaoJogo configuracao;
  final DateTime Function() _agora;

  final ValueNotifier<List<Bolinha>> _bolinhasVisiveis = ValueNotifier(const []);
  ValueListenable<List<Bolinha>> get bolinhasVisiveis => _bolinhasVisiveis;

  final ValueNotifier<bool> _pontoFixacaoVisivel = ValueNotifier(false);
  ValueListenable<bool> get pontoFixacaoVisivel => _pontoFixacaoVisivel;

  EstadoJogo _estado = EstadoJogo.menu;
  EstadoJogo get estado => _estado;

  late ModoJogo _modoAtual;
  ModoJogo get modoAtual => _modoAtual;

  int _pontuacaoTotal = 0;
  int get pontuacaoTotal => _pontuacaoTotal;

  int _streak = 0;
  int get streak => _streak;

  int _vidasRestantes = 0;
  int get vidasRestantes => _vidasRestantes;

  int _numeroRodada = 0;
  int get numeroRodada => _numeroRodada;

  double get multiplicadorAtual =>
      _calculadoraPontuacao.calcularMultiplicadorStreak(_streak);

  ResultadoRodada? _ultimoResultado;
  ResultadoRodada? get ultimoResultado => _ultimoResultado;

  List<Bolinha> _bolinhasDaRodada = const [];
  int _alvoDaRodada = 0;
  int? _ultimoAlvo;
  bool _jaExibiu = false;
  DateTime? _inicioResposta;
  late ParametrosRodada _parametrosRodadaAtual;

  JogoBolinhasViewModel({
    required IGeradorBolinhas geradorBolinhas,
    required ISorteadorQuantidade sorteadorQuantidade,
    ICalculadoraPontuacao calculadoraPontuacao =
        const CalculadoraPontuacaoCognitiva(),
    IGerenciadorDificuldade gerenciadorDificuldade =
        const GerenciadorDificuldadePorModo(),
    this.configuracao = const ConfiguracaoJogo(),
    DateTime Function()? agora,
  }) : _geradorBolinhas = geradorBolinhas,
       _sorteadorQuantidade = sorteadorQuantidade,
       _calculadoraPontuacao = calculadoraPontuacao,
       _gerenciadorDificuldade = gerenciadorDificuldade,
       _agora = agora ?? DateTime.now {
    _modoAtual = configuracao.modoPadrao;
    _vidasRestantes = configuracao.vidasIniciais;
    _parametrosRodadaAtual = _gerenciadorDificuldade.obterParametros(
      modo: _modoAtual,
      numeroRodada: 1,
      configuracao: configuracao,
    );
  }

  void selecionarModoEIniciar(ModoJogo modo) {
    _modoAtual = modo;
    _reiniciarSessao();
    iniciarRodada();
  }

  void _reiniciarSessao() {
    _pontuacaoTotal = 0;
    _streak = 0;
    _numeroRodada = 0;
    _ultimoAlvo = null;
    _vidasRestantes = configuracao.vidasIniciais;
  }

  void iniciarRodada() {
    if (_vidasRestantes <= 0) {
      _reiniciarSessao();
    }

    _numeroRodada++;
    _parametrosRodadaAtual = _gerenciadorDificuldade.obterParametros(
      modo: _modoAtual,
      numeroRodada: _numeroRodada,
      configuracao: configuracao,
    );

    _alvoDaRodada = _sorteadorQuantidade.sortear(
      min: _parametrosRodadaAtual.minBolinhas,
      max: _parametrosRodadaAtual.maxBolinhas,
      excluir: _parametrosRodadaAtual.evitarRepeticao ? _ultimoAlvo : null,
    );
    _ultimoAlvo = _alvoDaRodada;
    _ultimoResultado = null;
    _jaExibiu = false;
    _inicioResposta = null;
    _bolinhasVisiveis.value = const [];
    _pontoFixacaoVisivel.value = _parametrosRodadaAtual.exibirPontoFixacao;

    _bolinhasDaRodada = _geradorBolinhas.gerarLote(
      quantidade: _alvoDaRodada,
      configuracao: configuracao,
    );

    _estado = EstadoJogo.jogando;
    notifyListeners();
  }

  void voltarAoMenu() {
    _bolinhasVisiveis.value = const [];
    _pontoFixacaoVisivel.value = false;
    _inicioResposta = null;
    _estado = EstadoJogo.menu;
    notifyListeners();
  }

  /// Atualiza o estado da exposição ou do feedback conforme o tempo do Ticker.
  /// Retorna `true` enquanto o Ticker precisa continuar ativo.
  bool processarTick(Duration elapsed) {
    if (_estado == EstadoJogo.feedback) {
      if (elapsed < configuracao.duracaoFeedback) {
        return true;
      }
      iniciarRodada();
      return true;
    }

    if (_estado != EstadoJogo.jogando) return false;

    final fimDaExposicao =
        configuracao.atrasoInicial + _parametrosRodadaAtual.tempoDeExposicao;

    // Fase 1: Aguarda o atraso inicial na tela preta para o jogador focar
    if (elapsed < configuracao.atrasoInicial) {
      return true;
    }

    // Fase 2: Mostra TODAS as bolinhas de uma vez e oculta o ponto de fixação
    if (elapsed < fimDaExposicao) {
      if (!_jaExibiu) {
        _pontoFixacaoVisivel.value = false;
        _bolinhasVisiveis.value = _bolinhasDaRodada;
        _jaExibiu = true;
      }
      return true;
    }

    // Fase 3: Apaga todas as bolinhas e solicita a resposta
    _pontoFixacaoVisivel.value = false;
    _bolinhasVisiveis.value = const [];
    _inicioResposta = _agora();
    _estado = EstadoJogo.respondendo;
    notifyListeners();
    return false;
  }

  /// Registra o palpite do usuário e atualiza pontuação, streak e vidas.
  /// Retorna `true` se o jogo continua para a próxima rodada imediatamente,
  /// ou `false` se as vidas acabaram (Game Over).
  bool registrarPalpite(int palpite) {
    if (_estado != EstadoJogo.respondendo) return false;

    final tempoResposta = _inicioResposta != null
        ? _agora().difference(_inicioResposta!)
        : Duration.zero;
    final erro = (_alvoDaRodada - palpite).abs();

    final TipoAcerto tipoAcerto;
    if (erro == 0) {
      tipoAcerto = TipoAcerto.exato;
      _streak++;
    } else if (erro == 1) {
      // Erro de ±1 zera o streak em ambos os modos, sem perder vida
      tipoAcerto = TipoAcerto.parcial;
      _streak = 0;
    } else {
      tipoAcerto = TipoAcerto.erro;
      _streak = 0;
      _vidasRestantes = (_vidasRestantes - 1).clamp(
        0,
        configuracao.vidasIniciais,
      );
    }

    final detalhes = _calculadoraPontuacao.calcular(
      alvoDaRodada: _alvoDaRodada,
      palpiteUsuario: palpite,
      tempoExposicao: _parametrosRodadaAtual.tempoDeExposicao,
      tempoResposta: tempoResposta,
      streakAtual: _streak,
      modo: _modoAtual,
    );

    _pontuacaoTotal += detalhes.pontosFinais;

    final isGameOver = _vidasRestantes <= 0;

    final resultado = ResultadoRodada(
      alvoDaRodada: _alvoDaRodada,
      palpiteUsuario: palpite,
      modo: _modoAtual,
      tempoResposta: tempoResposta,
      tipoAcerto: tipoAcerto,
      detalhesPontuacao: detalhes,
      streakAtual: _streak,
      vidasRestantes: _vidasRestantes,
      gameOver: isGameOver,
    );

    _ultimoResultado = resultado;

    if (isGameOver) {
      _estado = EstadoJogo.resultado;
      notifyListeners();
      return false;
    }

    _estado = EstadoJogo.feedback;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    _bolinhasVisiveis.dispose();
    _pontoFixacaoVisivel.dispose();
    super.dispose();
  }
}
