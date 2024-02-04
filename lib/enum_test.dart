import 'package:flutter/material.dart';

class EnumTest extends StatefulWidget {
  const EnumTest({super.key});

  @override
  State<EnumTest> createState() => _EnumTestState();
}

class _EnumTestState extends State<EnumTest> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

enum Fruit {
  apple,
  banana,
  pear,
  orange,
}
