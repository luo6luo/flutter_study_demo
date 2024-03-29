import 'package:flutter/material.dart';

class AnimationTest extends StatefulWidget {
  const AnimationTest({Key? key}) : super(key: key);

  @override
  State<AnimationTest> createState() => _AnimationTestState();
}

class _AnimationTestState extends State<AnimationTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animation Test')),
      body: const TweenAnimationValueExample(),
    );
  }
}

/// 自定义路由动画
class CustomPageRouteBuilderTest extends StatefulWidget {
  const CustomPageRouteBuilderTest({super.key});

  @override
  State<CustomPageRouteBuilderTest> createState() =>
      _CustomPageRouteBuilderTestState();
}

class _CustomPageRouteBuilderTestState
    extends State<CustomPageRouteBuilderTest> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder<void>(
              pageBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return Scaffold(
                  appBar: AppBar(title: const Text('Hello')),
                  body: const Center(
                    child: Text('Hello World'),
                  ),
                );
              },
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(1.0, 0.0),
                    ).animate(secondaryAnimation),
                    child: child,
                  ),
                );
              },
            ),
          );
        },
        child: const Text('自定义路由动画'),
      ),
    );
  }
}

class AnimatedSwitcher0Example extends StatefulWidget {
  const AnimatedSwitcher0Example({super.key});

  @override
  State<AnimatedSwitcher0Example> createState() =>
      _AnimatedSwitcher0ExampleState();
}

class _AnimatedSwitcher0ExampleState extends State<AnimatedSwitcher0Example> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              '$_count',
              // This key causes the AnimatedSwitcher to interpret this as a "new"
              // child each time the count changes, so that it will begin its animation
              // when the count changes.
              key: ValueKey<int>(_count),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          ElevatedButton(
            child: const Text('Increment'),
            onPressed: () {
              setState(() {
                _count += 1;
              });
            },
          ),
        ],
      ),
    );
  }
}

/// 模拟路由切换
class AnimatedSwitcher1Example extends StatefulWidget {
  const AnimatedSwitcher1Example({super.key});

  @override
  State<AnimatedSwitcher1Example> createState() =>
      _AnimatedSwitcher1ExampleState();
}

class _AnimatedSwitcher1ExampleState extends State<AnimatedSwitcher1Example> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final positionTween =
                  Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
              return MyScaleTransition(
                position: positionTween.animate(animation),
                child: child,
              );
            },
            child: Text(
              '$_count',
              // This key causes the AnimatedSwitcher to interpret this as a "new"
              // child each time the count changes, so that it will begin its animation
              // when the count changes.
              key: ValueKey<int>(_count),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          ElevatedButton(
            child: const Text('Increment'),
            onPressed: () {
              setState(() {
                _count += 1;
              });
            },
          ),
        ],
      ),
    );
  }
}

class MyScaleTransition extends AnimatedWidget {
  const MyScaleTransition({
    super.key,
    required Animation<Offset> position,
    required this.child,
  }) : super(listenable: position);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final position = listenable as Animation<Offset>;
    Offset value = position.value;
    if (position.status == AnimationStatus.reverse) {
      value = Offset(-value.dx, value.dy);
    }
    return FractionalTranslation(
      translation: value,
      child: child,
    );
  }
}

class RelativePositionedTransitionExample extends StatefulWidget {
  const RelativePositionedTransitionExample({Key? key}) : super(key: key);

