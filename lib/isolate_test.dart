import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';

class IsolateTest extends StatefulWidget {
  const IsolateTest({Key? key}) : super(key: key);

  @override
  State<IsolateTest> createState() => _IsolateTestState();
}

class _IsolateTestState extends State<IsolateTest> {
  @override
  void initState() {
    super.initState();

    // _isolateTest();
    // _futureTest();
    // _futureComputation();
    // _futureMicrotask();
    // _futureValue();
    // _futureDelayed();
    // _futureSync();
    // _futureError();
    // _asyncAwait();
    _asyncAwait1();
  }

  void _isolateTest() async {
    print('开始 - ${DateTime.now()}');

    final isolate1 = await Isolate.spawn((message) {
      Future.delayed(const Duration(seconds: 1), () {
        print('isolate1 - ${DateTime.now()}');
      });
    }, 'isolate1');
    print('第一个 - $isolate1 - ${DateTime.now()}');

    final isolate2 = await Isolate.spawn((message) {
      Future.delayed(const Duration(seconds: 1), () {
        print('isolate2 - ${DateTime.now()}');
      });
    }, 'isolate2');
    print('第二个 - $isolate2 - ${DateTime.now()}');

    final isolate3 = Isolate.run(() {
      Future.delayed(const Duration(seconds: 1), () {
        print('isolate3 - ${DateTime.now()}');
      });
    });
    isolate3.whenComplete(() {
      print('isolate3 complete - ${DateTime.now()}');
    });
    print('第三个 - $isolate3 - ${DateTime.now()}');

    print('结束 - ${DateTime.now()}');

    // 打印结果:
    // flutter: 日志信息：现在 - 2023-08-08 15:18:01.656694
    // flutter: 日志信息：1 - Instance of 'Isolate' - 2023-08-08 15:18:01.690489
    // flutter: 日志信息：2 - Instance of 'Isolate' - 2023-08-08 15:18:01.705165
    // flutter: 日志信息：3 - Instance of 'Future<Null>' - 2023-08-08 15:18:01.705573
    // flutter: 日志信息：执行后 - 2023-08-08 15:18:01.705809
    // flutter: 日志信息：isolate3 complete - 2023-08-08 15:18:02.075330
    // flutter: isolate1 - 2023-08-08 15:18:02.814508
    // flutter: isolate2 - 2023-08-08 15:18:02.996615
  }

  // Future<void> _future1() async {
  //   print('_future1: 调用 _future2 之前');
  //   await _future2();
  //   print('_future1: 调用 _future2 之后');
  // }
  //
  // Future<String> _future2() {
  //   print('_future2: ');
  //   return Future(() {
  //     print('4: _future2');
  //     return 'future2';
  //   });
  // }

  /// 抛出异常
  void _crashComputation() {
    throw Exception("抛异常");
  }

  /// 获取同步调用数据
  String _getSyncComputation() {
    print("获取同步函数中的数据 sync value");
    return "sync value";
  }

  /// 获取异步调用数据
  Future<String> _getAsyncComputation() async {
    final r = Future(() {
      print("获取异步函数中的数据 Future async value");
      return "async value";
    });
    return r;
  }

  /// 获取异步调用数据
  Future<String> _getAsyncMicrotaskComputation() async {
    final r = Future.microtask(() {
      print("获取异步函数中的数据 microtask async value");
      return "async value";
    });
    return r;
  }

  void _futureTest() {
    Future.delayed(
      const Duration(seconds: 1),
      () => print("1：Future.delayed() 1 second - computation"),
    );
    Future(() => {print("2：Future() - computation")}).then(
      (value) => print("2：Future() - then"),
    );
    Future.delayed(Duration.zero,
        () => print("3：Future.delayed() 0 second - computation")).then((value) {
      scheduleMicrotask(
          () => print("3：Future.delayed() 0 second - scheduleMicrotask"));
      print("3：Future.delayed() 0 second - first then");
    }).then((value) => print("3：Future.delayed() 0 second - second then"));

    scheduleMicrotask(() => {print("4：scheduleMicrotask - computation")});
    Future.microtask(() => print("5：Future.microtask() - computation")).then(
      (value) => print("5：Future.microtask() - then"),
    );
    Future.value(_getAsyncComputation()).then(
      (value) => print("6：Future.value() have async value - then"),
    );
    Future.value().then((value) => print("7：Future.value() no value - then"));

    print("8：main 1");
    Future.sync(() => print("9：Future.sync() - computation")).then(
      (value) => print("9：Future.sync() - then"),
    );
    Future.value(_getSyncComputation()).then(
      (value) => print("10：Future.value() have sync value - then"),
    );
    print("11：main 4");
  }

