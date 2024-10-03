import 'dart:async';

import 'package:flutter/material.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({super.key});

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  int milliseconds = 0;
  bool isTimerActive = false;
  late Timer timer;
  final laps = [];
  final itemHeight = 65.0;
  final scrollController = ScrollController();

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 100), _ticking);
    setState(() {
      isTimerActive = true;
    });
  }

  void _lap() {
    setState(() {
      laps.add(_secondsText(milliseconds));
    });
    scrollController.animateTo(itemHeight * laps.length,
        duration: const Duration(seconds: 1), curve: Curves.easeIn);
  }

  void stopTimer() {
    setState(() {
      isTimerActive = false;
      timer.cancel();
    });
  }

  void _ticking(Timer timer) {
    if (mounted) {
      setState(() {
        milliseconds += 100;
      });
    }
  }

  String _secondsText(int milliseconds) {
    final seconds = milliseconds / 1000;
    return "$seconds seconds";
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget _buildLaps(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemExtent: itemHeight,
      itemCount: laps.length,
      itemBuilder: (context, index) {
        final milliseconds = laps[index];
        return ListTile(
          title: Text("Lap $index"),
          subtitle: Text("Seconds $milliseconds"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("StopWatch"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Text(
            _secondsText(milliseconds),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: isTimerActive ? null : startTimer,
                child: const Text(
                  "Start",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: isTimerActive ? _lap : null,
                style: ElevatedButton.styleFrom(foregroundColor: Colors.teal),
                child: const Text(
                  "Laps",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: isTimerActive ? stopTimer : null,
                style: ElevatedButton.styleFrom(foregroundColor: Colors.teal),
                child: const Text(
                  "Stop",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
          Expanded(child: _buildLaps(context)),
        ],
      ),
    );
  }
}
