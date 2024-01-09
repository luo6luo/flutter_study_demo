import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:developer';

import 'package:flutter/scheduler.dart';

class LogTest extends StatefulWidget {
  const LogTest({Key? key}) : super(key: key);

  @override
  State<LogTest> createState() => _LogTestState();
}

class _LogTestState extends State<LogTest> {
  bool _paintEnabled = true;

  @override
  void initState() {
    super.initState();

    // 帧的开始-打印（可以在DevTool中直观查看，此处是代码控制查看）
    debugPrintBeginFrameBanner = false;

    // 统计应用启动时间
    // flutter run --trace-startup --debug/profile/release/
    // {
    //   "engineEnterTimestampMicros": 23524700452, // 进入Flutter引擎时间
    //   "timeToFrameworkInitMicros": 636454, // 初始化Flutter框架时间
    //   "timeToFirstFrameRasterizedMicros": 1734668, // 展示应用第一帧光栅化时间
    //   "timeToFirstFrameMicros": 1702414, // 展示应用第一帧时间
    //   "timeAfterFrameworkInitMicros": 1065960 // 完成Flutter框架初始化时间
    // }

    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {});
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    WidgetsBinding.instance.addTimingsCallback((timings) {});
  }

  @override
  void dispose() {
    // 帧的结束-打印（可以在DevTool中直观查看，此处是代码控制查看）
    debugPrintEndFrameBanner = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LogTest')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _onWriteln(),
              child: const Text('writeln'),
            ),
            ElevatedButton(
              onPressed: () => _onDebugPrint('debugPrint'),
              child: const Text('debugPrint'),
            ),
            ElevatedButton(
              onPressed: () => _onDeveloperLog(),
              child: const Text('developer.log'),
            ),
            ElevatedButton(
              onPressed: () => _onDebugger(101),
              child: const Text('debugger'),
            ),
            ElevatedButton(
              onPressed: () => _onDebugDumpApp(),
              child: const Text('debugDumpApp'),
            ),
            ElevatedButton(
              onPressed: () => _onDebugDumpRenderTree(),
              child: const Text('debugDumpRenderTree'),
            ),
            ElevatedButton(
              onPressed: () => _onDebugDumpLayerTree(),
              child: const Text('debugDumpLayerTree'),
            ),
            ElevatedButton(
              onPressed: () => _onDebugPaintEnabled(),
              child: const Text('debugPaintEnabled'),
            ),
            ElevatedButton(
              onPressed: () => _onTimeline(),
              child: const Text('Timeline'),
            ),
          ],
        ),
      ),
    );
  }

  void _onWriteln() {
    // 标准输出
    stdout.writeln('stdout.writeln');
    // 标准错误输出
    stderr.writeln('stderr.writeln');
  }

  void _onDebugPrint(String? message, {int? wrapWidth}) {
    // 输出：
    // flutter: 日志信息：message: debugPrint, wrapWidth: null
    //
    // wrapWidth：如果提供了，则会对 message 的每一行进行单词换行，以适应指定的宽度。
    debugPrint('message: $message, wrapWidth: $wrapWidth');
  }

  void _onDeveloperLog() {
    // 函数说明：
    // message: 要记录的消息字符串。
    // time: （可选）一个DateTime对象，表示记录日志的时间
    // sequenceNumber: （可选）一个整数，用于标识日志消息的序列号。
    // level: （可选）一个整数，表示消息的级别。0 表示信息，1 表示警告，2 表示错误。
    // name: （可选）一个字符串，用于标识记录器的名称。
    // zone: （可选）发出日志的区域。
    // error: （可选）与此日志事件关联的错误对象。有则打印对应错误信息。
    // stackTrace:（可选）与此日志事件关联的堆栈跟踪。有则打印对应堆栈信息。

    final jsonStr = jsonEncode({'code': 100, 'message': '错误信息'});

    // 输出：
    // [Info-信息：] 这是一个信息
    // {code: 100, message: 错误信息}
    log(
      '这是一个信息',
      time: DateTime.now(),
      sequenceNumber: 0,
      level: 0,
      name: 'Info-信息：',
      error: jsonDecode(jsonStr),
      // stackTrace: StackTrace.current,
    );

    // 输出：
    // [Warning-警告：] 这是一个警告
    // {code: 100, message: 错误信息}
    log(
      '这是一个警告',
      time: DateTime.now(),
      sequenceNumber: 1,
      level: 1,
      name: 'Warning-警告：',
      error: jsonDecode(jsonStr),
      // stackTrace: StackTrace.current,
    );

    // 输出：
    // [Error-错误：] 这是一个错误
    // {code: 100, message: 错误信息}
    // #0      LogTest._onDeveloperLog (package:flutter_study_test/log_test.dart:87:30)
    // #1      LogTest.build.<anonymous closure> (package:flutter_study_test/log_test.dart:22:32)
    // #2      _InkResponseState.handleTap (package:flutter/src/material/ink_well.dart:1096:21)
    // #3      GestureRecognizer.invokeCallback (package:flutter/src/gestures/recognizer.dart:253:24)
    // #4      TapGestureRecognizer.handleTapUp (package:flutter/src/gestures/tap.dart:627:11)
    // #5      BaseTapGestureRecognizer._checkUp (package:flutter/src/gestures/tap.dart:306:5)
    // #6      BaseTapGestureRecognizer.handlePrimaryPointer (package:flutter/src/gestures/tap.dart:239:7)
    // #7      PrimaryPointerGestureRecognizer.handleEvent (package:flutter/src/gestures/recognizer.dart:615:9)
    // #8      PointerRouter._dispatch (package:flutter/src/gestures/pointer_router.dart:98:12)
    // #9      PointerRouter._dispatchEventToRoutes.<anonymous closure> (package:flutter/src/gestures/pointer_router.dart:143:9)
    // #10     _LinkedHashMapMixin.forEach (dart:collection-patch/compact_hash.dart:625:13)
    // #11     PointerRouter._dispatchEventToRoutes (package:flutter/src/gestures/pointer_router.dart:141:18)
    // #12     PointerRouter.route (package:flutter/src/gestures/pointer_router.dart:127:7)
    // #13     GestureBinding.handleEvent (package:flutter/src/gestures/binding.dart:460:19)
    // #14     GestureBinding.dispatchEvent (package:flutter/src/gestures/binding.dart:440:22)
    // #15     RendererBinding.dispatchEvent (package:flutter/src/rendering/binding.dart:336:11)
    // #16     GestureBinding._handlePointerEventImmediately (package:flutter/src/gestures/binding.dart:395:7)
    // #17     GestureBinding.handlePointerEvent (package:flutter/src/gestures/binding.dart:357:5)
    // #18     GestureBinding._flushPointerEventQueue (package:flutter/src/gestures/binding.dart:314:7)
    // #19     GestureBinding._handlePointerDataPacket (package:flutter/src/gestures/binding.dart:295:7)
    // #20     _rootRunUnary (dart:async/zone.dart:1414:13)
    // #21     _CustomZone.runUnary (dart:async/zone.dart:1307:19)
    // #22     _CustomZone.runUnaryGuarded (dart:async/zone.dart:1216:7)
    // #23     _invoke1 (dart:ui/hooks.dart:166:10)
    // #24     PlatformDispatcher._dispatchPointerDataPacket (dart:ui/platform_dispatcher.dart:361:7)
    // #25     _dispatchPointerDataPacket (dart:ui/hooks.dart:91:31)
    log(
      '这是一个错误',
      time: DateTime.now(),
      sequenceNumber: 2,
      level: 2,
      name: 'Error-错误：',
      error: jsonDecode(jsonStr),
      stackTrace: StackTrace.current,
    );
  }

  void _onDebugger(int a) {
    // when = true，才会触发断点
    debugger(when: a > 100);
  }

  void _onDebugDumpApp() {
    // 打印 Widgets 树（可以在DevTools中直观查看，此处是代码控制查看）
    debugDumpApp();
  }

  void _onDebugDumpRenderTree() {
    // 打印 Render 树
    debugDumpRenderTree();
  }

  void _onDebugDumpLayerTree() {
    // 打印 Layer 树
    debugDumpLayerTree();
  }

  void _onDebugPaintEnabled() {
    // 打开视觉调试开关（可以在DevTools中直观查看，此处是代码控制查看）
    debugPaintSizeEnabled = _paintEnabled;
    debugPaintBaselinesEnabled = _paintEnabled;
    debugPaintPointersEnabled = _paintEnabled;
    debugPaintLayerBordersEnabled = _paintEnabled;
    debugRepaintRainbowEnabled = _paintEnabled;
    _paintEnabled = !_paintEnabled;
  }

  void _onTimeline() {
    // （可以在DevTool中直观查看，此处是代码控制查看）
    // Timeline.startSync('LogTest');
    // int count = 0;
    // for (var i = 0; i < 10000; i++) {
    //   count++;
    // }
    // print('count: $count');
    // Timeline.finishSync();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(StringProperty('message', '测试数据', showName: true));
    properties.add(DoubleProperty('scale', 0.5, defaultValue: 1.0));
    properties.add(DoubleProperty(
      'device pixel ratio',
      window.devicePixelRatio,
      tooltip: 'physical pixels per logical pixel',
    ));
  }
}
