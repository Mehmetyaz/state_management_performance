import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

import '../config.dart';

Future<void> writeSummary(String name, int index, Map data) async {
  final timeline = driver.Timeline.fromJson(data['${name}_timeline_$index']);
  final summary = driver.TimelineSummary.summarize(timeline);
  await summary.writeTimelineToFile(
    '${name}_timeline_$index',
    pretty: true,
    includeSummary: true,
  );
}

Future<void> main() async {
  return integrationDriver(
    responseDataCallback: (data) async {
      if (data != null) {
        for (var i = 0; i < config.repeatTest; i++) {
          for (var testerName in config.testers) {
            await writeSummary(testerName, i, data);
          }
        }
      }
    },
  );
}
