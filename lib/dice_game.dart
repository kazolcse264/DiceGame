import 'dart:math';

import 'package:dice_game/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension on double {
  double get toRad => this * 0.0174533;
}
/*
You roll two dice. Each die has six faces, which contain
one, two, three, four, five and six spots, respectively.
After the dice have come to rest, the sum of the spots on
the two upward faces is calculated.


***If the sum is 7 or 11 on the first throw, you win.
***If the sum is 2, 3 or 12 on the first throw
(called “craps”), you lose (i.e., the “house” wins).
***If the sum is 4, 5, 6, 8, 9 or 10 on the first throw,
that sum becomes your “point.”
***To win,you must continue rolling the dice until you
“make your point”
(i.e., roll that same point value).
***You lose by rolling a 7 before making your point.
*/

class DiceGame extends StatefulWidget {
  const DiceGame({Key? key}) : super(key: key);

  @override
  State<DiceGame> createState() => _DiceGameState();
}

class _DiceGameState extends State<DiceGame> with TickerProviderStateMixin {

  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dice Game'),
      ),
      body: Consumer<GameProvider>(
        builder: (context, provider, _) =>
            AnimatedCrossFade(
              duration: const Duration(
                milliseconds: 500,
              ),
              firstChild: startBody(provider),
              secondChild: gameBody(provider),
              crossFadeState:
              provider.hasGameStarted
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
      ),
    );
  }


  Center startBody(GameProvider provider) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /*Stack(
            children: [
              Transform(
                transform: Matrix4.rotationZ(45.0.toRad),
                alignment: Alignment.bottomLeft,
                child: Image.asset(
                  imageList[4],
                  width: 100,
                  height: 100,
                ),
              ),
              Transform(
                transform: Matrix4.rotationZ(-45.0.toRad),
                alignment: Alignment.bottomRight,

                child: Image.asset(
                  imageList[1],
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),*/
          Center(
            child: RotationTransition(
              turns: animation,
              child: SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('images/dice3D.png'),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              provider.start;
            },
            child: const Text(
              'START',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Column gameBody(GameProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          'Game Rule',
          style: TextStyle(fontSize: 30),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 18.0, right: 18.0),
          child: Text(
            'You roll two dice. Each die has six faces, which contain one, two, three, four, five and six spots, respectively. After the dice have come to rest, the sum of the spots on the two upward faces is calculated.\n***If the sum is 7 or 11 on the first throw, you win. \n***If the sum is 2, 3 or 12 on the first throw (called “craps”), you lose (i.e., the “house” wins). \n***If the sum is 4, 5, 6, 8, 9 or 10 on the first throw,that sum becomes your “point.” \n***To win,you must continue rolling the dice until you“make your point”(i.e., roll that same point value).\n ***You lose by rolling a 7 before making your point.',
            style: TextStyle(
                fontSize: 12,
                color: Colors.black45
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                provider.imageList[provider.index1],
                //fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
              const SizedBox(
                width: 10,
              ),
              Image.asset(
                provider.imageList[provider.index2],
                //fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ],
          ),
        ),
        if (provider.isGameRunning)
          ElevatedButton(
            onPressed: provider.rollDice,
            child: const Text(
              'Roll',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
        if (!provider.isGameRunning)
          ElevatedButton(
            onPressed: provider.reset,
            child: const Text(
              'Reset',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
        if (provider.hasGameStarted)
          RichText(
            text: TextSpan(
                text: 'Sum =  ',
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: '${provider.sum}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  )
                ]),
          ),
        if (provider.point > 0)
          RichText(
            text: TextSpan(
                text: 'Your point is : ',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: '${provider.point}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  )
                ]),
          ),
        if (provider.point > 0)
          RichText(
            text: TextSpan(
                text: 'Keep rolling until you match your point :  ',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: '${provider.point}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  )
                ]),
          ),
        if (!provider.isGameRunning)
          Text(
            'You ${provider.status}',
            style: const TextStyle(
                fontSize: 30,
                color: Colors.blue
            ),
          ),
      ],
    );
  }
}
