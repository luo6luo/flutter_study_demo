import 'package:flutter/material.dart';
import 'package:flutter_study_test/main.dart';

class PageRouteTest extends StatefulWidget {
  const PageRouteTest({Key? key}) : super(key: key);

  @override
  State<PageRouteTest> createState() => _PageRouteTestState();
}

class _PageRouteTestState extends State<PageRouteTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PageRouteTest')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            MyApp.navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (_) => const SecondPage()),
            );
          },
          child: const Text('Go to SecondPage'),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SecondPage')),
      body: const Center(
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Input',
          ),
        ),
      ),
    );
  }
}
