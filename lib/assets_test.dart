import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssetsTest extends StatefulWidget {
  const AssetsTest({Key? key}) : super(key: key);

  @override
  State<AssetsTest> createState() => _AssetsTestState();
}

class _AssetsTestState extends State<AssetsTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AssetsTest')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: _onRootBundlePressed,
              child: const Text('rootBundle'),
            ),
            TextButton(
              onPressed: _onDefaultAssetBundlePressed,
              child: const Text('defaultAssetBundle'),
            ),
          ],
        ),
      ),
    );
  }

  void _onRootBundlePressed() async {
    // rootBundle 全局静态获取资源
    final rb = await rootBundle.loadString('assets/asset.json');
    final json = jsonDecode(rb);
    print('name: ${json['name']}');
  }

  void _onDefaultAssetBundlePressed() async {
    // DefaultAssetBundle 通过 context 获取就近的，没找到就返回 [rootBundle]
    final ab =
        await DefaultAssetBundle.of(context).loadString('assets/asset.json');
    final json = jsonDecode(ab);
    print('description: ${json['description']}');
  }
}
