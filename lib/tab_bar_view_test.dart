import 'package:flutter/material.dart';

class TabBarViewTest extends StatefulWidget {
  const TabBarViewTest({super.key});

  @override
  State<TabBarViewTest> createState() => _TabBarViewTestState();
}

class _TabBarViewTestState extends State<TabBarViewTest> {
  @override
  Widget build(BuildContext context) {
    final tabs = <Tab>[
      const Tab(icon: Icon(Icons.access_time_filled)),
      const Tab(icon: Icon(Icons.ac_unit)),
      const Tab(icon: Icon(Icons.access_alarms_rounded)),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBarView Test'),
          bottom: TabBar(tabs: tabs),
        ),
        body: TabBarView(
          children: tabs.map((e) => _TabBarViewPage(e)).toList(),
        ),
      ),
    );
  }
}

class _TabBarViewPage extends StatefulWidget {
  const _TabBarViewPage(this.child);
  final Widget child;

  @override
  State<_TabBarViewPage> createState() => _TabBarViewPageState();
}

class _TabBarViewPageState extends State<_TabBarViewPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(child: widget.child);
  }

  @override
  bool get wantKeepAlive => true;
}
