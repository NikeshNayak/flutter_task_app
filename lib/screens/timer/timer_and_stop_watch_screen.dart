import 'package:flutter/material.dart';
import 'package:flutter_task_app/screens/timer/stop_watch_screen.dart';
import 'package:flutter_task_app/screens/timer/timer_screen.dart';

class TimerAndStopWatchScreen extends StatefulWidget {
  const TimerAndStopWatchScreen({super.key});

  @override
  State<TimerAndStopWatchScreen> createState() => _TimerAndStopWatchScreenState();
}

class _TimerAndStopWatchScreenState extends State<TimerAndStopWatchScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Timer Task'),
        ),
        body: _currentIndex == 0 ? const StopWatchScreen() : const TimerScreen(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.watch),
              label: 'Stopwatch',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: 'Timer',
            ),
          ],
        ),
      ),
    );
  }
}
