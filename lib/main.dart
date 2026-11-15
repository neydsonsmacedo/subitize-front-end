import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'models/configuracao_jogo.dart';
import 'services/calculadora_pontuacao.dart';
import 'services/gerador_bolinhas.dart';
import 'services/gerenciador_dificuldade.dart';
import 'services/sorteador_quantidade.dart';
import 'viewmodels/jogo_bolinhas_viewmodel.dart';
import 'views/menu_principal_page.dart';

void main() {
  final viewModel = JogoBolinhasViewModel(
    geradorBolinhas: GeradorBolinhasSemSobreposicao(),
    sorteadorQuantidade: SorteadorQuantidadeAleatoria(),
    calculadoraPontuacao: const CalculadoraPontuacaoCognitiva(),
    gerenciadorDificuldade: const GerenciadorDificuldadePorModo(),
    configuracao: const ConfiguracaoJogo(),
  );

  runApp(SubitizeApp(viewModel: viewModel));
}

class SubitizeApp extends StatelessWidget {
  final JogoBolinhasViewModel viewModel;

  const SubitizeApp({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final content = child ?? const SizedBox.shrink();
        if (!kIsWeb) return content;

        return ColoredBox(
          color: Colors.black,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: content,
            ),
          ),
        );
      },
      home: MenuPrincipalPage(viewModel: viewModel),
    );
  }
}
