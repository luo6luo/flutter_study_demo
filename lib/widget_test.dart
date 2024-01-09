import 'dart:math';

import 'package:flutter/material.dart';

class WidgetTest extends StatefulWidget {
  const WidgetTest({Key? key}) : super(key: key);

  @override
  State<WidgetTest> createState() => _WidgetTestState();
}

class _WidgetTestState extends State<WidgetTest> {
  @override
  Widget build(BuildContext context) {
    const widgetList = [
      _WidgetData('获取Widget大小', _WidgetSize()),
      _WidgetData('自定义IconFont', _CustomIconFont()),
      _WidgetData('CheckBox', _CheckBoxWidget()),
      _WidgetData('ProgressIndicator', _ProgressIndicator()),
      _WidgetData('Container', _Container()),
      _WidgetData('Transform', _Transform()),
      _WidgetData('Clip', _Clip()),
      _WidgetData('FittedBox', _FittedBox()),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Test'),
      ),
      body: _FittedBox(),
      // ListView.separated(
      //   itemBuilder: (context, index) => _WidgetItem(widgetList[index]),
      //   separatorBuilder: (context, index) {
      //     return const SizedBox(height: 16);
      //   },
      //   itemCount: widgetList.length,
      // ),
    );
  }
}

class _WidgetData {
  final String title;
  final Widget child;
  const _WidgetData(this.title, this.child);
}

class _WidgetItem extends StatelessWidget {
  final _WidgetData data;
  const _WidgetItem(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          data.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        data.child,
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }
}

// ------------------------------ 获取Widget大小 --------------------------------

/// 获取Widget大小
class _WidgetSize extends StatefulWidget {
  const _WidgetSize({Key? key}) : super(key: key);

  @override
  State<_WidgetSize> createState() => _WidgetSizeState();
}

class _WidgetSizeState extends State<_WidgetSize> {
  static final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            key: _key,
            width: 100,
            height: 150,
            color: Colors.red,
            child: const Text('Widget Size'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _onGetWidgetSize,
            child: const Text('获取Widget大小'),
          ),
        ],
      ),
    );
  }

  /// 获取Widget大小
  void _onGetWidgetSize() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset position = renderBox.localToGlobal(Offset.zero);
    debugPrint('size: $size；position: $position');
  }
}

// ------------------------------ 自定义IconFont --------------------------------

/// 自定义IconFont
class _CustomIconFont extends StatelessWidget {
  const _CustomIconFont({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(MyIcons.yinle, color: Colors.red),
        Icon(MyIcons.xiaoxi, color: Colors.green),
        Icon(MyIcons.zhinengyongche, color: Colors.yellow),
      ],
    );
  }
}

class MyIcons {
  /// 音乐
  static const IconData yinle = IconData(0xe65b, fontFamily: 'MyIcons');

  /// 消息
  static const IconData xiaoxi = IconData(0xe65c, fontFamily: 'MyIcons');

  /// 智能用车
  static const IconData zhinengyongche =
      IconData(0xe65d, fontFamily: 'MyIcons');
}

// ---------------------------------- CheckBox ---------------------------------

class _CheckBoxWidget extends StatefulWidget {
  const _CheckBoxWidget({Key? key}) : super(key: key);

  @override
  State<_CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<_CheckBoxWidget> {
  bool? _selected = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      tristate: true,
      value: _selected,
      activeColor: Colors.green, // 选中后，框内背景色
      checkColor: Colors.black, // 选中后，√ - 的颜色
      focusColor: Colors.deepPurple,
      hoverColor: Colors.deepOrange,
      // fillColor: MaterialStateProperty.resolveWith((states) {
      //   return Colors.amber;
      // }),
      // overlayColor: MaterialStateProperty.resolveWith((states) {
      //   return Colors.pinkAccent;
      // }),
      onChanged: (bool? value) {
        setState(() {
          _selected = value;
        });
      },
    );
  }
}

class _ProgressIndicator extends StatefulWidget {
  const _ProgressIndicator({Key? key}) : super(key: key);

  @override
  State<_ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<_ProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _colorAnimation =
        ColorTween(begin: Colors.red, end: Colors.yellow).animate(_controller);
    _progressAnimation =
        Tween<double>(begin: 0.0, end: 0.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          // const CircularProgressIndicator(),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => LinearProgressIndicator(
              value: _progressAnimation.value,
              backgroundColor: Colors.blueGrey,
              valueColor: _colorAnimation,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _controller.forward(),
            child: const Text('开始'),
          ),
          ElevatedButton(
            onPressed: () => _controller.reverse(),
            child: const Text('还原'),
          ),
        ],
      ),
    );
  }
}

class _Container extends StatelessWidget {
  const _Container({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: const BoxDecoration(
        color: Colors.red,
        gradient: LinearGradient(
          colors: [Colors.red, Colors.green, Colors.blue],
        ),
        backgroundBlendMode: BlendMode.difference,
      ),
    );
  }
}

class _Transform extends StatelessWidget {
  const _Transform({Key? key}) : super(key: key);

  /// Transform 发生在绘制期间，不会影响布局
  /// RotatedBox 发生在布局期间，会影响布局
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey,
      child: Transform.translate(
        offset: const Offset(100, 10),
        child: RotatedBox(
          quarterTurns: 2,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: const Color(0xFFE8581C),
            child: const Text('Apartment for rent!'),
          ),
        ),
      ),
    );
  }
}

class _Clip extends StatelessWidget {
  const _Clip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = Image.asset('assets/images/icon-128x128.png');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        image,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              widthFactor: 0.5,
              child: image,
            ),
            const Text('右侧占位文字', style: TextStyle(color: Colors.yellow)),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: 0.5,
                child: image,
              ),
            ),
            const Text('右侧占位文字', style: TextStyle(color: Colors.yellow)),
          ],
        ),

        /// 剪切发生在绘制阶段，所以不影响组件布局，组件大小不会变
        ColoredBox(
          color: Colors.red,
          child: ClipRect(
            clipper: _LogoClipper(),
            child: image,
          ),
        ),
      ],
    );
  }
}

class _LogoClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    // 自定义剪切区域
    final center = Offset(size.width / 2, size.height / 2);
    return Rect.fromCenter(center: center, width: 100, height: 50);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    // 是否重新剪切，如果剪切区域不变则返回false，避免不必要的重新剪切
    return false;
  }
}

class _FittedBox extends StatelessWidget {
  const _FittedBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return FittedBox(
          child: ConstrainedBox(
            constraints: constraints.copyWith(
              minWidth: constraints.maxWidth,
              maxWidth: double.infinity,
              // maxWidth: constraints.maxWidth,
            ),
            // Row 获取父约束 maxWidget == double.infinity，则 Row 实际宽度是子组件宽度和
            // Row 获取父约束 maxWidget != double.infinity，则 Row 实际宽度是父组件宽度
            // Row 子组件内容过长，超过父组件宽度，缩放子组件用于适配父组件宽度
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('19999999999999990'),
                SizedBox(width: 10),
                Text('19999999999999990'),
                SizedBox(width: 10),
                Text('19999999999999990'),
              ],
            ),
          ),
        );
      },
    );
  }
}
