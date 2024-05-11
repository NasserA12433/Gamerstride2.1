import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'help_page.dart'; // Import the HelpPage widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimerPage(),
    );
  }
}

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key, int? timerDuration}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late CountDownController _controller;
  int _durationInSeconds = 0;
  bool _timerRunning = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _controller = CountDownController();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _startTimer(int durationInSeconds) {
    setState(() {
      _durationInSeconds = durationInSeconds;
      _timerRunning = true;
    });
    _controller.restart(duration: durationInSeconds);
    _startPushNotificationTimer(durationInSeconds);
  }

  void _removeTimer() {
    _controller.restart(duration: 0); // Restart the timer with duration 0
    setState(() {
      _durationInSeconds = 0;
      _timerRunning = false;
    });
  }

  void _startPushNotificationTimer(int durationInSeconds) {
    Timer(const Duration(seconds: 20), () {
      if (_timerRunning) {
        _showNotification();
        _timerRunning = false;
      }
    });
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'timer_channel_id',
      'Timer Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Stand & Stretch Reminder',
      'It\'s time to stand up and stretch!',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularCountDownTimer(
              duration: _durationInSeconds,
              controller: _controller,
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              ringColor: Colors.grey[300]!,
              fillColor: Colors.purpleAccent[100]!,
              backgroundColor: Colors.purple[500]!,
              strokeWidth: 20.0,
              strokeCap: StrokeCap.round,
              textStyle: const TextStyle(
                fontSize: 33.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              isTimerTextShown: true,
              onComplete: () {
                _timerRunning = false;
                // Handle timer completion
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _removeTimer();
              },
              child: const Text('Remove Timer'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => _buildTimerDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTimerDialog() {
    TextEditingController hoursController = TextEditingController();
    TextEditingController minutesController = TextEditingController();
    TextEditingController secondsController = TextEditingController();

    return AlertDialog(
      title: const Text('Set Timer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: hoursController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Hours',
            ),
          ),
          TextField(
            controller: minutesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Minutes',
            ),
          ),
          TextField(
            controller: secondsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Seconds',
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            int hours = int.tryParse(hoursController.text) ?? 0;
            int minutes = int.tryParse(minutesController.text) ?? 0;
            int seconds = int.tryParse(secondsController.text) ?? 0;

            int durationInSeconds = hours * 3600 + minutes * 60 + seconds;

            if (durationInSeconds > 0) {
              _startTimer(durationInSeconds);
              Navigator.of(context).pop();
            } else {
              // Handle invalid input
            }
          },
          child: const Text('Start Timer'),
        ),
      ],
    );
  }
}
