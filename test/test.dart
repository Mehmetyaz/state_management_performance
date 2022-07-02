import 'package:flutter_test/flutter_test.dart';

import 'default.dart';
import 'getx.dart';
import 'riverpod.dart';
import 'sign.dart';

void main() {
  testWidgets("test_base_test_yaz", (widgetTester) async {
    var widget = SignTester(4);
    await widgetTester.pumpWidget(widget.createWidget(4));

    await widget.ensureWidgetsBuilt(find, widgetTester);

    for (var i = 0; i < 400; i++) {
      await widget.randomOperation(widgetTester);

      await widget.pump(widgetTester);

      widget.expectValues(find, widgetTester);
    }

    return;
  });


  testWidgets("test_base_test_riverpod", (widgetTester) async {
    var widget = RiverpodTester(4);
    await widgetTester.pumpWidget(widget.createWidget(4));

    await widget.ensureWidgetsBuilt(find, widgetTester);

    for (var i = 0; i < 400; i++) {
      await widget.randomOperation(widgetTester);

      await widget.pump(widgetTester);

      widget.expectValues(find, widgetTester);
    }

    return;
  });


  testWidgets("test_base_test_default", (widgetTester) async {
    var widget = DefaultTester(4);
    await widgetTester.pumpWidget(widget.createWidget(4));

    await widget.ensureWidgetsBuilt(find, widgetTester);

    for (var i = 0; i < 400; i++) {
      await widget.randomOperation(widgetTester);

      await widget.pump(widgetTester);

      widget.expectValues(find, widgetTester);
    }

    return;
  });

  testWidgets("test_base_test_getx", (widgetTester) async {
    var widget = GetxTester(4);
    await widgetTester.pumpWidget(widget.createWidget(4));

    await widget.ensureWidgetsBuilt(find, widgetTester);

    for (var i = 0; i < 400; i++) {
      await widget.randomOperation(widgetTester);

      await widget.pump(widgetTester);

      widget.expectValues(find, widgetTester);
    }

    return;
  });

}
