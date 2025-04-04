// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Jokenpo {
    // Constantes para as opções de jogada
    uint8 private constant PEDRA = 0;
    uint8 private constant PAPEL = 1;
    uint8 private constant TESOURA = 2;

    // Estrutura para armazenar um jogador
    struct Jogador {
        string nome;
    }

    // Estrutura para armazenar informações de uma rodada
    struct Rodada {
        uint8 escolhaJogador1;
        uint8 escolhaJogador2;
        uint8 vencedor; // 0 = empate, 1 = jogador1, 2 = jogador2
        uint256 timestamp;
    }

    // Variáveis de estado
    address public dono;
    Jogador public jogador1;
    Jogador public jogador2;
    mapping(uint256 => Rodada) public historicoRodadas;
    uint256 public totalRodadas;
    uint8 public escolhaJogador1;
    uint8 public escolhaJogador2;

    // Eventos
    event JogadorCriado(string nome, uint8 numero);
    event JogadaRealizada(uint8 jogador, uint8 escolha);
    event PartidaFinalizada(uint8 vencedor, string resultado);

    // Modificador
    modifier apenasDono() {
        require(msg.sender == dono, "Apenas o dono pode executar esta funcao");
        _;
    }

    // Construtor
    constructor() {
        dono = msg.sender;
    }

    function criarJogador(string memory _nome, uint8 _numero) external apenasDono {
        require(_numero == 1 || _numero == 2, "Numero de jogador invalido");
        require(bytes(_nome).length > 0, "Nome invalido");
        
        if (_numero == 1) {
            jogador1 = Jogador({nome: _nome});
        } else {
            jogador2 = Jogador({nome: _nome});
        }
        
        emit JogadorCriado(_nome, _numero);
    }

    function jogar(uint8 _jogador, uint8 escolha) external apenasDono returns (string memory) {
        require(_jogador == 1 || _jogador == 2, "Jogador invalido");
        require(escolha <= TESOURA, "Escolha invalida");
        
        if (_jogador == 1) {
            escolhaJogador1 = escolha;
        } else {
            escolhaJogador2 = escolha;
        }
        
        string memory escolhaTexto;
        if (escolha == PEDRA) {
            escolhaTexto = "Pedra";
        } else if (escolha == PAPEL) {
            escolhaTexto = "Papel";
        } else {
            escolhaTexto = "Tesoura";
        }
        
        emit JogadaRealizada(_jogador, escolha);
        return string(abi.encodePacked("Jogador ", _jogador == 1 ? "1" : "2", " escolheu ", escolhaTexto));
    }

    function verResultado() external apenasDono returns (string memory resultado) {
        require(escolhaJogador1 != 0 || escolhaJogador2 != 0, "Nenhuma jogada realizada");
        
        uint8 vencedor;
        
        if (escolhaJogador1 == escolhaJogador2) {
            resultado = "Empate!";
            vencedor = 0;
        } else if (
            (escolhaJogador1 == PEDRA && escolhaJogador2 == TESOURA) ||
            (escolhaJogador1 == TESOURA && escolhaJogador2 == PAPEL) ||
            (escolhaJogador1 == PAPEL && escolhaJogador2 == PEDRA)
        ) {
            resultado = "Jogador 1 venceu!";
            vencedor = 1;
        } else {
            resultado = "Jogador 2 venceu!";
            vencedor = 2;
        }
        
        // Registra a rodada no histórico
        historicoRodadas[totalRodadas] = Rodada({
            escolhaJogador1: escolhaJogador1,
            escolhaJogador2: escolhaJogador2,
            vencedor: vencedor,
            timestamp: block.timestamp
        });
        
        totalRodadas++;
        
        // Reinicia as escolhas para nova rodada
        escolhaJogador1 = 0;
        escolhaJogador2 = 0;
        
        emit PartidaFinalizada(vencedor, resultado);
        return resultado;
    }

    function consultarHistorico(uint256 _rodada) external view returns (
        uint8 escolha1,
        uint8 escolha2,
        uint8 vencedor,
        uint256 timestamp
    ) {
        require(_rodada < totalRodadas, "Rodada nao existe");
        
        Rodada memory rodada = historicoRodadas[_rodada];
        return (rodada.escolhaJogador1, rodada.escolhaJogador2, rodada.vencedor, rodada.timestamp);
    }

    function getTotalRodadas() external view returns (uint256) {
        return totalRodadas;
    }


    function reiniciarRodada() external apenasDono {
        escolhaJogador1 = 0;
        escolhaJogador2 = 0;
    }
} 