import 'package:flutter/material.dart';
import 'package:state_management_performance/getx.dart';

import 'test_base.dart';

class GetxTester extends TestBase {
  GetxTester(int count) : super('getx', count);

  @override
  Widget createWidget(int count) {
    return MaterialApp(
      home: CollectionChangesGetx(count: count),
    );
  }
}
