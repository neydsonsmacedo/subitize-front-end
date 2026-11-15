import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/estado_jogo.dart';
import '../models/modo_jogo.dart';
import '../viewmodels/jogo_bolinhas_viewmodel.dart';
import 'widgets/bolinhas_painter.dart';
import 'widgets/feedback_rodada_widget.dart';
import 'widgets/menu_inicial_widget.dart';
import 'widgets/placar_hud_widget.dart';
import 'widgets/resultado_rodada_widget.dart';
import 'widgets/teclado_resposta_widget.dart';
import 'widgets/vidas_hud_widget.dart';

class JogoBolinhasPage extends StatefulWidget {
  final JogoBolinhasViewModel viewModel;

  const JogoBolinhasPage({
    super.key,
    required this.viewModel,
  });

  @override
  State<JogoBolinhasPage> createState() => _JogoBolinhasPageState();
}

class _JogoBolinhasPageState extends State<JogoBolinhasPage>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  JogoBolinhasViewModel get _vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  void _iniciarComModo(ModoJogo modo) {
    _ticker.stop();
    _vm.selecionarModoEIniciar(modo);
    _ticker.start();
  }

  void _iniciarRodada() {
    _ticker.stop();
    _vm.iniciarRodada();
    _ticker.start();
  }

  void _voltarAoMenu() {
    _ticker.stop();
    _vm.voltarAoMenu();
  }

  void _registrarPalpite(int palpite) {
    final continuar = _vm.registrarPalpite(palpite);
    if (continuar) {
      _ticker.stop();
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    final estadoAnterior = _vm.estado;
    final continuar = _vm.processarTick(elapsed);
    if (!continuar) {
      _ticker.stop();
    } else if (estadoAnterior == EstadoJogo.feedback &&
        _vm.estado == EstadoJogo.jogando) {
      _ticker.stop();
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: BolinhasPainter(
                  bolinhasListenable: _vm.bolinhasVisiveis,
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _vm.pontoFixacaoVisivel,
              builder: (context, visivel, _) {
                if (!visivel) return const SizedBox.shrink();
                return const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white38,
                    size: 28,
                  ),
                );
              },
            ),
            ListenableBuilder(
              listenable: _vm,
              builder: (context, _) {
                final conteudo = switch (_vm.estado) {
                  EstadoJogo.menu => MenuInicialWidget(
                    onSelecionarModo: _iniciarComModo,
                    onVoltar: () => Navigator.of(context).maybePop(),
                  ),
                  EstadoJogo.jogando => const SizedBox.expand(),
                  EstadoJogo.feedback => FeedbackRodadaWidget(
                    resultado: _vm.ultimoResultado!,
                  ),
                  EstadoJogo.respondendo => TecladoRespostaWidget(
                    minOpcao: _vm.configuracao.minBolinhas,
                    maxOpcao: _vm.configuracao.maxBolinhas,
                    onSelecionarNumero: _registrarPalpite,
                  ),
                  EstadoJogo.resultado => ResultadoRodadaWidget(
                    resultado: _vm.ultimoResultado!,
                    pontuacaoTotal: _vm.pontuacaoTotal,
                    onJogarNovamente: _iniciarRodada,
                    onVoltarAoMenu: _voltarAoMenu,
                  ),
                };

                if (_vm.estado == EstadoJogo.menu) {
                  return conteudo;
                }

                return Column(
                  children: [
                    if (_vm.estado != EstadoJogo.jogando)
                      PlacarHudWidget(
                        modo: _vm.modoAtual,
                        pontuacaoTotal: _vm.pontuacaoTotal,
                        streak: _vm.streak,
                        multiplicador: _vm.multiplicadorAtual,
                        onVoltarAoMenu: _voltarAoMenu,
                      ),
                    Expanded(child: conteudo),
                    if (_vm.estado != EstadoJogo.jogando)
                      VidasHudWidget(
                        vidasRestantes: _vm.vidasRestantes,
                        vidasTotais: _vm.configuracao.vidasIniciais,
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
