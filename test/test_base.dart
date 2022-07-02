import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class TestBase {
  TestBase(this.name, this.count);

  Widget createWidget(int count);

  String name;

  int count;


  late final List<int> _values = List.generate(count, (index) => 0);

  int get sum {
    var i = 0;
    for (var o in _values) {
      i += o;
    }
    return i;
  }

  bool _initialized = false;

  Future<void> pump(WidgetTester tester) async {
    if (!_initialized) {
      _initialized = true;
      await tester.pumpWidget(createWidget(count));
    } else {
      await tester.pump();
    }
    return;
  }

  Future<void> ensureWidgetsBuilt(CommonFinders find,WidgetTester tester) async {
    var ensures = <Future<void>>[];

    for (var i = 0; i < (count); i++) {
      ensures.add(tester.ensureVisible(find
          .text(('value_${name}_${i}_${_values[i]}'), skipOffstage: false)));
      ensures
          .add(tester.ensureVisible(find.byKey(Key('increment_${name}_$i'))));
      ensures
          .add(tester.ensureVisible(find.byKey(Key('decrement_${name}_$i'))));
    }

    await Future.wait(ensures);

    await tester.ensureVisible(find.byKey(Key('sum_$name')));
  }

  Future<void> randomOperation(WidgetTester tester) async {
    var random = Random();
    var index = random.nextInt(count);
    if (random.nextBool()) {
      await increment(index,tester);
      _values[index]++;
    } else {
      await decrement(index,tester);
      _values[index]--;
    }
  }

  void expectValues(CommonFinders find,WidgetTester tester) {
    for (var i = 0; i < count; i++) {
      expect(find.byKey(Key("value_${name}_$i")), findsOneWidget);
    }
    var sum = findSum(find,tester);
    expect(sum, "SUM: ${this.sum}");
  }

  Future<void> increment(int index,WidgetTester tester) async {
    return await tester.tap(find.byKey(Key("increment_${name}_$index")));
  }

  Future<void> decrement(int index,WidgetTester tester) async {
    return await tester.tap(find.byKey(Key("decrement_${name}_$index")));
  }

  String findSum(CommonFinders find,WidgetTester tester) {
    return (tester.widget(find.byKey(Key("sum_$name"))) as Text).data!;
  }
}
