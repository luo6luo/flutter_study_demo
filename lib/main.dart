import 'dart:async';

import 'package:flutter/material.dart';

import 'animation_test.dart';
import 'assets_test.dart';
import 'button_test.dart';
import 'constraint_test.dart';
import 'dialog_test.dart';
import 'error_test_page.dart';
import 'event_test.dart';
import 'feature_test.dart';
import 'grid_view_test.dart';
import 'inherited_widget_test.dart';
import 'isolate_test.dart';
import 'list_view_test.dart';
import 'log_test.dart';
import 'nested_scroll_view_test.dart';
import 'page_route_test.dart';
import 'page_view_test.dart';
import 'performance_test.dart';
import 'tab_bar_view_test.dart';
import 'text_filed_test.dart';
import 'theme_test.dart';
import 'widget_test.dart';

/// 收集日志
void reportLog(String message) {
  print('日志信息: $message');
}

/// 搜集错误信息
void reportErrorAndLog(FlutterErrorDetails details) {
  print('错误信息: ${details.toString()}');
}

/// 构建错误信息
FlutterErrorDetails makeDetails(Object obj, StackTrace stack) {
  return FlutterErrorDetails(
    exception: obj,
    stack: stack,
    library: 'Flutter Demo',
    context: ErrorDescription('while running a test'),
  );
}

void main() {
  // 自定义错误界面
  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Widget渲染异常！！！')),
  //     body: Container(
  //       color: Colors.white,
  //       child: const Center(
  //         child: Text(
  //           "出错啦！！！",
  //           style: TextStyle(color: Colors.black, fontSize: 26),
  //         ),
  //       ),
  //     ),
  //   );
  // };

  // 同步错误/构建错误
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details); // 调用默认的错误
    reportErrorAndLog(details);
  };

  // 捕获异步错误(方法二，官网推荐，不需要 runZoned 包裹)
  // PlatformDispatcher.instance.onError = (error, stackTrace) {
  //   reportErrorAndLog(makeDetails(error, stackTrace));
  //   return true;
  // };

  // runApp(const MyApp());

  // 自定义打印日志、拦截crash
  runZoned(
    () => runApp(const MyApp()),
    zoneSpecification: ZoneSpecification(
      // 拦截打印日志
      print: (Zone self, ZoneDelegate parent, Zone zone, String message) {
        parent.print(zone, '日志信息：$message');
      },
      // 捕获异步错误(方法一)
      handleUncaughtError: (Zone self, ZoneDelegate parent, Zone zone,
          Object error, StackTrace stackTrace) {
        reportErrorAndLog(makeDetails(error, stackTrace));
      },
    ),
  );
}

const _routes = {
  'Log': LogTest(),
  'Performance': PerformanceTest(),
  'Error': ErrorTestPage(),
  'Isolate': IsolateTest(),
  'Feature': FeatureTest(),
  'TextFiled': TextFieldTest(),
  'Button': ButtonTest(),
  'Animation': AnimationTest(),
  'PageRoute': PageRouteTest(),
  'Widget': WidgetTest(),
  'Assets': AssetsTest(),
  'Constraint': ConstraintTest(),
  'ListView': ListViewTest(),
  'GridView': GridViewTest(),
  'PageView': PageViewTest(),
  'TabBarView': TabBarViewTest(),
  'NestedScrollView': NestedScrollViewTest(),
  'InheritedWidget': InheritedWidgetTest(),
  'Theme': ThemeTest(),
  'Dialog': DialogTest(),
  'Event': EventTest(),
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // 用于不用 `context` 直接通过 [NavigatorState] 来跳转页面
  static final navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          shape: CircleBorder(),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
      ),

      /// 调试 - 开启性能图层
      showPerformanceOverlay: false,

      /// 调试 - 对齐网格
      debugShowMaterialGrid: false,

      /// 自定义的 error widget
      builder: (context, widget) {
        Widget error = Container(
          color: Colors.amberAccent,
          child: const Text('Widget渲染异常！！！'),
        );
        if (widget is Scaffold || widget is Navigator) {
          error = Scaffold(
            appBar: AppBar(title: const Text('Widget渲染异常！！！')),
            body: Container(
              color: Colors.white,
              child: const Center(
                child: Text(
                  "出错啦！！！",
                  style: TextStyle(color: Colors.black, fontSize: 26),
                ),
              ),
            ),
          );
        }

        ErrorWidget.builder = (FlutterErrorDetails details) => error;
        if (widget != null) return widget;
        throw ('widget is null');
      },
      onGenerateRoute: (settings) {
        final name = settings.name;
        try {
          return MaterialPageRoute(builder: (_) => _routes[name]!);
        } catch (e) {
          reportErrorAndLog(makeDetails(e, StackTrace.current));
        }
        return null;
      },
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
        children: _routes.keys
            .map((e) => ListTile(
                  title: Text(e),
                  onTap: () => _onTapItem(e),
                ))
            .toList(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onTapItem(String name) {
    Navigator.pushNamed(context, name);
  }
}
