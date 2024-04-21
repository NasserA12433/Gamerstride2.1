// ignore_for_file: unused_import

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

import 'help_page.dart';
import 'timer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _timerDuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/help');
            },
            icon: const Icon(Icons.help),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 194, 194, 194)]
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Home Page',
                    style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  if (_timerDuration != null && _timerDuration! > 0)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TimerPage(timerDuration: _timerDuration)),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: 200,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Timer: $_timerDuration seconds',
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TimerPage()),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        _timerDuration = value as int?;
                      });
                    }
                  });
                },
                label: const Text('Create New Timer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
