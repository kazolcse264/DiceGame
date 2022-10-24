import 'dart:math';

import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  final imageList = [
    'images/dice1.png',
    'images/dice2.png',
    'images/dice3.png',
    'images/dice4.png',
    'images/dice5.png',
    'images/dice6.png',
  ];
  int _index1 = 0, _index2 = 0, _sum = 0, _point = 0;
  get index2 => _index2;

  get sum => _sum;

  get point => _point;

  int get index1 => _index1;

  final Random random = Random.secure();

  bool hasGameStarted = false;
  bool isGameRunning = false;
  String status = ' ';

  void start(){
    hasGameStarted = true;
    isGameRunning = true;
    notifyListeners();
  }
  void rollDice() {

      _index1 = random.nextInt(6);
      _index2 = random.nextInt(6);
      _sum = _index1 + _index2 + 2;
      checkResult();
      notifyListeners();

  }

  void checkResult() {
    if (_point == 0) {
      if (_sum == 7 || _sum == 11) {
        status = ' Win';
        isGameRunning = false;
      } else if (_sum == 2 || _sum == 3 || _sum == 12) {
        status = ' Lost';
        isGameRunning = false;
      } else {
        _point = _sum;
      }
    } else {
      if (_sum == point) {
        status = ' Win';
        isGameRunning = false;
      } else if (_sum == 7) {
        status = ' Lost';
        isGameRunning = false;
      }
    }
  }

  void reset() {

      _point = 0;
      status = '';
      _sum = 0;
      hasGameStarted = false;
      _index1 = 0;
      _index2 = 0;
      notifyListeners();

  }
}





