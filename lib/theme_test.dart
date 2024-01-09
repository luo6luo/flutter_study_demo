import 'package:flutter/material.dart';

class ThemeTest extends StatefulWidget {
  const ThemeTest({super.key});

  @override
  State<ThemeTest> createState() => _ThemeTestState();
}

class _ThemeTestState extends State<ThemeTest> {
  MaterialColor _themeData = Colors.red;

  @override
  void initState() {
    super.initState();

    const c = 'd98a7c';
    final color1 = Color(int.parse(c, radix: 16));
    debugPrint('color1: $color1');
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _themeData,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Theme Test')),
        body: const Column(
          children: [
            Text('我是一段文字'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _themeData = _themeData != Colors.blue ? Colors.blue : Colors.red;
            });
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.change_circle),
        ),
      ),
    );
  }
}
