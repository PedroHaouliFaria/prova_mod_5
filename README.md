# Jokenpo - Contrato Inteligente

Este projeto implementa um jogo de Jokenpo (Pedra, Papel e Tesoura) como um contrato inteligente na blockchain Ethereum, projetado para uso local onde o dono do contrato controla ambos os jogadores.

## Regras de Negócio

### 1. Criação de Jogadores
- O dono do contrato pode criar dois jogadores, atribuindo nomes a cada um.
- Os jogadores são identificados como jogador 1 e jogador 2.

### 2. Jogadas
- O dono do contrato faz as jogadas em nome de ambos os jogadores.
- As opções de jogada são:
  - 0 = Pedra
  - 1 = Papel
  - 2 = Tesoura

### 3. Resultado
- O resultado é determinado após ambos os jogadores terem feito suas jogadas.
- As regras de vitória são:
  - Pedra vence Tesoura
  - Tesoura vence Papel
  - Papel vence Pedra
  - Empate quando ambos escolhem a mesma opção
- Após o resultado, uma nova rodada pode ser iniciada.

### 4. Histórico
- Todas as rodadas são registradas no histórico do contrato.
- O histórico inclui as escolhas de ambos os jogadores, o vencedor e o timestamp.
- O histórico pode ser consultado pelo dono do contrato.

## Estrutura do Contrato

### Estruturas de Dados
- `Jogador`: Armazena informações de um jogador (nome)
- `Rodada`: Armazena informações de uma rodada (escolhas, vencedor, timestamp)

### Variáveis de Estado
- `dono`: Endereço do dono do contrato
- `jogador1` e `jogador2`: Informações dos jogadores
- `historicoRodadas`: Mapeamento de índices para informações de rodadas
- `totalRodadas`: Contador de rodadas jogadas
- `escolhaJogador1` e `escolhaJogador2`: Escolhas dos jogadores na rodada atual

### Funções Principais
- `criarJogador`: Cria um jogador com nome e número
- `jogar`: Permite que o dono faça uma jogada em nome de um jogador
- `verResultado`: Verifica o resultado da partida atual
- `consultarHistorico`: Consulta o histórico de rodadas
- `getTotalRodadas`: Retorna o total de rodadas jogadas
- `reiniciarRodada`: Reinicia as escolhas para uma nova rodada

### Modificador
- `apenasDono`: Restringe a função apenas ao dono do contrato

### Eventos
- `JogadorCriado`: Emitido quando um jogador é criado
- `JogadaRealizada`: Emitido quando um jogador faz uma jogada
- `PartidaFinalizada`: Emitido quando uma partida é finalizada

## Como Usar o Contrato

1. **Criar Jogadores**:
   - O dono do contrato deve chamar a função `criarJogador` para criar o jogador 1 e o jogador 2.

2. **Fazer Jogadas**:
   - O dono do contrato deve chamar a função `jogar` para fazer a jogada do jogador 1.
   - O dono do contrato deve chamar a função `jogar` novamente para fazer a jogada do jogador 2.

3. **Ver Resultado**:
   - Após ambos os jogadores terem feito suas jogadas, o dono do contrato deve chamar a função `verResultado`.

4. **Consultar Histórico**:
   - O dono do contrato pode chamar a função `consultarHistorico` para ver o histórico de rodadas.

5. **Reiniciar Rodada**:
   - O dono do contrato pode chamar a função `reiniciarRodada` para reiniciar as escolhas e começar uma nova rodada.
