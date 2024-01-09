import 'package:flutter/material.dart';

class ErrorTestPage extends StatefulWidget {
  const ErrorTestPage({Key? key}) : super(key: key);

  @override
  State<ErrorTestPage> createState() => _ErrorTestPageState();
}

class _ErrorTestPageState extends State<ErrorTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ErrorTest')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                throw ('error');
              },
              child: const Text('sync Error'),
            ),
            ElevatedButton(
              onPressed: () {
                Future.delayed(const Duration(seconds: 1), () {
                  throw ('async error');
                });
              },
              child: const Text('Async Error'),
            ),
            ElevatedButton(
              onPressed: () {
                final list = <Widget>[];
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => list[5]),
                );
              },
              child: const Text('Build Error'),
            ),
            ElevatedButton(
              onPressed: () {
                print('log');
              },
              child: const Text('Log'),
            ),
          ],
        ),
      ),
    );
  }
}
