import 'package:flutter/material.dart';

class PerformanceTest extends StatefulWidget {
  const PerformanceTest({Key? key}) : super(key: key);

  @override
  State<PerformanceTest> createState() => _PerformanceTestState();
}

class _PerformanceTestState extends State<PerformanceTest> {
  @override
  Widget build(BuildContext context) {
    final image = [
      'assets/images/background-test.png',
      'assets/images/christmas-background.png',
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Test'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _cpuTest();
            },
            child: const Text('CPU Test'),
          ),
          const SizedBox(height: 16),
          ...image.map((e) => Image.asset(e)),
        ],
      ),
    );
  }

  void _cpuTest() {
    int count = 0;
    for (var i = 0; i < 99999999; i++) {
      count++;
    }
    debugPrint('count: $count');
  }
}
