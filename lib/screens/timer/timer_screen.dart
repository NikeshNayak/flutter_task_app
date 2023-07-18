import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  StopWatchTimer? _stopWatchTimer;

  Duration? _selectedDuration;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer!.dispose();
  }

  void setTime() async {
    Duration tempDuration = Duration.zero;
    final response = await showCupertinoModalPopup<Duration?>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 280.0,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(tempDuration);
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
              CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hms,
                initialTimerDuration: const Duration(),
                onTimerDurationChanged: (Duration duration) {
                  setState(() {
                    tempDuration = duration;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
    if (response != null) {
      _stopWatchTimer = StopWatchTimer(
        mode: StopWatchMode.countDown,
        presetMillisecond: StopWatchTimer.getMilliSecFromSecond(response.inSeconds),
        onChange: (value) => print('onChange $value'),
        onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
        onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
        onStopped: () {
          print('onStopped');
        },
        onEnded: () {
          print('onEnded');
        },
      );
      _stopWatchTimer?.onStartTimer();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _stopWatchTimer != null
              ? AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: StreamBuilder<int>(
                    stream: _stopWatchTimer!.rawTime,
                    initialData: _stopWatchTimer!.rawTime.value,
                    builder: (context, snap) {
                      final value = snap.data!;
                      final displayTime = StopWatchTimer.getDisplayTime(value, milliSecond: false);
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              displayTime,
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : const Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '00:00:00',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: _stopWatchTimer == null ? setTime : null,
                    child: const Text(
                      'Set Time',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      _stopWatchTimer!.onResetTimer();
                      _stopWatchTimer = null;
                      setState(() {});
                    },
                    child: const Text(
                      'Stop',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