  /// Future(() => {}) 创建事件类型
  void _futureComputation() {
    print('main：前');

    // 测试 Future(() => {}) 创建异步事件类型
    // 同步测试 Future(() => {}).then() 执行时机
    //
    // 执行结果:
    // flutter: 日志信息：main：前
    // flutter: 日志信息：main：后
    // flutter: 日志信息：scheduleMicrotask：前
    // flutter: 日志信息：scheduleMicrotask：后
    // flutter: 日志信息：Future：执行中（2）
    // flutter: 日志信息：Future - then：执行后
    // flutter: 日志信息：Future：执行中（1），创建 scheduleMicrotask：前
    // flutter: 日志信息：Future：执行中（3），创建 scheduleMicrotask：后
    scheduleMicrotask(() => print('scheduleMicrotask：前'));
    Future(() {
      scheduleMicrotask(() => print('Future：执行中（1），创建 scheduleMicrotask：前'));
      print('Future：执行中（2）');
      scheduleMicrotask(() => print('Future：执行中（3），创建 scheduleMicrotask：后'));
    }).then((value) => print('Future - then：执行后'));
    scheduleMicrotask(() => print('scheduleMicrotask：后'));

    // 多种执行结果
    // 1、抛异常
    // 2、返回 Future
    // 3、返回非 Future 值
    //
    // 执行结果:
    // flutter: 日志信息：main：前
    // flutter: 日志信息：main：后
    // flutter: 错误信息: ══╡ EXCEPTION CAUGHT BY FLUTTER DEMO ╞═══════════════════════════
    // The following _Exception was thrown while running a test:
    // Exception: 抛异常
    //
    // When the exception was thrown, this was the stack:
    // #0      _IsolateTestState._crashComputation (package:flutter_study_test/isolate_test.dart:79:5)
    // #1      _IsolateTestState._futureComputation.<anonymous closure> (package:flutter_study_test/isolate_test.dart:158:29)
    // #13     _RawReceivePort._handleMessage (dart:isolate-patch/isolate_patch.dart:192:26)
    // (elided 11 frames from class _Timer, dart:async, and dart:async-patch)
    // ═════════════════════════════════════════════════════════════════
    // flutter: 日志信息：获取同步函数中的数据 sync value
    // flutter: 日志信息：执行r2 - sync value
    // flutter: 日志信息：获取异步函数中的数据 async value
    // flutter: 日志信息：执行r1 - async value
    final r0 = Future(() => _crashComputation());
    final r1 = Future(() => _getAsyncComputation());
    final r2 = Future(() => _getSyncComputation());
    try {
      r0.then((_) => print('执行r0'));
      r1.then((value) => print('执行r1 - $value'));
      r2.then((value) => print('执行r2 - $value'));
    } catch (e) {
      print('抛异常: $e');
    }

    print('main：后');
  }

  /// Future.microtask(() => {}) 创建事件类型
  void _futureMicrotask() {
    print('main：前');

    // 测试 Future.microtask(() => {}) 创建异步事件类型
    // 同步测试 Future.microtask(() => {}).then() 执行时机
    //
    // 执行结果:
    // flutter: 日志信息：main：前
    // flutter: 日志信息：main：后
    // flutter: 日志信息：scheduleMicrotask：前
    // flutter: 日志信息：FutureMicrotask：执行中（2）
    // flutter: 日志信息：FutureMicrotask - then：执行后
    // flutter: 日志信息：scheduleMicrotask：后
    // flutter: 日志信息：FutureMicrotask：执行中（1），创建 scheduleMicrotask：前
    // flutter: 日志信息：FutureMicrotask：执行中（3），创建 scheduleMicrotask：后
    // scheduleMicrotask(() => print('scheduleMicrotask：前'));
    // Future.microtask(() {
    //   scheduleMicrotask(
    //     () => print('FutureMicrotask：执行中（1），创建 scheduleMicrotask：前'),
    //   );
    //   print('FutureMicrotask：执行中（2）');
    //   scheduleMicrotask(
    //     () => print('FutureMicrotask：执行中（3），创建 scheduleMicrotask：后'),
    //   );
    // }).then((value) => print('FutureMicrotask - then：执行后'));
    // scheduleMicrotask(() => print('scheduleMicrotask：后'));

    // 多种执行结果
    // 1、抛异常
    // 2、返回 Future
    // 3、返回非 Future 值
    //
    // 执行结果:
    // flutter: 日志信息：main：前
    // flutter: 日志信息：main：后
    // flutter: 错误信息: ══╡ EXCEPTION CAUGHT BY FLUTTER DEMO ╞═══════════════════════════
    // The following _Exception was thrown while running a test:
    // Exception: 抛异常
    //
    // When the exception was thrown, this was the stack:
    // #0      _IsolateTestState._crashComputation (package:flutter_study_test/isolate_test.dart:80:5)
    // #1      _IsolateTestState._futureMicrotask.<anonymous closure> (package:flutter_study_test/isolate_test.dart:241:39)
    // (elided 11 frames from dart:async)
    // ═════════════════════════════════════════════════════════════════
    // flutter: 日志信息：获取同步函数中的数据 sync value
    // flutter: 日志信息：执行r2 - sync value
    // flutter: 日志信息：获取异步函数中的数据 async value
    // flutter: 日志信息：执行r1 - async value
    final r0 = Future.microtask(() => _crashComputation());
    final r1 = Future.microtask(() => _getAsyncComputation());
    final r2 = Future.microtask(() => _getSyncComputation());
    try {
      r0.then((_) => print('执行r0'));
      r1.then((value) => print('执行r1 - $value'));
      r2.then((value) => print('执行r2 - $value'));
    } catch (e) {
      print('抛异常: $e');
    }

    print('main：后');
  }