  @override
  State<RelativePositionedTransitionExample> createState() =>
      _RelativePositionedTransitionExampleState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _RelativePositionedTransitionExampleState
    extends State<RelativePositionedTransitionExample>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double smallLogo = 100;
    const double bigLogo = 200;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size biggest = constraints.biggest;
        return Stack(
          children: <Widget>[
            RelativePositionedTransition(
              size: Size(biggest.width / 2, biggest.height),
              rect: RectTween(
                begin: const Rect.fromLTRB(0, 0, smallLogo, smallLogo),
                end: Rect.fromLTRB(
                  biggest.width / 2 - bigLogo,
                  biggest.height - bigLogo,
                  biggest.width / 2,
                  biggest.height,
                ),
              ).animate(
                CurvedAnimation(
                  parent: _controller,
                  // curve: Curves.linear,
                  curve: const Interval(0, 1.0, curve: Curves.linear),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: FlutterLogo(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PositionedTransitionExample extends StatefulWidget {
  const PositionedTransitionExample({Key? key}) : super(key: key);

  @override
  State<PositionedTransitionExample> createState() =>
      _PositionedTransitionExampleState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _PositionedTransitionExampleState
    extends State<PositionedTransitionExample> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double smallLogo = 100;
    const double bigLogo = 200;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size biggest = constraints.biggest;
        return Stack(
          children: <Widget>[
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                  const Rect.fromLTWH(0, 0, smallLogo, smallLogo),
                  biggest,
                ),
                end: RelativeRect.fromSize(
                  Rect.fromLTWH(
                    biggest.width - bigLogo,
                    biggest.height - bigLogo,
                    bigLogo,
                    bigLogo,
                  ),
                  biggest,
                ),
              ).animate(CurvedAnimation(
                parent: _controller,
                curve: Curves.elasticInOut,
              )),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: FlutterLogo(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DecoratedBoxTransitionExample extends StatefulWidget {
  const DecoratedBoxTransitionExample({Key? key}) : super(key: key);

  @override
  State<DecoratedBoxTransitionExample> createState() =>
      _DecoratedBoxTransitionExampleState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _DecoratedBoxTransitionExampleState
    extends State<DecoratedBoxTransitionExample> with TickerProviderStateMixin {
  final DecorationTween decorationTween = DecorationTween(
    begin: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      border: Border.all(style: BorderStyle.none),
      borderRadius: BorderRadius.circular(60.0),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x66666666),
          blurRadius: 10.0,
          spreadRadius: 3.0,
          offset: Offset(0, 6.0),
        ),
      ],
    ),
    end: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      border: Border.all(
        style: BorderStyle.none,
      ),
      borderRadius: BorderRadius.zero,
      // No shadow.
    ),
  );

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Center(
        child: DecoratedBoxTransition(
          position: DecorationPosition.foreground,
          decoration: decorationTween.animate(_controller),
          child: Container(
            width: 200,
            height: 200,
            padding: const EdgeInsets.all(10),
            child: const FlutterLogo(),
          ),
        ),
      ),
    );
  }
}

class AlignTransitionExample extends StatefulWidget {
  const AlignTransitionExample({Key? key}) : super(key: key);

  @override
  State<AlignTransitionExample> createState() => _AlignTransitionExampleState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _AlignTransitionExampleState extends State<AlignTransitionExample>
    with TickerProviderStateMixin {
  // Using `late final` for lazy initialization. See
  // https://dart.dev/null-safety/understanding-null-safety#lazy-initialization.
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  final tween = Tween<AlignmentGeometry>(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
  late final Animation<AlignmentGeometry> _animation = tween.animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ),
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final value = _animation.value;
      final evaluated = tween.evaluate(_controller);
      print('value: $value; tween.evaluate: $evaluated');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.red,
      child: AlignTransition(
        widthFactor: 2,
        heightFactor: 3,
        alignment: _animation,
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: ColoredBox(
            color: Colors.blueGrey,
            child: FlutterLogo(size: 150.0),
          ),
        ),
      ),
    );
  }
}

class AnimatedPaddingExample extends StatefulWidget {
  const AnimatedPaddingExample({Key? key}) : super(key: key);

  @override
  State<AnimatedPaddingExample> createState() => _AnimatedPaddingExampleState();
}

class _AnimatedPaddingExampleState extends State<AnimatedPaddingExample> {
  double padValue = 0.0;
  void _updatePadding(double value) {
    setState(() {
      padValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedPadding(
          padding: EdgeInsets.all(padValue),
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
            color: Colors.blue,
          ),
        ),
        Text('Padding: $padValue'),
        ElevatedButton(
            child: const Text('Change padding'),
            onPressed: () {
              _updatePadding(padValue == 0.0 ? 100.0 : 0.0);
            }),
      ],
    );
  }
}

class AnimatedAlignExample extends StatefulWidget {
  const AnimatedAlignExample({Key? key}) : super(key: key);

  @override
  State<AnimatedAlignExample> createState() => _AnimatedAlignExampleState();
}

class _AnimatedAlignExampleState extends State<AnimatedAlignExample> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Center(
        child: Container(
          width: 250.0,
          height: 250.0,
          color: Colors.red,
          child: AnimatedAlign(
            alignment: selected ? Alignment.topRight : Alignment.bottomLeft,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            child: const FlutterLogo(size: 50.0),
          ),
        ),
      ),
    );
  }
}

class AnimatedFractionallySizedBoxExampleApp extends StatelessWidget {
  const AnimatedFractionallySizedBoxExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar:
            AppBar(title: const Text('AnimatedFractionallySizedBox Sample')),
        body: const AnimatedFractionallySizedBoxExample(),
      ),
    );
  }
}

class AnimatedFractionallySizedBoxExample extends StatefulWidget {
  const AnimatedFractionallySizedBoxExample({Key? key}) : super(key: key);

  @override
  State<AnimatedFractionallySizedBoxExample> createState() =>
      _AnimatedFractionallySizedBoxExampleState();
}

