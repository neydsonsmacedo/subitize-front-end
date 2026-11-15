import 'package:flutter/material.dart';

import '../models/modalidade_jogo.dart';
import '../viewmodels/jogo_bolinhas_viewmodel.dart';
import 'jogo_bolinhas_page.dart';

class _ModalidadeItem {
  final ModalidadeJogo modalidade;
  final String titulo;
  final String subtitulo;
  final IconData icone;
  final Color corDestaque;
  final bool disponivel;

  const _ModalidadeItem({
    required this.modalidade,
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.corDestaque,
    required this.disponivel,
  });
}

class MenuPrincipalPage extends StatelessWidget {
  final JogoBolinhasViewModel viewModel;

  const MenuPrincipalPage({
    super.key,
    required this.viewModel,
  });

  static const List<_ModalidadeItem> _modalidades = [
    _ModalidadeItem(
      modalidade: ModalidadeJogo.classico,
      titulo: 'Modo Clássico',
      subtitulo:
          'Conte rapidamente quantas bolinhas aparecem na tela nos modos Treino ou Arcade.',
      icone: Icons.blur_on_rounded,
      corDestaque: Colors.cyanAccent,
      disponivel: true,
    ),
    _ModalidadeItem(
      modalidade: ModalidadeJogo.quantidadePorFigura,
      titulo: 'Quantidade por Figura',
      subtitulo:
          'Acerte a quantidade da figura que foi sorteada aleatoriamente.',
      icone: Icons.category_outlined,
      corDestaque: Colors.purpleAccent,
      disponivel: false,
    ),
    _ModalidadeItem(
      modalidade: ModalidadeJogo.quantidadePorCor,
      titulo: 'Quantidade por Cor',
      subtitulo:
          'Acerte a quantidade de bolinhas coloridas da cor sorteada aleatoriamente.',
      icone: Icons.palette_outlined,
      corDestaque: Colors.pinkAccent,
      disponivel: false,
    ),
    _ModalidadeItem(
      modalidade: ModalidadeJogo.sequenciaAparicao,
      titulo: 'Sequência de Aparição',
      subtitulo: 'Memorize e acerte a sequência em que as bolinhas surgiram.',
      icone: Icons.format_list_numbered_rounded,
      corDestaque: Colors.lightGreenAccent,
      disponivel: false,
    ),
    _ModalidadeItem(
      modalidade: ModalidadeJogo.memoriaDuasRodadas,
      titulo: 'Comparação 2-Back',
      subtitulo:
          'Diga se a rodada atual é igual ou não à de 2 rodadas anteriores.',
      icone: Icons.compare_arrows_rounded,
      corDestaque: Colors.orangeAccent,
      disponivel: false,
    ),
  ];

  void _abrirModalidade(BuildContext context, ModalidadeJogo modalidade) {
    if (modalidade != ModalidadeJogo.classico) return;

    viewModel.voltarAoMenu();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => JogoBolinhasPage(viewModel: viewModel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'SUBITIZE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Escolha a modalidade',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white60, fontSize: 16),
                  ),
                  const SizedBox(height: 28),
                  for (var i = 0; i < _modalidades.length; i++) ...[
                    if (i > 0) const SizedBox(height: 14),
                    _ModalidadeCard(
                      item: _modalidades[i],
                      onTap: _modalidades[i].disponivel
                          ? () => _abrirModalidade(
                                context,
                                _modalidades[i].modalidade,
                              )
                          : null,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModalidadeCard extends StatelessWidget {
  final _ModalidadeItem item;
  final VoidCallback? onTap;

  const _ModalidadeCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cor = item.corDestaque;
    final opacidade = item.disponivel ? 1.0 : 0.55;

    return Opacity(
      opacity: opacidade,
      child: Material(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: cor.withValues(alpha: item.disponivel ? 0.45 : 0.22),
              ),
            ),
            child: Row(
              children: [
                Icon(item.icone, color: cor, size: 34),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            item.titulo,
                            style: TextStyle(
                              color: cor,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!item.disponivel)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: cor.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: cor.withValues(alpha: 0.45),
                                ),
                              ),
                              child: Text(
                                'Em breve',
                                style: TextStyle(
                                  color: cor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.subtitulo,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  item.disponivel
                      ? Icons.arrow_forward_ios
                      : Icons.lock_outline_rounded,
                  color: cor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