  /// Future.value(() => {}) 创建事件类型
  void _futureValue() {
    print('main：前');

    // 测试 Future.value(() => {}) 创建异步事件类型
    // 同步测试 Future.value(() => {}).then() 执行时机
    //
    // 执行结果:
    // flutter: 日志信息：main：前
    // flutter: 日志信息：获取同步函数中的数据 sync value
    // flutter: 日志信息：main：后
    // flutter: 日志信息：scheduleMicrotask：前
    // flutter: 日志信息：sync.value - then：sync value
    // flutter: 日志信息：获取异步函数中的数据 microtask async value
    // flutter: 日志信息：Future.microtask.value - then：async value
    // flutter: 日志信息：null.value - then：null
    // flutter: 日志信息：scheduleMicrotask：后
    // flutter: 日志信息：获取异步函数中的数据 Future async value
    // flutter: 日志信息：Future.async.value - then：async value
    // scheduleMicrotask(() => print('scheduleMicrotask：前'));
    Future.value(_getSyncComputation()).then(
      (value) => print('sync.value - then：$value'),
    );
    Future.value(_getAsyncComputation()).then(
      (value) => print('Future.async.value - then：$value'),
    );
    Future.value(_getAsyncMicrotaskComputation()).then(
      (value) => print('Future.microtask.value - then：$value'),
    );
    Future.value(null).then((value) => print('null.value - then：$value'));
    scheduleMicrotask(() => print('scheduleMicrotask：后'));

    print('main：后');
  }

  /// Future.delayed(() => {}) 创建事件类型
  void _futureDelayed() {
    print('main：前');

    // 测试 Future.delayed(() => {}) 创建异步事件类型
    // 同步测试 Future.delayed(() => {}).then() 执行时机
    //
    // 延时0秒，执行结果:
    // flutter: 日志信息：main：前
    // flutter: 日志信息：main：后
    // flutter: 日志信息：scheduleMicrotask：前
    // flutter: 日志信息：scheduleMicrotask：后
    // flutter: 日志信息：Future：执行中（2）
    // flutter: 日志信息：Future - then：执行后
    // flutter: 日志信息：Future：执行中（1），创建 scheduleMicrotask：前
    // flutter: 日志信息：Future：执行中（3），创建 scheduleMicrotask：后
    scheduleMicrotask(() => print('scheduleMicrotask：前'));
    Future.delayed(const Duration(seconds: 2), () {
      scheduleMicrotask(() => print('Future：执行中（1），创建 scheduleMicrotask：前'));
      print('Future：执行中（2）');
      scheduleMicrotask(() => print('Future：执行中（3），创建 scheduleMicrotask：后'));
    }).then((value) => print('Future - then：执行后'));
    scheduleMicrotask(() => print('scheduleMicrotask：后'));

    // 多种执行结果
    // 1、抛异常
    // 2、返回 Future
    // 3、返回非 Future 值
    //
    // 延时0秒，执行结果:
    // flutter: 日志信息：main：前
    // flutter: 日志信息：main：后
    // flutter: 错误信息: ══╡ EXCEPTION CAUGHT BY FLUTTER DEMO ╞═══════════════════════════
    // The following _Exception was thrown while running a test:
    // Exception: 抛异常
    //
    // When the exception was thrown, this was the stack:
    // #0      _IsolateTestState._crashComputation (package:flutter_study_test/isolate_test.dart:82:5)
    // #1      _IsolateTestState._futureDelayed.<anonymous closure> (package:flutter_study_test/isolate_test.dart:345:13)
    // #13     _RawReceivePort._handleMessage (dart:isolate-patch/isolate_patch.dart:192:26)
    // (elided 11 frames from class _Timer, dart:async, and dart:async-patch)
    // ═════════════════════════════════════════════════════════════════
    // flutter: 日志信息：获取同步函数中的数据 sync value
    // flutter: 日志信息：执行r2 - sync value
    // flutter: 日志信息：获取异步函数中的数据 Future async value
    // flutter: 日志信息：执行r1 - async value
    final r0 = Future.delayed(
      const Duration(seconds: 0),
      () => _crashComputation(),
    );
    final r1 = Future.delayed(
      const Duration(seconds: 0),
      () => _getAsyncComputation(),
    );
    final r2 = Future.delayed(
      const Duration(seconds: 0),
      () => _getSyncComputation(),
    );
    try {
      r0.then((_) => print('执行r0'));
      r1.then((value) => print('执行r1 - $value'));
      r2.then((value) => print('执行r2 - $value'));
    } catch (e) {
      print('抛异常: $e');
    }

    print('main：后');
  }

