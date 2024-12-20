import 'package:flutter/material.dart';
import 'package:hangman/common/my_keyboard.dart';
import 'package:hangman/utils/utils.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
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
                  '12 points',
                  style: retroStyle(15, Colors.black, FontWeight.w700),
                ),
              ),
              const SizedBox(height: 20),
              const Image(
                image: AssetImage(
                  'images/hangman0.png',
                ),
                width: 155,
                height: 155,
                color: Colors.white,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 15),
              Text(
                '7 lives left',
                style: retroStyle(17, Colors.grey, FontWeight.w700),
              ),
              const SizedBox(height: 30),
              Text(
                '??????',
                style: retroStyle(35, Colors.white, FontWeight.w700),
              ),
              const SizedBox(height: 20),
              CustomKeyboard.MyKeyboard(onKeyPress: (key) {}),
            ],
          ),
        ),
      ),
    );
  }
}
