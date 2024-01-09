import 'package:flutter/material.dart';

class NestedScrollViewTest extends StatefulWidget {
  const NestedScrollViewTest({Key? key}) : super(key: key);

  @override
  State<NestedScrollViewTest> createState() => _NestedScrollViewTestState();
}

class _NestedScrollViewTestState extends State<NestedScrollViewTest> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _NestedTabBarViewItem());
  }
}

class _NestedScrollViewItem extends StatefulWidget {
  const _NestedScrollViewItem();

  @override
  State<_NestedScrollViewItem> createState() => _NestedScrollViewItemState();
}

class _NestedScrollViewItemState extends State<_NestedScrollViewItem> {
  late SliverOverlapAbsorberHandle handle;

  void onOverlapChanged() {
    debugPrint(
        'layoutExtent: ${handle.layoutExtent}, scrollExtent: ${handle.scrollExtent}');
  }

  @override
  void dispose() {
    handle.removeListener(onOverlapChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        handle = NestedScrollView.sliverOverlapAbsorberHandleFor(context);
        handle.removeListener(onOverlapChanged);
        handle.addListener(onOverlapChanged);
        return <Widget>[
          SliverOverlapAbsorber(
            handle: handle,
            sliver: SliverAppBar(
              pinned: true,
              // floating: true,
              // snap: true,
              expandedHeight: 200,
              forceElevated: innerBoxIsScrolled,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPJB65qQaQ4on5fdp6nJVX-f2dI8zNMZZvxyNoMr07fqWaC_Ho6OOxBdkp3SOuzV0aYqo&usqp=CAU',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ];
      },
      body: LayoutBuilder(
        builder: (ctx, constraints) => CustomScrollView(
          slivers: <Widget>[
            SliverOverlapInjector(handle: handle),
            ...List.generate(
              20,
              (index) => SliverToBoxAdapter(
                child: _ItemView(index.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NestedTabBarViewItem extends StatelessWidget {
  const _NestedTabBarViewItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _tabs = <String>['猜你喜欢', '今日特价', '发现更多'];
    // 构建 tabBar
    return DefaultTabController(
      length: _tabs.length, // tab的数量.
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: const Text('商城'),
                  // pinned: true,
                  floating: true,
                  snap: true,
                  forceElevated: innerBoxIsScrolled,
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPJB65qQaQ4on5fdp6nJVX-f2dI8zNMZZvxyNoMr07fqWaC_Ho6OOxBdkp3SOuzV0aYqo&usqp=CAU',
                      fit: BoxFit.cover,
                    ),
                  ),
                  bottom: TabBar(
                    tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: _tabs.map((String name) {
              return Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<String>(name),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      ...List.generate(
                        20,
                        (index) => SliverToBoxAdapter(
                          child: _ItemView(index.toString()),
                        ),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _CustomScrollViewItem extends StatelessWidget {
  const _CustomScrollViewItem();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          // pinned: false,
          floating: true,
          snap: true,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPJB65qQaQ4on5fdp6nJVX-f2dI8zNMZZvxyNoMr07fqWaC_Ho6OOxBdkp3SOuzV0aYqo&usqp=CAU',
              fit: BoxFit.cover,
            ),
          ),
        ),
        ...List.generate(
          20,
          (index) => SliverToBoxAdapter(
            child: _ItemView(index.toString()),
          ),
        ),
      ],
    );
  }
}

class _ItemView extends StatelessWidget {
  final String text;
  const _ItemView(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      child: Text(text),
    );
  }
}
