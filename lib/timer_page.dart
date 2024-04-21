import 'package:circular_countdown_timer/circular_countdown_timer.dart' show CircularCountDownTimer, CountDownController;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TimerPage(),
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

  @override
  void initState() {
    super.initState();
    _controller = CountDownController();
  }

  void _startTimer(int durationInSeconds) {
    setState(() {
      _durationInSeconds = durationInSeconds;
    });
    _controller.restart(duration: durationInSeconds);
  }

  void _removeTimer() {
    _controller.pause();
    setState(() {
      _durationInSeconds = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Page'),
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
