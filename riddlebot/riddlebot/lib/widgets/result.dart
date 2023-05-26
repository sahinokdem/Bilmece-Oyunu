import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int score;
  final Function restartApp;

  const Result({super.key, required this.score, required this.restartApp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 51, 51),
              Color.fromARGB(255, 221, 255, 0),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Tebrikler, harikaydın!\nToplam skorun $score',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  onPressed: () => restartApp(),
                  icon: const Icon(Icons.restart_alt_outlined),
                  label: const Text("Baştan Başla"))
            ],
          ),
        ),
      ),
    );
  }
}
