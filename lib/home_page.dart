//import 'dart:async';

import 'package:TicTacToeClient/custom_dialog.dart';
import 'package:TicTacToeClient/game_button.dart';
import 'package:flutter/material.dart';
//import 'package:TicTacToeClient/socket_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
/*   final StreamController _streamController = StreamController();

  addData() async {
    //изменения информации о порядке хода игроков
    await Future.delayed(Duration(seconds: 1));
    _streamController.sink.add(sk.message);
  } */

  //SocketProvider sk = SocketProvider();
  List<GameButton> buttonList;
  //Future<String> userFuture;
  var player1;
  var player2;
  var activePlayer;
  var winner;
  String message;
  bool myTurn;
/* 
  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  } */

  @override
  void initState() {
    super.initState();
    print("Начат InitState");
    /* sk.connect();
    sk.gameBegin();
    addData(); //addData(); */
    buttonList = doInit();
    print("Закончен InitState");
  }

  List<GameButton> doInit() {
    player1 = List();
    player2 = List();
    activePlayer = 1;
    message = "First Player's turn";

    var gameButtons = <GameButton>[
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9)
    ];
    return gameButtons;
  }

  void playGame(
    GameButton gb,
  ) {
    //String symbol
    setState(() {
      /* gb.text = symbol;
      gb.bg = Colors.red;
      sk.makeMove(gb);
      print("Обновление текста Игрока");
      addData();
      print("Обновление текста Игрока завершено"); */
      // Отображение шага противника: сингл плеер
      if (activePlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.redAccent;
        activePlayer = 2;
        message = "Second Player's turn";
        player1.add(gb.id);
      } else {
        gb.text = "O";
        gb.bg = Colors.blue;
        activePlayer = 1;
        message = "First Player's turn";
        player2.add(gb.id);
      }
      gb.enabled = false;
      checkWinner();
    });
  }

  void checkWinner() {
    winner = -1;
    if (player1.contains(1) &&
                player1.contains(2) &&
                player1.contains(3) || //Первая строка
            player1.contains(4) &&
                player1.contains(5) &&
                player1.contains(6) || //Вторая строка
            player1.contains(7) &&
                player1.contains(8) &&
                player1.contains(9) || //Третья строка
            player1.contains(1) &&
                player1.contains(5) &&
                player1.contains(9) || // Первая диагональ
            player1.contains(3) &&
                player1.contains(5) &&
                player1.contains(7) || // Вторая диагональ
            player1.contains(1) &&
                player1.contains(4) &&
                player1.contains(7) || // Первая колонка
            player1.contains(2) &&
                player1.contains(5) &&
                player1.contains(8) || // Вторая колонка
            player1.contains(3) &&
                player1.contains(6) &&
                player1.contains(9) // Третья колонка
        ) {
      winner = 1;
    }
    if (player2.contains(1) &&
                player2.contains(2) &&
                player2.contains(3) || //Первая строка
            player2.contains(4) &&
                player2.contains(5) &&
                player2.contains(6) || //Вторая строка
            player2.contains(7) &&
                player2.contains(8) &&
                player2.contains(9) || //Третья строка
            player2.contains(1) &&
                player2.contains(5) &&
                player2.contains(9) || // Первая диагональ
            player2.contains(3) &&
                player2.contains(5) &&
                player2.contains(7) || // Вторая диагональ
            player2.contains(1) &&
                player2.contains(4) &&
                player2.contains(7) || // Первая колонка
            player2.contains(2) &&
                player2.contains(5) &&
                player2.contains(8) || // Вторая колонка
            player2.contains(3) &&
                player2.contains(6) &&
                player2.contains(9) // Третья колонка
        ) {
      winner = 2;
    }
    if (winner != -1) {
      if (winner == 1) {
        showDialog(
            context: context,
            builder: (_) => CustomDialog("Player 1 Won",
                "Press the reset button to start again.", resetGame));
      } else {
        showDialog(
            context: context,
            builder: (_) => CustomDialog("Player 2 Won",
                "Press the reset button to start again.", resetGame));
      }
    }
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonList = doInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Start build");
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Tic Tac Toe")),
        ),
        body: Center(
            child:
                /* StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("ERROR!");
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return */
                Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        Text(
                          message, // snapshot.data
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ), //Информация о ходе игроков
                        Container(
                          width: 500,
                          height: 500,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1.0,
                                    crossAxisSpacing: 9.0,
                                    mainAxisSpacing: 9.0),
                            itemCount: buttonList.length,
                            itemBuilder: (context, i) => SizedBox(
                              width: 100.0,
                              height: 100.0,
                              child: RaisedButton(
                                  padding: const EdgeInsets.all(8.0),
                                  onPressed: buttonList[i].enabled
                                      ? () => playGame(
                                          buttonList[i] /* , sk.symbol */)
                                      : null,
                                  child: Text(
                                    buttonList[i].text,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  ),
                                  color: buttonList[i].bg,
                                  disabledColor: buttonList[i].bg),
                            ),
                          ),
                        ),
                      ],
                    )) //;
            //}
            )
        //),
        );
  }
}
