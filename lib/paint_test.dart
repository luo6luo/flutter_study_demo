import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class PaintTest extends StatefulWidget {
  const PaintTest({super.key});

  @override
  State<PaintTest> createState() => _PaintTestState();
}

class _PaintTestState extends State<PaintTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PaintTest')),
      body: const Center(
        child: RepaintBoundary(
          child: _CircleProgressWidget(
            strokeWidth: 10,
            color: Colors.red,
            value: 0.5,
            duration: Duration(seconds: 1),
          ),
        ),
      ),
    );
  }
}

/// 画五子棋
class _PaintGoBang extends StatefulWidget {
  const _PaintGoBang();

  @override
  State<_PaintGoBang> createState() => _PaintGoBangState();
}

class _PaintGoBangState extends State<_PaintGoBang> {
  /// 棋子
  final List<_Piece> _pieces = [];
  bool _isWhite = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: _CheckerboardPainter(),
                size: const Size(300, 300),
              ),
              CustomPaint(
                painter: _PiecePainter(_pieces),
                size: const Size(300, 300),
              ),
            ],
          ),
          const SizedBox(height: 20),
          RepaintBoundary(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  double dx = 30 * Random().nextInt(8) + 30;
                  double dy = 30 * Random().nextInt(8) + 30;
                  final piece = _Piece(_isWhite, Offset(dx, dy));
                  _pieces.add(piece);
                  _isWhite = !_isWhite;
                });
              },
              child: const Text('下子'),
            ),
          ),
        ],
      ),
    );
  }
}

/// 棋盘
class _CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('_CheckerboardPainter paint');
    final rect = Offset.zero & size;
    final paintBackground = Paint()
      ..color = Colors.amber[200]!
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, paintBackground);

    final paintLine = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    for (int i = 0; i <= 10; i++) {
      canvas.drawLine(
        Offset(rect.left, rect.top + rect.height / 10 * i),
        Offset(rect.right, rect.top + rect.height / 10 * i),
        paintLine,
      );
    }
    for (int i = 0; i <= 10; i++) {
      canvas.drawLine(
        Offset(rect.left + rect.width / 10 * i, rect.top),
        Offset(rect.left + rect.width / 10 * i, rect.bottom),
        paintLine,
      );
    }
  }

  /// 不需要重绘
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 棋子
class _PiecePainter extends CustomPainter {
  const _PiecePainter(this.pieces);

  /// 棋子位置
  final List<_Piece> pieces;

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('_PiecePainter paint');
    final rect = Offset.zero & size;
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final blackPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final radius = rect.width / 20 - 4;
    for (final piece in pieces) {
      canvas.drawCircle(
        piece.position,
        radius,
        piece.isWhite ? whitePaint : blackPaint,
      );
    }
  }

  /// 不需要重绘
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Piece {
  final bool isWhite;
  final Offset position;
  const _Piece(this.isWhite, this.position);
}

/// 自定义圆环进度
class _CircleProgressWidget extends LeafRenderObjectWidget {
  final double strokeWidth;
  final Color color;
  final double value;
  final Duration duration;
  const _CircleProgressWidget({
    this.strokeWidth = 2.0,
    this.color = Colors.blue,
    this.value = 0.0,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCircleProgressObject(
      strokeWidth: strokeWidth,
      color: color,
      value: value,
      duration: duration,
    )..animationStatus = AnimationStatus.forward;
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderCircleProgressObject renderObject,
  ) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..strokeWidth = strokeWidth
      ..color = color
      ..value = value
      ..duration = duration;
  }
}

class _RenderCircleProgressObject extends RenderBox {
  double strokeWidth;
  Color color;
  double value;
  Duration duration;

  _RenderCircleProgressObject({
    this.strokeWidth = 2.0,
    this.color = Colors.blue,
    this.value = 0.0,
    this.duration = const Duration(milliseconds: 500),
  });

  /// 当前动画状态
  AnimationStatus _animationStatus = AnimationStatus.completed;
  set animationStatus(AnimationStatus status) {
    if (status == _animationStatus) return;
    _animationStatus = status;
  }

  /// 当前动画值
  double _animationValue = 0.0;

  @override
  void paint(PaintingContext context, Offset offset) {
    debugPrint('paint');
    _paintCircleProgress(context, offset);
    _scheduleAnimation(context, offset);

    super.paint(context, offset);
  }

  /// 画圆环
  void _paintCircleProgress(PaintingContext context, Offset offset) {
    final rect = offset & size;
    final sweepAngle = 2 * pi * _animationValue;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    context.canvas.drawArc(rect, 0.0, sweepAngle, false, paint);
  }

  /// 上次动画的时间戳
  Duration? _lastTimestamp;

  /// 执行动画
  void _scheduleAnimation(PaintingContext context, Offset offset) {
    if (_animationStatus == AnimationStatus.completed ||
        _animationStatus == AnimationStatus.dismissed) {
      _lastTimestamp = null;
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (_lastTimestamp != null) {
        final delta =
            (timeStamp.inMilliseconds - _lastTimestamp!.inMilliseconds) /
                duration.inMilliseconds;
        _animationValue += delta;
        _animationValue = _animationValue.clamp(0.0, value);
        debugPrint(
            '${timeStamp.inMilliseconds}, ${_lastTimestamp!.inMilliseconds}, $_animationValue');

        if (_animationValue == value) {
          _animationStatus = AnimationStatus.completed;
        }
      }

      markNeedsPaint();
      _lastTimestamp = timeStamp;
    });
  }

  @override
  void performLayout() {
    // 父组件规定了大小，则用父组件的，否则默认为(100, 100)
    size = constraints.isTight
        ? constraints.constrain(Size.infinite)
        : const Size(100, 100);
  }
}
