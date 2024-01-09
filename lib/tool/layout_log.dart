import 'package:flutter/material.dart';

class LayoutLog extends StatelessWidget {
  const LayoutLog(this.child, {Key? key, this.id}) : super(key: key);

  final Widget child;
  final String? id;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // assert 只有在debug模式下才会调用
      // assert 判定为false，才会抛出异常，此处只是做 kDebug 环境输出作用
      assert(() {
        debugPrint('${id ?? key ?? child}: $constraints');
        return true;
      }());
      return child;
    });
  }
}
