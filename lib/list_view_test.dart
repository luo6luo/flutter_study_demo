import 'package:flutter/material.dart';

class ListViewTest extends StatefulWidget {
  const ListViewTest({Key? key}) : super(key: key);

  @override
  State<ListViewTest> createState() => _ListViewTestState();
}

class _ListViewTestState extends State<ListViewTest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView Test')),
      body: ListView.builder(
        addAutomaticKeepAlives: false,
        itemExtent: 200,
        cacheExtent: 210,
        itemCount: 30,
        itemBuilder: (_, index) => _ListItem(index.toString()),
      ),
    );
  }
}

class _ListItem extends StatefulWidget {
  const _ListItem(this.data);
  final String data;

  @override
  State<_ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<_ListItem> {
  @override
  void initState() {
    super.initState();
    debugPrint('_ListItem-initState: ${widget.data}');
  }

  @override
  void dispose() {
    debugPrint('_ListItem-dispose: ${widget.data}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      color: Colors.amberAccent,
      child: Text(widget.data),
    );
  }
}