  /// Future.sync(() => {}) 创建事件类型
  void _futureSync() {
    // 测试 Future.sync(() => {}) 创建异步事件类型
    // 同步测试 Future.sync(() => {}).then() 执行时机
    //
    // 执行结果:
    // flutter: 日志信息：main：前
    // flutter: 日志信息：获取同步函数中的数据 sync value
    // flutter: 日志信息：main：后
    // flutter: 日志信息：scheduleMicrotask：前
    // flutter: 日志信息：sync.value：执行中，创建 scheduleMicrotask：前
    // flutter: 日志信息：sync.value：执行中，创建 scheduleMicrotask：后
    // flutter: 日志信息：sync.value - then
    // flutter: 日志信息：async.value：执行中，创建 scheduleMicrotask：前
    // flutter: 日志信息：async.value：执行中，创建 scheduleMicrotask：后
    // flutter: 日志信息：async.value - then
    // flutter: 日志信息：microtask.async.value：执行中，创建 scheduleMicrotask：前
    // flutter: 日志信息：获取异步函数中的数据 microtask async value
    // flutter: 日志信息：microtask.async.value：执行中，创建 scheduleMicrotask：后
    // flutter: 日志信息：microtask.async.value - then
    // flutter: 日志信息：scheduleMicrotask：后
    // flutter: 日志信息：获取异步函数中的数据 Future async value
    print('main：前');
    scheduleMicrotask(() => print('scheduleMicrotask：前'));

    // 执行同步函数
    Future.sync(() {
      scheduleMicrotask(() => print('sync.value：执行中，创建 scheduleMicrotask：前'));
      _getSyncComputation();
      scheduleMicrotask(() => print('sync.value：执行中，创建 scheduleMicrotask：后'));
    }).then(
      (value) => print('sync.value - then'),
    );
    // 执行异步函数（创建事件任务）
    Future.sync(() {
      scheduleMicrotask(() => print('async.value：执行中，创建 scheduleMicrotask：前'));
      _getAsyncComputation();
      scheduleMicrotask(() => print('async.value：执行中，创建 scheduleMicrotask：后'));
    }).then(
      (value) => print('async.value - then'),
    );
    // 执行异步函数（创建微任务）
    Future.sync(() {
      scheduleMicrotask(
          () => print('microtask.async.value：执行中，创建 scheduleMicrotask：前'));
      _getAsyncMicrotaskComputation();
      scheduleMicrotask(
          () => print('microtask.async.value：执行中，创建 scheduleMicrotask：后'));
    }).then(
      (value) => print('microtask.async.value - then'),
    );

    scheduleMicrotask(() => print('scheduleMicrotask：后'));
    print('main：后');
  }

  /// Future.error(() => {}) 创建事件类型
  void _futureError() {
    errorFunc() {
      print('Future：执行中');
      return Error();
    }

    // 测试 Future.error(() => {}) 创建异步事件类型
    // 同步测试 Future.error(() => {}).then() 执行时机
    //
    // 执行结果:
    // flutter: 日志信息：main：前
    // flutter: 日志信息：Future：执行中
    // flutter: 日志信息：main：后
    // flutter: 日志信息：scheduleMicrotask：前
    // flutter: 错误信息: ══╡ EXCEPTION CAUGHT BY FLUTTER DEMO ╞═══════════════════════════
    // The following Error was thrown while running a test:
    // Instance of 'Error'
    //
    // When the exception was thrown, this was the stack
    // ═════════════════════════════════════════════════════════════════
    // flutter: 日志信息：scheduleMicrotask：后
    print('main：前');
    scheduleMicrotask(() => print('scheduleMicrotask：前'));
    Future.error(errorFunc()).then((value) => print('Future - then：执行后'));
    scheduleMicrotask(() => print('scheduleMicrotask：后'));
    print('main：后');
  }

