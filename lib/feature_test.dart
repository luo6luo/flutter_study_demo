import 'package:flutter/material.dart';

class FeatureTest extends _AbstractClass {
  const FeatureTest({super.key});

  @override
  FeatureTestState createState() => FeatureTestState();
}

class FeatureTestState extends _AbstractClassState
    with _ImplementationMixin1, _ImplementationMixin2, _MixinClass {
  @override
  void initState() {
    super.initState();
    debugPrint('FeatureTestState - initState');

    // 打印结果：
    // flutter: 日志信息：_AbstractClassState - initState
    // flutter: 日志信息：_ImplementationMixin1 - initState
    // flutter: 日志信息：_ImplementationMixin2 - initState
    // flutter: 日志信息：FeatureTestState - initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feature Test')),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                printMixinClass();
              },
              child: const Text('MixinClass'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void test() {
    debugPrint('override _ImplementationMixin1 - test');
  }
}

abstract class _AbstractClass extends StatefulWidget {
  const _AbstractClass({super.key});
}

abstract class _AbstractClassState<T extends _AbstractClass> extends State<T> {
  @override
  void initState() {
    super.initState();
    debugPrint('_AbstractClassState - initState');
  }
}

mixin _ImplementationMixin1<T extends StatefulWidget> on State<T> {
  /// 接口功能，只有声明，没有实现
  void test();

  @override
  void initState() {
    super.initState();

    debugPrint('_ImplementationMixin1 - initState');
  }
}

mixin _ImplementationMixin2<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();

    debugPrint('_ImplementationMixin2 - initState');
  }
}

mixin class _MixinClass {
  void printMixinClass() {
    debugPrint('print - MixinClass');
  }
}

class _ImplementsClass {
  void printImplementsClass() {
    debugPrint('print - ImplementsClass');
  }
}

abstract class _ImplementsAbstractClass {
  void printImplementsAbstractClass1() {
    debugPrint('print - ImplementsAbstractClass1');
  }

  void printImplementsAbstractClass2();
}
