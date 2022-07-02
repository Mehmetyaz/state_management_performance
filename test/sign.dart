import 'package:flutter/material.dart';
import 'package:state_management_performance/sign.dart';

import 'test_base.dart';

class SignTester extends TestBase {
  SignTester( int count) : super('sign', count);

  @override
  Widget createWidget(int count) {
    return  MaterialApp(
      home: CollectionChangesSign(count: count),
    );
  }
}