  void _asyncAwait() async {
    // 执行结果:
    // flutter: 日志信息：main：前
    // flutter: 日志信息：fun 前
    // flutter: 日志信息：async1 执行中
    // flutter: 日志信息：main：后
    // flutter: 日志信息：fun 后，async1
    //
    // 执行说明：
    // `async1` 虽然是个异步函数，但是函数体中没有 `await` 关键字，所以函数体中的代码会同步执行
    Future<String> async1() async {
      print('async1 执行中');
      return 'async1';
    }

    // 执行结果:
    // flutter: 日志信息：main：前
    // flutter: 日志信息：fun 前
    // flutter: 日志信息：async2 执行中 前
    // flutter: 日志信息：main：后
    // flutter: 日志信息：microtask 执行中
    // flutter: 日志信息：async2 执行中 后
    // flutter: 日志信息：fun 后，async2
    //
    // 执行说明：
    // `async2` 异步函数，先同步执行 `await` 关键字之前的代码，
    // 再将 `await` 后的代码包装为一个微任务，放到微任务队列中
    Future<String> async2() async {
      print('async2 执行中 前');
      await Future.microtask(() => print('microtask 执行中'));
      print('async2 执行中 后');
      return 'async2';
    }

    // 执行结果:
    // flutter: 日志信息：main：前
    // flutter: 日志信息：fun 前
    // flutter: 日志信息：async3 执行中 前
    // flutter: 日志信息：main：后
    // flutter: 日志信息：async3 执行中 后
    // flutter: 日志信息：fun 后，async3
    //
    // 执行说明：
    // `async3` 异步函数，先同步执行 `await` 关键字之前的代码，
    // 再将 `await` 后的代码包装为一个微任务，放到微任务队列中
    Future<String> async3() async {
      print('async3 执行中 前');
      final r = await '100';
      print('async3 执行中 后');
      return 'async3';
    }

    // 总结执行说明：
    // `async` 标记的异步函数，先同步执行其中 `await` 关键字之前的代码，
    // 再将 `await` 后的代码包装为一个微任务，放到微任务队列中。
    // 如果没有 `await` 关键字，那么函数体中的代码会同步执行。
    Future<void> fun() async {
      print('fun 前');
      // String value1 = await async1();
      // String value2 = await async2();
      String value3 = await async3();
      print('fun 后，$value3');
    }

    // 执行结果:
    // flutter: 日志信息：main：前
    // flutter: 日志信息：fun 前
    // flutter: 日志信息：async1 执行中
    // flutter: 日志信息：main：后
    // flutter: 日志信息：async2 执行中 前
    // flutter: 日志信息：microtask 执行中
    // flutter: 日志信息：async2 执行中 后
    // flutter: 日志信息：async3 执行中 前
    // flutter: 日志信息：async3 执行中 后
    // flutter: 日志信息：fun 后，async1，async2，async3
    //
    // async 会将它标注的函数返回值包装成一个 Future，当执行 async 标注的函数时，在遇到 await 之前，
    // 会将该函数当成同步函数执行，如果 遇到 await，则将 await 及后面的代码包装到一个 Future 中并结束当前函数，
    // 当 await 拿到对应的值再执行 await 后面的代码。
    print('main：前');
    fun();
    print('main：后');
  }

  void _asyncAwait1() {
    print('Start');

    // 添加一个定时器事件
    Timer(Duration(seconds: 2), () {
      print('Timer event');
    });

    // 添加一个 IO 事件
    String filePath =
        '/Users/lg/Desktop/study_flutter/flutter_study_test/lib/test.txt';
    File(filePath).readAsString().then((data) {
      print('IO event: $data');
    });

    // 添加一个异步任务
    _fetchData().then((result) {
      print('Async event: $result');
    });

    print('End');

    // 执行结果:
    // flutter: 日志信息：Start
    // flutter: 日志信息：End
    // flutter: 日志信息：IO event: File文件读取的数据: 测试
    // flutter: 日志信息：Async event: Data loaded
    // flutter: 日志信息：Timer event
  }

  Future<String> _fetchData() {
    return Future.delayed(Duration(seconds: 1), () => 'Data loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IsolateTest')),
      body: const Placeholder(),
    );
  }
}
