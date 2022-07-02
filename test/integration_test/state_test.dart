import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../config.dart';
import '../default.dart';
import '../getx.dart';
import '../riverpod.dart';
import '../sign.dart';
import '../test_base.dart';

void main() async {
  var binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  var testers = config.testers.asMap().map((key, value) {
    TestBase Function(int count) builder;
    switch (value) {
      case 'riverpod':
        builder = RiverpodTester.new;
        break;
      case 'sign':
        builder = SignTester.new;
        break;
      case 'getx':
        builder = GetxTester.new;
        break;
      case 'default':
        builder = DefaultTester.new;
        break;
      default:
        throw Exception('Unknown tester: $value');
    }
    return MapEntry(value, builder);
  });

  for (var i = 0; i < config.repeatTest; i++) {
    var list = testers.keys.toList()..shuffle();

    for (var name in list) {
      var base = testers[name]!.call(config.counterCount);
      testWidgets("performance_test_${base.name}_$i", (widgetTester) async {
        await binding.traceAction(() async {
          await widgetTester.pumpWidget(base.createWidget(config.counterCount));

          await base.ensureWidgetsBuilt(find, widgetTester);

          for (var i2 = 0; i2 < config.repeatState; i2++) {
            await base.randomOperation(widgetTester);

            await base.pump(widgetTester);

            base.expectValues(find, widgetTester);
          }

          return;
        }, reportKey: '${base.name}_timeline_$i');
      });
    }
  }
}
