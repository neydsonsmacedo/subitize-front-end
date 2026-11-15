import 'package:flutter/material.dart';

class TecladoRespostaWidget extends StatelessWidget {
  final int minOpcao;
  final int maxOpcao;
  final ValueChanged<int> onSelecionarNumero;

  const TecladoRespostaWidget({
    super.key,
    required this.minOpcao,
    required this.maxOpcao,
    required this.onSelecionarNumero,
  });

  @override
  Widget build(BuildContext context) {
    final totalOpcoes = maxOpcao - minOpcao + 1;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Quantas bolinhas apareceram?',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: List.generate(totalOpcoes, (index) {
                final numero = minOpcao + index;
                return SizedBox(
                  width: 60,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white12,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () => onSelecionarNumero(numero),
                    child: Text(
                      '$numero',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
