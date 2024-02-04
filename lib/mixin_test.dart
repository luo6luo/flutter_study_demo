import 'package:flutter/material.dart';

/// 在 Dart 3.0 之后，关于 mixin 的使用
///
/// 1. mixin
/// 2. mixin class
class MixinTest extends StatefulWidget {
  const MixinTest({super.key});

  @override
  State<MixinTest> createState() => _MixinTestState();
}

class _MixinTestState extends State<MixinTest> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

mixin Mixin1 on AbstractMixinClass {}

/// 继承抽象混合类
class Cat with AbstractMixinClass {
  Cat();

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  void test1() {
    // TODO: implement test1
  }
}

/// 纯混入
///
/// 1. 可以 `on` 的类型：`mixin`、`class`、`abstract class`、`mixin class`、`abstract mixin class`
/// 2. 不可以有构造函数
/// 3. 不能使用 `extends` `with` 关键字

mixin Mixin {
  void test() {
    debugPrint('test');
  }

  /// 需要外部实现的方法
  void test1();

  /// 需要外部实现的属性
  String get name;
}

/// 混合类，既能作为 `class`，也能作为 `mixin` 使用
///
/// 1. 不能使用 `extends` `with` 关键字，因为原来 `mixin` 不能使用
/// 2. 不能使用 `on` 关键字, 因为原来 `class` 不能使用
/// 3. 不能有生成构造函数
/// 4. 所有方法必须实现，不能只定义接口
mixin class MixinClass {
  void test() {
    debugPrint('test');
  }

  /// 'test1' must have a method body because 'MixinClass' isn't abstract. (Documentation)
  /// Try making 'MixinClass' abstract, or adding a body to 'test1'.
  // void test1();

  /// 'name' must have a method body because 'MixinClass' isn't abstract. (Documentation)
  /// Try making 'MixinClass' abstract, or adding a body to 'name'.
  // String get name;
}

/// 抽象混合类，既能作为 `abstract class`，也能作为 `mixin` 使用
///
/// 1. 不能使用 `extends` `with` 关键字，因为原来 `mixin` 不能使用
/// 2. 不能使用 `on` 关键字, 因为原来 `class` 不能使用
///
/// 3. 不能实例化，如果有构造函数，必须子类调用
/// 4. 子类或者混入类，必须实现没有实现的方法
///
/// 要实现 `on` 功能，可以使用抽象混合类，实现定义方法
abstract mixin class AbstractMixinClass {
  void test() {
    debugPrint('test');
  }

  /// 需要外部实现的方法
  void test1();

  /// 需要外部实现的属性
  String get name;
}

class Class {
  void test() {
    debugPrint('test');
  }

  /// 'test1' must have a method body because 'Class' isn't abstract. (Documentation)
  /// Try making 'Class' abstract, or adding a body to 'test1'.
  // void test1();

  /// 'name' must have a method body because 'Class' isn't abstract. (Documentation)
  /// Try making 'Class' abstract, or adding a body to 'name'.
  // String get name;
}

abstract class AbstractClass {
  void test() {
    debugPrint('test');
  }

  /// 需要外部实现的方法
  void test1();

  /// 需要外部实现的属性
  String get name;
}
