import 'package:flutter/material.dart';

class PageViewTest extends StatefulWidget {
  const PageViewTest({super.key});

  @override
  State<PageViewTest> createState() => _PageViewTestState();
}

class _PageViewTestState extends State<PageViewTest> {
  @override
  Widget build(BuildContext context) {
    final list = List.generate(5, (index) => index.toString());
    return Scaffold(
      appBar: AppBar(title: const Text('PageView Test')),
      body: PageView(
        children: list.map((e) => KeepAliveWrapper(_PageTest(e))).toList(),
      ),
    );
  }
}

class _PageTest extends StatefulWidget {
  const _PageTest(this.text);
  final String text;

  @override
  State<_PageTest> createState() => _PageTestState();
}

class _PageTestState extends State<_PageTest> {
  @override
  void initState() {
    super.initState();
    debugPrint('_PageTestState-initState: ${widget.text}');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('_PageTestState-build: ${widget.text}');
    return Center(
        child: Text(
      widget.text,
      style: const TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
      ),
    ));
  }
}

class KeepAliveWrapper extends StatefulWidget {
  const KeepAliveWrapper(
    this.child, {
    super.key,
    this.keepAlive = true,
  });

  final Widget child;
  final bool keepAlive;

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  void didUpdateWidget(covariant KeepAliveWrapper oldWidget) {
    if (oldWidget.keepAlive != widget.keepAlive) updateKeepAlive();
    super.didUpdateWidget(oldWidget);
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
