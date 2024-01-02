import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyGame(),
    );
  }
}

class MyGame extends StatefulWidget {
  @override
  _MyGameState createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  double jackpot = 0.0;
  double userBet = 0.0;
  int elapsedTime = 0;
  bool isGameRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Jackpot: ${jackpot.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Cor do texto do jackpot
              ),
            ),
            Text('Aposta: ${userBet.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isGameRunning ? null : _startGame,
              child: Text('Iniciar Jogo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isGameRunning ? _stopGame : null,
              child: Text('Parar Jogo'),
            ),
          ],
        ),
      ),
    );
  }

  void _startGame() {
    setState(() {
      jackpot = 0.0;
      userBet = 0.0;
      elapsedTime = 0;
      isGameRunning = true;
    });

    // Inicia o cronômetro
    Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      if(isGameRunning) {
        setState(() {
          elapsedTime += 100;
          jackpot +=
          0.01; // Aumenta o jackpot a cada 100 milissegundos (exemplo)
        });
      }else {
        setState(() {
          jackpot = 0;
        });
      }
      // Se o tempo atingir 10 segundos (10.000 milissegundos), o jogo termina
      if (jackpot == 10000) {
        _endGame();
        timer.cancel();
      }
    });
  }

  void _stopGame() {
    setState(() {
      isGameRunning = false;
    });

    // Calcula o resultado
    double difference = (elapsedTime - 10000).abs().toDouble();
    double winnings = difference == 0 ? jackpot : 0.0;

    // Atualiza o estado com base no resultado
    setState(() {
      jackpot -= userBet;
      jackpot += winnings;
    });

    _showResultDialog(winnings);
  }

  void _endGame() {
    setState(() {
      isGameRunning = false;
    });

    // Calcula o resultado
    double difference = (elapsedTime - 10000).abs().toDouble();
    double winnings = difference == 0 ? jackpot : 0.0;

    // Atualiza o estado com base no resultado
    setState(() {
      jackpot -= userBet;
      jackpot += winnings;
    });

    _showResultDialog(winnings);
  }

  void _showResultDialog(double winnings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resultado do Jogo'),
          content: Text('Você ganhou $winnings pontos!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
