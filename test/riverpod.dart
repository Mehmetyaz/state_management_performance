import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_performance/riverpod.dart';

import 'test_base.dart';

class RiverpodTester extends TestBase {
  RiverpodTester(int count) : super('riverpod', count);

  @override
  Widget createWidget(int count) {
    return ProviderScope(
      child: MaterialApp(
        home: CollectionChangesRiverpod(count: count),
      ),
    );
  }
}
