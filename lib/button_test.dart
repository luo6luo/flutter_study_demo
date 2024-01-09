import 'package:flutter/material.dart';

class ButtonTest extends StatefulWidget {
  const ButtonTest({Key? key}) : super(key: key);

  @override
  State<ButtonTest> createState() => _ButtonTestState();
}

class Person {
  String? name;

  Person(this.name);
}

class _ButtonTestState extends State<ButtonTest> {
  final _person = Person('LK');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Button Test')),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              debugPrint('ElevatedButton');
              setState(() {
                _person.name = 'LKTest';
              });
            },
            child: Text(_person.name!),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              debugPrint('TextButton');
            },
            child: const Text('TextButton'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              debugPrint('OutlinedButton');
            },
            child: const Text('OutlinedButton'),
          ),
          const SizedBox(height: 12),
          IconButton(
            onPressed: () {
              debugPrint('IconButton');
            },
            icon: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              debugPrint('ElevatedButton.icon');
            },
            icon: const Icon(Icons.add),
            label: const Text('ElevatedButton.icon'),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              debugPrint('TextButton.icon');
            },
            icon: const Icon(Icons.add),
            label: const Text('TextButton.icon'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              debugPrint('OutlinedButton.icon');
            },
            icon: const Icon(Icons.add),
            label: const Text('OutlinedButton.icon'),
          ),
        ],
      ),
    );
  }
}
