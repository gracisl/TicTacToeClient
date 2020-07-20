import 'package:TicTacToeClient/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToe());
}

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tic-Tac-Toe App",
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
