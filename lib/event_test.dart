import 'package:flutter/material.dart';

class EventTest extends StatefulWidget {
  const EventTest({super.key});

  @override
  State<EventTest> createState() => _EventTestState();
}

class _EventTestState extends State<EventTest> {
  double _top = 0;
  double _left = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EventTest'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('拖动事件顺序测试'),
            Container(
              width: double.infinity,
              height: 400,
              color: Colors.red,
              child: Stack(
                children: [
                  Positioned(
                    top: _top,
                    left: _left,
                    // 拖拽事件正常顺序：onPanStart -> onPanDown -> onPanUpdate -> onPanEnd
                    // 如果没有拖拽，只是点击再放开：onPanDown -> onPanCancel -> onTap
                    child: GestureDetector(
                      onTap: () {
                        print('onTap');
                      },
                      onPanStart: (DragStartDetails details) {
                        // onPanStart: Offset(44.0, 22.8)，Offset(44.0, 296.3)
                        print(
                            'onPanStart: ${details.localPosition}，${details.globalPosition}');
                      },
                      onPanDown: (DragDownDetails details) {
                        // onPanDown: Offset(25.7, 22.8)，Offset(25.7, 296.3)
                        print(
                            'onPanDown: ${details.localPosition}，${details.globalPosition}');
                      },
                      onPanUpdate: (DragUpdateDetails details) {
                        print('onPanUpdate: $details');
                        setState(() {
                          // 只设置 _top，则竖直方向拖动
                          // 只设置 _left，则水平方向拖动
                          _left += details.delta.dx;
                          // _top += details.delta.dy;
                        });
                      },
                      onPanEnd: (DragEndDetails details) {
                        print('onPanEnd: $details');
                      },
                      onPanCancel: () {
                        print('onPanCancel');
                      },
                      child: Container(
                          width: 50, height: 50, color: Colors.yellow),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('缩放'),
            GestureDetector(
              onScaleStart: (ScaleStartDetails details) {
                print('onScaleStart: $details');
              },
              onScaleUpdate: (ScaleUpdateDetails details) {
                print('onScaleUpdate: $details');
              },
              onScaleEnd: (ScaleEndDetails details) {
                print('onScaleEnd: $details');
              },
              child: Container(
                width: 200,
                height: 200,
                color: Colors.blue,
                child: const Center(
                  child: Text(
                    '缩放',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