class _AnimatedFractionallySizedBoxExampleState
    extends State<AnimatedFractionallySizedBoxExample> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: ColoredBox(
            color: Colors.red,
            child: AnimatedFractionallySizedBox(
              widthFactor: selected ? 0.25 : 0.75,
              heightFactor: selected ? 0.75 : 0.25,
              alignment: selected ? Alignment.topLeft : Alignment.bottomRight,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              child: const ColoredBox(
                color: Colors.blue,
                child: FlutterLogo(size: 75),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedSizeExample extends StatefulWidget {
  const AnimatedSizeExample({Key? key}) : super(key: key);

  @override
  State<AnimatedSizeExample> createState() => _AnimatedSizeExampleState();
}

class _AnimatedSizeExampleState extends State<AnimatedSizeExample> {
  bool _large = true;

  void _updateSize() {
    setState(() {
      _large = !_large;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _updateSize(),
      child: AnimatedSize(
        curve: Curves.easeIn,
        duration: const Duration(seconds: 1),
        reverseDuration: const Duration(seconds: 10),
        child: Container(
          width: _large ? 200.0 : 100.0,
          height: _large ? 200.0 : 100.0,
          color: Colors.red,
          child: const Center(
            child: Text(
              'Click me!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedCrossFadeExample extends StatefulWidget {
  const AnimatedCrossFadeExample({Key? key}) : super(key: key);

  @override
  State<AnimatedCrossFadeExample> createState() =>
      _AnimatedCrossFadeExampleState();
}

class _AnimatedCrossFadeExampleState extends State<AnimatedCrossFadeExample> {
  bool _first = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _first = !_first;
        });
      },
      child: AnimatedCrossFade(
        duration: const Duration(seconds: 3),
        firstChild:
            const FlutterLogo(style: FlutterLogoStyle.horizontal, size: 100.0),
        secondChild:
            const FlutterLogo(style: FlutterLogoStyle.stacked, size: 100.0),
        crossFadeState:
            _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      ),
    );
  }
}

class TweenAnimationBuilderExample extends StatefulWidget {
  const TweenAnimationBuilderExample({Key? key}) : super(key: key);

  @override
  State<TweenAnimationBuilderExample> createState() =>
      _TweenAnimationBuilderExampleState();
}

class _TweenAnimationBuilderExampleState
    extends State<TweenAnimationBuilderExample> {
  double targetValue = 24.0;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: targetValue),
      duration: const Duration(seconds: 1),
      builder: (BuildContext context, double size, Widget? child) {
        return IconButton(
          iconSize: size,
          color: Colors.blue,
          icon: child!,
          onPressed: () {
            setState(() {
              targetValue = targetValue == 24.0 ? 48.0 : 24.0;
            });
          },
        );
      },
      child: const Icon(Icons.aspect_ratio),
    );
  }
}

/// 测试 [Anination] 取值 [value] 和 [evaluate] 函数间关系
class TweenAnimationValueExample extends StatefulWidget {
  const TweenAnimationValueExample({super.key});

  @override
  State<TweenAnimationValueExample> createState() =>
      _TweenAnimationValueExampleState();
}

class _TweenAnimationValueExampleState extends State<TweenAnimationValueExample>
    with SingleTickerProviderStateMixin {
  final tween = Tween<double>(begin: 0, end: 100);
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    animation = tween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );

    animation.addListener(() {
      print(
          'value: ${animation.value}; evaluate: ${tween.evaluate(controller)}');
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: const FlutterLogo(),
    );
  }
}

class HeroAnimationRouteA extends StatelessWidget {
  const HeroAnimationRouteA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          InkWell(
            child: Hero(
              tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
              child: ClipOval(
                child: Image.asset("assets/images/logo.png", width: 50.0),
              ),
              flightShuttleBuilder: (
                BuildContext flightContext,
                Animation<double> animation,
                HeroFlightDirection flightDirection,
                BuildContext fromHeroContext,
                BuildContext toHeroContext,
              ) {
                return const FlutterLogo(); // 构建自定义的飞行中小部件
              },
              placeholderBuilder:
                  (BuildContext context, Size heroSize, Widget child) {
                return const SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(),
                );
              },
            ),
            onTap: () {
              //打开B路由
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (
                    BuildContext context,
                    animation,
                    secondaryAnimation,
                  ) {
                    return FadeTransition(
                      opacity: animation,
                      child: Scaffold(
                        appBar: AppBar(title: const Text("原图")),
                        body: const HeroAnimationRouteB(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text("点击头像"),
          )
        ],
      ),
    );
  }
}

class HeroAnimationRouteB extends StatelessWidget {
  const HeroAnimationRouteB({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
          tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
          child: Image.asset("assets/images/logo.png"),
          flightShuttleBuilder: (
            BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection flightDirection,
            BuildContext fromHeroContext,
            BuildContext toHeroContext,
          ) {
            return const FlutterLogo(); // 构建自定义的飞行中小部件
          },
          placeholderBuilder:
              (BuildContext context, Size heroSize, Widget child) {
            return SizedBox(
              width: heroSize.width,
              height: heroSize.height,
              child: const CircularProgressIndicator(),
            );
          }),
    );
  }
}
