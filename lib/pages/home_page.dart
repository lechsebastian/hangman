import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hangman/common/my_keyboard.dart';
import 'package:hangman/utils/utils.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String word = wordslist[Random().nextInt(wordslist.length)].toUpperCase();
  List guessedLetters = [];
  int points = 0;
  int lifes = 7;

  openDialog(String text) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.purpleAccent, width: 3),
          ),
          backgroundColor: Colors.lightBlueAccent,
          title: Text(
            text,
            style: retroStyle(25, Colors.black, FontWeight.w700),
          ),
          content: Text(
            'Points: $points',
            style: retroStyle(20, Colors.black, FontWeight.w700),
          ),
          actions: [
            TextButton(
              child: Text(
                'Play Again',
                style: retroStyle(14, Colors.purpleAccent, FontWeight.w700),
              ),
              onPressed: () {
                setState(() {
                  word = wordslist[Random().nextInt(wordslist.length)]
                      .toUpperCase();
                  guessedLetters = [];
                  points = 0;
                  lifes = 7;
                });
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  String handleText() {
    String displayWord = '';
    print(word);

    for (int i = 0; i < word.length; i++) {
      if (guessedLetters.contains(word[i])) {
        setState(() {
          displayWord += '${word[i]} ';
        });
      } else {
        setState(() {
          displayWord += '? ';
        });
      }
    }
    return displayWord;
  }

  checkLetter(String letter) {
    if (word.contains(letter)) {
      setState(() {
        guessedLetters.add(letter);
        points += 10;
      });
    } else if (lifes > 1) {
      setState(() {
        lifes--;
        points -= 5;
      });
    } else {
      setState(() {
        points -= 5;
      });
      openDialog('GAME OVER!');
    }

    bool isWon = true;
    for (int i = 0; i < word.length; i++) {
      if (!guessedLetters.contains(word[i])) {
        setState(() {
          isWon = false;
        });
        break;
      }
    }
    if (isWon) {
      openDialog('YOU WON!');
      setState(() {
        points += 30;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hangman',
          style: retroStyle(30, Colors.white, FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.black45,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              size: 40,
              Icons.volume_up_sharp,
              color: Colors.purpleAccent,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black45,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: const BoxDecoration(color: Colors.lightBlueAccent),
                child: Text(
                  '${points.toString()} points',
                  style: retroStyle(15, Colors.black, FontWeight.w700),
                ),
              ),
              const SizedBox(height: 30),
              Image(
                image: AssetImage(
                  'images/hangman${lifes - 1}.png',
                ),
                width: 155,
                height: 155,
                color: Colors.white,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 15),
              Text(
                lifes > 1 ? '$lifes lifes left' : '$lifes life left',
                style: retroStyle(17, Colors.grey, FontWeight.w700),
              ),
              const SizedBox(height: 30),
              Text(
                handleText(),
                style: retroStyle(35, Colors.white, FontWeight.w700),
              ),
              const SizedBox(height: 60),
              CustomKeyboard.MyKeyboard(onKeyPress: (key) {
                checkLetter(key);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
