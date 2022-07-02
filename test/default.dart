import 'package:flutter/material.dart';
import 'package:state_management_performance/defaults.dart';

import 'test_base.dart';

class DefaultTester extends TestBase {
  DefaultTester(int count) : super('default', count);

  @override
  Widget createWidget(int count) {
    return MaterialApp(
      home: CollectionChangesDefault(count: count),
    );
  }
}
