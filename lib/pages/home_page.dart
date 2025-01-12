import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hangman/common/my_keyboard.dart';
import 'package:hangman/utils/utils.dart';
import 'package:http/http.dart' as http;

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  AudioPlayer player = AudioPlayer();
  String word = '';
  List guessedLetters = [];
  List disabledKeys = [];
  List<String> wordsBuffer = [];
  int points = 0;
  int lifes = 6;
  bool soundOn = true;

  @override
  void initState() {
    super.initState();
    fetchInitialWords();
  }

  void playSound(String sound) async {
    if (soundOn) {
      await player.play(AssetSource('sounds/$sound'));
    }
  }

  void playAgain() {
    setState(() {
      word = wordsBuffer[1].toUpperCase();
      guessedLetters = [];
      points = 0;
      lifes = 6;
      disabledKeys = [];
    });

    fetchWords(1).then((newWords) {
      setState(() {
        wordsBuffer[0] = wordsBuffer[1];
        wordsBuffer[1] = newWords.first;
      });
    });

    playSound('restart.mp3');
  }

  Future<void> fetchInitialWords() async {
    final List<String> initialWords = await fetchWords(2);
    setState(() {
      wordsBuffer = initialWords;
      word = wordsBuffer.first.toUpperCase();
    });
  }

  Future<List<String>> fetchWords(int count) async {
    final response = await http.get(
      Uri.parse('https://random-word-api.herokuapp.com/word?number=$count'),
    );
    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load random words');
    }
  }

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
                playSound('restart.mp3');
                playAgain();
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
    if (disabledKeys.contains(letter)) {
      return;
    }

    setState(() {
      disabledKeys.add(letter);
    });

    if (word.contains(letter)) {
      setState(() {
        guessedLetters.add(letter);
        points += 5;
      });
      playSound('correct.mp3');
    } else if (lifes > 1) {
      setState(() {
        lifes--;
        points -= 5;
      });
      playSound('wrong.mp3');
    } else {
      setState(() {
        lifes--;
        points -= 5;
      });
      openDialog('GAME OVER!');
      playSound('lost.mp3');
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
        points += 10;
      });
      playSound('won.mp3');
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
            onPressed: () {
              setState(() {
                soundOn = !soundOn;
              });
            },
            icon: Icon(
              size: 40,
              soundOn ? Icons.volume_up_sharp : Icons.volume_off_sharp,
              color: Colors.purpleAccent,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black45,
      body: word.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.purpleAccent,
              ),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration:
                          const BoxDecoration(color: Colors.lightBlueAccent),
                      child: Text(
                        '${points.toString()} points',
                        style: retroStyle(15, Colors.black, FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Image(
                      image: AssetImage(
                        'assets/images/hangman$lifes.png',
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
                    Center(
                      child: Text(
                        handleText(),
                        style: retroStyle(35, Colors.white, FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 60),
                    CustomKeyboard.MyKeyboard(
                      onKeyPress: (key) {
                        checkLetter(key);
                      },
                      disabledKeys: disabledKeys,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
