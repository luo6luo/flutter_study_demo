import 'package:flutter/material.dart';

class InheritedWidgetTest extends StatefulWidget {
  const InheritedWidgetTest({super.key});

  @override
  State<InheritedWidgetTest> createState() => _InheritedWidgetTestState();
}

class _InheritedWidgetTestState extends State<InheritedWidgetTest> {
  DataModel data = DataModel(name: '张三', age: 20);
  int age = 20;

  @override
  Widget build(BuildContext context) {
    debugPrint('InheritedWidgetTest - build');
    return Scaffold(
      appBar: AppBar(title: const Text('InheritedWidget Test')),
      body: DataWidget<int>(
        data: age,
        child: Column(
          children: [
            _ChildWidget1(_ChildWidget0()),
            TextButton(
              onPressed: () {
                setState(() {
                  data.name = '李四';
                });
              },
              child: const Text('修改名字'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // var temp = data;
                  // temp.age = data.age! + 1;
                  // data = temp;
                  age += 1;
                });
              },
              child: const Text('修改年龄'),
            ),
          ],
        ),
      ),
    );
  }
}

class DataModel {
  String? name;
  int? age;

  DataModel({this.name, this.age});
}

class DataWidget<T> extends InheritedWidget {
  const DataWidget({
    required this.data,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  final T data;

  static DataWidget of<T>(BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<DataWidget<T>>()!
        .widget as DataWidget<T>;

    // return context.dependOnInheritedWidgetOfExactType<DataWidget<T>>()!;
  }

  @override
  bool updateShouldNotify(DataWidget oldWidget) {
    return oldWidget.data != data;
  }
}

class _ChildWidget0 extends StatelessWidget {
  const _ChildWidget0({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('_ChildWidget0 - build');
    return Text('test');
  }
}

class _ChildWidget1 extends StatelessWidget {
  const _ChildWidget1(this.child, {super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    debugPrint('_ChildWidget1 - build');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        _ChildWidget2(),
        _ChildWidget3(),
      ],
    );
  }
}

class _ChildWidget2 extends StatelessWidget {
  const _ChildWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('_ChildWidget2 - build');
    final data = DataWidget.of<int>(context).data;
    return Text('name: ${data}');
  }
}

class _ChildWidget3 extends StatelessWidget {
  const _ChildWidget3({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('_ChildWidget3 - build');
    final data = DataWidget.of<int>(context).data;
    return Text('age: ${data}');
  }
}
