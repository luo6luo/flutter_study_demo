import 'package:flutter/material.dart';

class LKTest extends StatefulWidget {
  const LKTest({Key? key}) : super(key: key);

  @override
  State<LKTest> createState() => _LKTestState();
}

class _LKTestState extends State<LKTest> {
  String? value;

  @override
  void initState() {
    super.initState();

    // List<int> nums = [2, 5, 5, 11];
    // int target = 10;
    // final r = twoSum(nums, target);
    // final r = runningSum(nums);
    // final r = numberOfSteps(14);

    final list = [
      [1, 2, 3],
      [3, 2, 1]
    ];
    final r = maximumWealth(list);

    debugPrint(r.toString());
  }

  /// 1. 两数之和
  List<int> twoSum(List<int> nums, int target) {
    // 只有2个数
    if (nums.length == 2) return [0, 1];

    // 1、升序排列
    final l = List.from(nums);
    nums.sort((l, r) => l.compareTo(r));

    // 2、找到在nums中，aTarget平均数所在下标大概位置tagIndex
    double aTarget = target / 2;
    int tagIndex = 0;
    int middleNum = nums[nums.length ~/ 2]; // 数组中间的数值
    if (middleNum.toDouble() != aTarget) {
      int i = 0;
      int length = nums.length;
      if (middleNum < aTarget) {
        i = nums.length ~/ 2; // 如果aTarget比数组中间数小，说明aTarget在list偏前
      } else if (middleNum > aTarget) {
        length -= (nums.length - nums.length ~/ 2); // 同理反之
      }

      for (int j = i + 1; j < length - 1; j++) {
        if (middleNum >= nums[j - 1] && middleNum < nums[j + 1]) {
          tagIndex = j;
          break;
        }
      }
    } else {
      // aTarget刚好在中间
      tagIndex = nums.length ~/ 2;
    }

    // 3、根据tagIndex，将 一前 + 一后 = Target
    for (int k = 0; k <= tagIndex; k++) {
      for (int m = tagIndex + 1; m < nums.length; m++) {
        if (nums[k] + nums[m] == target) {
          final s = l.indexOf(nums[k]);
          final b = l.lastIndexOf(nums[m]);
          return [s, b];
        }
      }
    }

    return [0, 0];
  }

  /// 1480. 一维数组的动态和
  List<int> runningSum(List<int> nums) {
    if (nums.length <= 1) return nums;

    List<int> result = [];
    // 方法一
    // nums.fold<int>(0, (previousValue, element) {
    //   final sum = previousValue + element;
    //   result.add(sum);
    //   return sum;
    // });

    // 方法二，执行时间少于方法一
    int sum = 0;
    for (var element in nums) {
      sum += element;
      result.add(sum);
    }

    return result;
  }

  /// 1342. 将数字变成 0 的操作次数
  int numberOfSteps(int num) {
    if (num == 0) return 0;

    int stepNum = 0;
    int temp = num;
    while (temp != 0) {
      if (temp.isEven) {
        temp = temp ~/ 2;
      } else {
        temp = temp - 1;
      }
      stepNum++;
    }

    return stepNum;
  }

  /// 1672. 最富有客户的资产总量
  int maximumWealth(List<List<int>> accounts) {
    int max = 0;
    for (var element in accounts) {
      final sum = element.reduce((value, element) => value + element);
      if (sum > max) max = sum;
    }

    return max;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LeetCode')),
      body: const Placeholder(),
    );
  }
}
