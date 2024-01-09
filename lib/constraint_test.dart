import 'package:flutter/material.dart';

class ConstraintTest extends StatefulWidget {
  const ConstraintTest({Key? key}) : super(key: key);

  @override
  State<ConstraintTest> createState() => _ConstraintTestState();
}

class _ConstraintTestState extends State<ConstraintTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConstraintTest'),
        actions: const [
          Center(
            child: CircularProgressIndicator(color: Colors.white, value: 1),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildConstrainedBox(),
            const SizedBox(height: 20),
            _buildUnconstrainedBox(),
            const SizedBox(height: 20),
            _buildFractionallySizedBox(),
            const SizedBox(height: 20),
            _buildMulColumn(),
            const SizedBox(height: 20),
            _buildMulRow(),
            const SizedBox(height: 20),
            _buildFlexs(),
            const SizedBox(height: 20),
            const SizedBox(height: 100, child: FlowMenu()),
            const SizedBox(height: 20),
            _buildRow(),
            const SizedBox(height: 20),
            _buildAlign(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  /// 查看多个约束的叠加效果
  Widget _buildConstrainedBox() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 50,
        maxHeight: 200,
        minWidth: 50,
        maxWidth: 200,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 100,
          maxHeight: 300,
          minWidth: 100,
          maxWidth: 300,
        ),

        // Container 实际约束：BoxConstraints(100.0<=w<=200.0, 100.0<=h<=200.0)
        child: Container(
          // width: double.infinity,
          // height: double.infinity,
          alignment: Alignment.center,
          color: Colors.red,
          child: const Text('Constraints'),
        ),
      ),
    );
  }

  /// UnconstrainedBox
  Widget _buildUnconstrainedBox() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 60.0, minHeight: 100.0), //父
      child: UnconstrainedBox(
        // “去除”父级限制
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(minWidth: 20.0, minHeight: 20.0), //子
          child: Container(
            color: Colors.red,
            width: 10,
            height: 30,
          ),
        ),
      ),
    );
  }

  /// FractionallySizedBox
  Widget _buildFractionallySizedBox() {
    return Container(
      color: Colors.red,
      width: double.infinity,
      height: 200,
      child: FractionallySizedBox(
        widthFactor: 0.5,
        heightFactor: 0.5,
        alignment: Alignment.center,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
              width: 4,
            ),
          ),
        ),
      ),
    );
  }

  /// 多个Column嵌套
  Widget _buildMulColumn() {
    return Container(
      height: 300,
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max, //有效，外层Colum高度为整个屏幕
          children: <Widget>[
            ColoredBox(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max, //无效，内层Colum高度为实际高度
                children: const [
                  Text("hello world "),
                  Text("I am Jack "),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 多个Row嵌套
  Widget _buildMulRow() {
    return Container(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max, //有效，外层Row宽度为整个屏幕
          children: <Widget>[
            ColoredBox(
              color: Colors.yellow,
              child: Row(
                mainAxisSize: MainAxisSize.max, //无效，内层Row宽度为实际高度
                children: const [
                  Text("hello world "),
                  Text("I am Jack "),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Flex
  Widget _buildFlexs() {
    return SizedBox(
      height: 200,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(flex: 2, child: Container(height: 30, color: Colors.red)),
          const Spacer(flex: 1),
          Expanded(flex: 1, child: Container(height: 30, color: Colors.grey)),
        ],
      ),
    );
  }

  /// Row
  Widget _buildRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      verticalDirection: VerticalDirection.up,
      children: const [
        Text('test', style: TextStyle(fontSize: 30)),
        Text('test'),
        Text('test'),
      ],
    );
  }

  /// Align
  Widget _buildAlign() {
    return const ColoredBox(
      color: Colors.red,
      child: Align(
        widthFactor: 2,
        heightFactor: 2,
        alignment: Alignment(2, 0.0),
        child: FlutterLogo(
          size: 60,
        ),
      ),
    );
  }
}

class FlowMenu extends StatefulWidget {
  const FlowMenu({Key? key}) : super(key: key);

  @override
  State<FlowMenu> createState() => _FlowMenuState();
}

class _FlowMenuState extends State<FlowMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController menuAnimation;
  IconData lastTapped = Icons.home;
  final List<IconData> menuItems = <IconData>[
    Icons.home,
    Icons.new_releases,
    Icons.notifications,
    Icons.settings,
    Icons.menu,
  ];

  void _updateMenu(IconData icon) {
    if (icon != Icons.menu) {
      setState(() => lastTapped = icon);
    }
  }

  @override
  void initState() {
    super.initState();
    menuAnimation = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  Widget flowMenuItem(IconData icon) {
    final double buttonDiameter =
        MediaQuery.of(context).size.width / menuItems.length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RawMaterialButton(
        fillColor: lastTapped == icon ? Colors.amber[700] : Colors.blue,
        splashColor: Colors.amber[100],
        shape: const CircleBorder(),
        constraints: BoxConstraints.tight(Size(buttonDiameter, buttonDiameter)),
        onPressed: () {
          _updateMenu(icon);
          menuAnimation.status == AnimationStatus.completed
              ? menuAnimation.reverse()
              : menuAnimation.forward();
        },
        child: Icon(
          icon,
          color: Colors.white,
          size: 45.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowMenuDelegate(menuAnimation: menuAnimation),
      children:
          menuItems.map<Widget>((IconData icon) => flowMenuItem(icon)).toList(),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({required this.menuAnimation})
      : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double dx = 0.0;
    for (int i = 0; i < context.childCount; ++i) {
      dx = context.getChildSize(i)!.width * i;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          dx * menuAnimation.value,
          0,
          0,
        ),
      );
    }
  }
}
