import 'package:flutter/material.dart';

class DialogTest extends StatefulWidget {
  const DialogTest({super.key});

  @override
  State<DialogTest> createState() => _DialogTestState();
}

class _DialogTestState extends State<DialogTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialog Test')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _showDialog(context),
              child: const Text('显示 Dialog'),
            ),
            ElevatedButton(
              onPressed: () => _showCustomDialog(context),
              child: const Text('显示自定义 Dialog'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) async {
    final r = await showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.amberAccent,
        elevation: 0.5,
        shadowColor: Colors.pink,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        alignment: Alignment.center,
        child: ListView.builder(
          itemBuilder: (_, index) => ListTile(
            title: Text('item $index'),
            onTap: () => Navigator.pop(context, index),
          ),
          itemCount: 20,
        ),
      ),
    );
    debugPrint('Dialog Result = $r');
  }

  void _showCustomDialog(BuildContext context) async {
    final r = await showGeneralDialog(
      context: context,
      pageBuilder: (_, a1, a2) {
        return SafeArea(
          child: AlertDialog(
            title: const Text('提示'),
            content: const Text('内容'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, '取消'),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, '确定'),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (_, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: a1,
            curve: Curves.fastOutSlowIn,
          ),
          child: child,
        );
      },
    );
    debugPrint('Custom Dialog Result = $r');
  }
}
