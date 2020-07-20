import 'package:TicTacToeClient/game_button.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

class _Events {
  static const String connect = 'connect';
  static const String message = 'message';
  static const String gameBegin = 'game.begin';
  static const String makeMove = 'make.move';
  static const String moveMade = 'move.made';
}

class SocketProvider {
  final IO.Socket io;

  bool myTurn = true;
  String message = "Your turn";
  String symbol;
  int position;
  GameButton gameButton;

  SocketProvider()
      : io = IO.io('http://localhost:8080', <String, dynamic>{
          'transports': ['websocket'],
          'extraHeaders': {'foo': 'bar'}
        });

  connect() {
    print("Start Connect");
    io.on(_Events.connect, (_) {
      print('Connected');

      io.emit(_Events.message, 'Привет от клиента');
      io.on(_Events.message, (msg) {
        print('Message:$msg');
      });
    });
  }

  renderTurnMessage() {
    print("Получение сообщения");
    if (myTurn) {
      message = "Your turn";
    }
    if (!myTurn) {
      message = "Your opponent's turn";
    }
    print("Получено сообщение: $message");
    return message;
  }

  makeMove(GameButton gb) {
    if (!myTurn) {
      print("Ход противника!");
      return;
    }
    if (!gb.enabled) {
      print("Кнопка не активна!");
      return;
    }
    print("Передача инфы о ходе противнику");
    var jsonData = {};
    jsonData['symbol'] = gb.text;
    jsonData['position'] = gb.id;
    String data = json.encode(jsonData);
    io.emit(_Events.makeMove, data);
    moveMade();
    print("Передача завершена");
  }

  moveMade() {
    io.on(_Events.moveMade, (data) {
      print("Ход противника сделан:" + data);
      var dartData = json.decode(data);
      position = dartData['position'];
      symbol = dartData['symbol'];
      print("Противник нажал кнопку: $position");
      print("Знак противника: $symbol");
      print("Инфа принята");
      print("Обновление текста");
      if (symbol != dartData['symbol']) {
        myTurn = true;
      } else {
        myTurn = false;
      }
      renderTurnMessage();
      print("Обновление текста завершено");

      return [position, symbol];
    });
  }

  gameBegin() {
    print("Игра началась");
    io.on(_Events.gameBegin, (data) {
      //print(data['symbol']);
      symbol = data['symbol'];
      if (symbol != "X") {
        myTurn = false;
      }
      renderTurnMessage();
      print("Передан символ игроку: $symbol");
      return symbol;
    });
  }
}
