# Subitize (Front-End) 🧠⚡

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Arquitetura: MVVM + SOLID](https://img.shields.io/badge/Arquitetura-MVVM%20%2B%20SOLID-orange?style=for-the-badge)](https://pt.wikipedia.org/wiki/Model-view-viewmodel)
[![Licença: GPL v3](https://img.shields.io/badge/Licen%C3%A7a-GPL%20v3-blue.svg?style=for-the-badge)](LICENSE)

Um jogo de treinamento cognitivo open-source construído em **Flutter** e **Dart**, fundamentado no conceito neurocientífico de **subitização** (*subitizing* — percepção numérica instantânea). O projeto foi desenvolvido com foco em excelência de engenharia de software: arquitetura **MVVM**, aplicação rigorosa dos princípios **SOLID** e **zero dependências externas de runtime**.

---

## 📖 Sumário

- [Visão Geral](#-visão-geral)
- [O que é Subitização?](#-o-que-é-subitização)
- [Modos de Jogo e Funcionalidades](#-modos-de-jogo-e-funcionalidades)
- [Sistema de Pontuação Cognitiva](#-sistema-de-pontuação-cognitiva)
- [Arquitetura e Princípios de Design](#-arquitetura-e-princípios-de-design)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Como Executar o Projeto](#-como-executar-o-projeto)
- [Testes Automatizados](#-testes-automatizados)
- [Roadmap de Evolução](#-roadmap-de-evolução)
- [Público-Alvo e Propósito](#-público-alvo-e-propósito)
- [Autor e Licença](#-autor-e-licença)

---

## 🎯 Visão Geral

O **Subitize** desafia e exercita a percepção visual rápida, a atenção e a intuição numérica do cérebro humano. Em frações de segundo (entre **200ms** e **500ms**), um conjunto de bolinhas distribuídas aleatoriamente (sem sobreposição) surge na tela e desaparece logo em seguida. O jogador precisa identificar instantaneamente a quantidade exibida e registrar seu palpite em um teclado numérico virtual.

O projeto foi projetado para demonstrar:
1. **Interface reativa de alto desempenho** para estímulos visuais na escala de milissegundos usando recursos nativos do Flutter (`Ticker`, `ValueNotifier`, `CustomPainter`).
2. **Arquitetura modular e desacoplada** seguindo as boas práticas de **MVVM** e **SOLID**.
3. **Algoritmo de pontuação cognitiva** modelado matematicamente com base no tempo de reação, tempo de exposição, complexidade da quantidade e multiplicador de acertos consecutivos (*streak*).

---

## 🧠 O que é Subitização?

**Subitização** (do latim *subitus*, que significa "repentino") é a capacidade do cérebro de determinar a quantidade exata de itens em um grupo de relance, sem a necessidade de contá-los um a um:

* **Subitização Perceptual ($N \le 4$ itens):** Processo pré-atencional automático, rápido e com altíssima taxa de acerto, realizado em menos de $\sim 300\text{ ms}$.
* **Agrupamento de Padrões e Contagem ($N \ge 5$ itens):** Exige organização visual em pequenos subgrupos (*chunking*) ou varredura serial rápida, demandando maior carga da memória de trabalho e atenção visual.

O jogo explora esses dois limites cognitivos, variando quantidades de 1 a 11 e diminuindo a duração da exposição conforme o progresso do jogador.

---

## 🎮 Modos de Jogo e Funcionalidades

### 1. Modo Clássico
Modo principal com duas modalidades distintas:

- **Modo Treino:**
  - Focado em calibração, aprendizado e aquecimento cognitivo.
  - Curva progressiva de dificuldade: inicia com pequenos números ($N \le 4$ por 500ms) e avança gradualmente.
  - **Ponto de fixação (`+`)**: exibido antes da aparição dos elementos para ancorar a visão central.
  - **Algoritmo anti-repetição**: evita que o mesmo número seja sorteado em rodadas consecutivas.
  - **Pontuação por proximidade**: concede pontuação parcial para palpites próximos ($\pm 1$), incentivando a estimativa rápida.

- **Modo Arcade:**
  - Ritmo acelerado e competitivo.
  - Redução agressiva do tempo de exposição conforme o número da rodada:
    - Rodadas 1 a 5: `350 ms`
    - Rodadas 6 a 10: `300 ms`
    - Rodadas 11 a 15: `250 ms`
    - Rodadas 16 em diante: `200 ms`
  - Sistema de vidas (3 vidas iniciais): erros descontam vidas e interrompem o multiplicador.
  - Multiplicador de sequência (*streak*) para recompensar acertos consecutivos rápidos.

### 2. Renderização em Canvas sem Sobreposição
- **Gerador de Posições Normalizadas (`GeradorBolinhasSemSobreposicao`)**: utiliza cálculo de distância euclidiana para garantir que nenhuma bolinha encavale ou ultrapasse as margens de segurança da tela.
- **Renderização via `CustomPainter` (`BolinhasPainter`)**: pintura direta na camada gráfica, garantindo taxa estável de 60+ FPS em dispositivos móveis e navegadores web.

---

## 🧮 Sistema de Pontuação Cognitiva

A pontuação é calculada de forma pura pelo serviço de domínio `CalculadoraPontuacaoCognitiva`:

$$\text{Pontos Finais} = \lfloor \text{Base}(N) \times \text{Fator}_{\text{exposição}} \times \text{Bônus}_{\text{rapidez}} \times \text{Multiplicador}_{\text{streak}} \rfloor$$

1. **Complexidade Numérica ($\text{Base}(N)$):**
   - $N \le 4$ (Faixa de Subitização): $N \times 100$
   - $N \ge 5$ (Faixa de Agrupamento): $N^2 \times 25$
2. **Fator de Exposição ($\text{Fator}_{\text{exposição}}$):**
   - Relação inversamente proporcional em relação à base de referência (500ms):
   $$\text{Fator}_{\text{exposição}} = \frac{500\text{ ms}}{T_{\text{exposição}}\text{ (ms)}}$$
3. **Bônus de Rapidez ($\text{Bônus}_{\text{rapidez}}$):**
   - Decaimento suave entre **1.5x** ($\le 800\text{ ms}$) e **1.0x** ($\ge 3000\text{ ms}$).
4. **Multiplicador de Sequência ($\text{Multiplicador}_{\text{streak}}$):**
   - 1 acerto: `1.0x` | 2 acertos: `1.2x` | 3 acertos: `1.5x` | a partir do 4º acerto: soma `+0.3x` até o teto de **3.0x**.

---

## 🏗️ Arquitetura e Princípios de Design

A aplicação adota o padrão **MVVM** aliado aos princípios **SOLID**, sem dependência de bibliotecas de terceiros para gerência de estado:

```
┌────────────────────────────────────────────────────────┐
│                   Camada de Visão (UI)                 │
│   MenuPrincipalPage | JogoBolinhasPage | Widgets       │
└──────────────────────────▲─────────────────────────────┘
                           │ (Observa via ValueListenable e ChangeNotifier)
┌──────────────────────────▼─────────────────────────────┐
│                 Camada de ViewModel                    │
│              JogoBolinhasViewModel                     │
└──────────▲─────────────────────────────────▲───────────┘
           │ (Coordena)                      │ (Consome)
┌──────────▼─────────────────────────────┐  ┌▼───────────────────────────┐
│          Serviços de Domínio           │  │      Modelos de Domínio    │
│   IGeradorBolinhas                     │  │   Bolinha                  │
│   ISorteadorQuantidade                 │  │   ConfiguracaoJogo         │
│   ICalculadoraPontuacao                │  │   EstadoJogo               │
│   IGerenciadorDificuldade              │  │   ModoJogo                 │
└────────────────────────────────────────┘  │   ParametrosRodada         │
                                            │   ResultadoRodada          │
                                            └────────────────────────────┘
```

### Destaques do SOLID no Projeto
- **Responsabilidade Única (SRP):** Cada serviço executa exclusivamente sua tarefa: geração de coordenadas, sorteio numérico, cálculo de pontuação e escalonamento de dificuldade.
- **Aberto/Fechado (OCP) e Inversão de Dependência (DIP):** O `JogoBolinhasViewModel` depende apenas de interfaces abstratas (`IGeradorBolinhas`, `ISorteadorQuantidade`, `ICalculadoraPontuacao`, `IGerenciadorDificuldade`). É possível plugar novos algoritmos de geração ou pontuação sem alterar o ViewModel.
- **Segregação de Interfaces (ISP):** Contratos enxutos e focados, simplificando o desacoplamento e a criação de mocks para testes unitários.
- **Gerenciamento de Estado Nativo e Leve:** Emprega `ChangeNotifier`, `ValueNotifier` e `TickerProvider`, provando que o framework Flutter nativo é plenamente capaz de fornecer soluções elegantes e de alta performance sem sobrecarga (*boilerplate*).

---

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                                # Ponto de entrada e injeção de dependências
├── models/                                  # Entidades e objetos de valor
│   ├── bolinha.dart                         # Coordenadas e raio de cada bolinha
│   ├── configuracao_jogo.dart               # Timings, margens e regras do jogo
│   ├── estado_jogo.dart                     # Máquina de estados (menu, contagem, exibição, resposta, feedback, fim)
│   ├── modalidade_jogo.dart                 # Enum das modalidades planejadas
│   ├── modo_jogo.dart                       # Modos de jogo (treino, arcade)
│   ├── parametros_rodada.dart               # Parâmetros calculados por rodada
│   └── resultado_rodada.dart                # Detalhamento de pontuação e resposta
├── services/                                # Regras de negócio e interfaces
│   ├── calculadora_pontuacao.dart           # Motor de pontuação cognitiva
│   ├── gerador_bolinhas.dart                # Gerador de coordenadas sem colisão
│   ├── gerenciador_dificuldade.dart         # Gerenciamento de curvas de dificuldade
│   └── sorteador_quantidade.dart            # Sorteio com algoritmo anti-repetição
├── viewmodels/                              # Coordenação de estado e apresentação
│   └── jogo_bolinhas_viewmodel.dart         # ViewModel reativo principal
└── views/                                   # Camada de apresentação e componentes de UI
    ├── menu_principal_page.dart             # Hub central de seleção de modalidades
    ├── jogo_bolinhas_page.dart              # Orquestrador do loop do jogo e animação
    └── widgets/                             # Componentes modulares e reutilizáveis
        ├── bolinhas_painter.dart            # Pintura personalizada no Canvas em alto desempenho
        ├── feedback_rodada_widget.dart      # Banner de retorno imediato da rodada
        ├── menu_inicial_widget.dart         # Seleção entre Treino e Arcade
        ├── placar_hud_widget.dart           # Exibição de pontuação, streak e multiplicador
        ├── resultado_rodada_widget.dart     # Painel detalhado de pontuação pós-rodada
        ├── teclado_resposta_widget.dart     # Teclado numérico responsivo
        └── vidas_hud_widget.dart            # Indicador de vidas restantes
```

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
- **Flutter SDK**: `^3.0.0` ou superior
- **Dart SDK**: `^3.0.0` ou superior
- Plataforma de destino compatível: **Web**, **Android**, **iOS**, **Linux**, **macOS** ou **Windows**.

### Instalação e Execução

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/neydsonsmacedo/subitize-front-end.git
   cd subitize-front-end
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Inicie o aplicativo:**
   - No Chrome / Web (com moldura responsiva simulando tela móvel):
     ```bash
     flutter run -d chrome
     ```
   - Em um emulador ou aparelho físico (Android/iOS):
     ```bash
     flutter run
     ```

---

## 🧪 Testes Automatizados

A suíte de testes unitários e de widget valida as regras de negócio, a progressão das rodadas e o cálculo da pontuação cognitiva:

```bash
flutter test
```

Cenários cobertos pelos testes:
- Base linear ($N \le 4$) versus quadrática ($N \ge 5$) no cálculo de pontos.
- Decaimento do bônus de velocidade e teto do multiplicador de sequência em 3.0x.
- Fator de dificuldade inversamente proporcional ao tempo de exposição.
- Tolerância de acerto aproximado no modo Treino.
- Prevenção de colisão e limites de margem no gerador de posições.

---

## 🗺️ Roadmap de Evolução

A estrutura modular foi projetada para receber novas modalidades cognitivas:

- [x] **Modo Clássico**: Subitização com bolinhas nos modos Treino e Arcade.
- [ ] **Quantidade por Figura**: Subitização filtrando apenas uma forma geométrica alvo em meio a formas mistas.
- [ ] **Quantidade por Cor**: Subitização filtrando apenas uma cor específica em meio a cores conflitantes.
- [ ] **Sequência de Aparição**: Memorização e identificação da ordem cronológica de aparição das bolinhas.
- [ ] **Comparação 2-Back**: Teste de memória de trabalho no estilo n-back (comparar a quantidade atual com a de 2 rodadas anteriores).
- [ ] **Sincronização com Backend**: Registro de histórico, rankings globais e métricas de evolução cognitiva.

---

## 👥 Público-Alvo e Propósito

Este repositório atende a diferentes públicos:
- **Para Desenvolvedores, Líderes Técnicos e Recrutadores:** Demonstração prática de código limpo, design patterns em Flutter, arquitetura desacoplada e testes unitários sem sobrecarga de bibliotecas externas.
- **Para Educadores, Psicopedagogos e Pesquisadores Cognitivos:** Ferramenta empírica para treino e mensuração de tempo de reação, percepção numérica inicial e atenção visual.

---

## 👨‍💻 Autor

**Neydson Macedo**
- GitHub: [@neydsonsmacedo](https://github.com/neydsonsmacedo)

Distribuído sob a licença [GNU General Public License v3.0 (GPLv3)](LICENSE). Copyright (C) 2024 Neydson Macedo.
