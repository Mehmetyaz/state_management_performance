import 'dart:convert';
import 'dart:io';

import 'test/config.dart';

Future<void> main(List<String> args) async {
  var device = config.device == "" ? null : config.device;

  var additionalArg = device != null && device == "android" ? "--no-dds" : null;

  if (device == "android") {
    device = null;
  }

  if (args.contains("--triple")) {
    for (var i = 0; i < 3; i++) {
      await run(
          device, additionalArg, List<String>.from(args)..remove("--triple"));
    }
  } else {
    await run(device, additionalArg, args);
  }
}

Future<void> run(
    String? device, String? additionalArg, List<String> args) async {
  var process = await Process.start(
      'flutter drive'
      ' --driver=test/test_driver/driver.dart'
      ' --target=test/integration_test/state_test.dart'
      ' --profile',
      [
        if (device != null) ...['-d', device],
        if (additionalArg != null) additionalArg,
        ...args
      ],
      workingDirectory: config.workingDir,
      includeParentEnvironment: true,
      runInShell: true);

  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);

  var code = await process.exitCode;

  if (code == 0) {
    await mergeSummaries(additionalArg, args);
  }
}

Future<void> mergeSummaries(String? additionalArgs, List<String> args) async {
  Map<String, List<Map<String, dynamic>>> summaries = {
    ...config.testers.asMap().map((key, value) => MapEntry(value, [])),
  };

  for (var i = 0; i < config.repeatTest; i++) {
    for (var name in summaries.keys) {
      var file = File('${config.workingDir}'
          '/build'
          '/${name}_timeline_$i.timeline_summary.json');
      if (file.existsSync()) {
        var data = json.decode(await file.readAsString());
        summaries[name]!.add(data);
      }
    }
  }

  Map<String, dynamic> percents = {};

  Map<String, Map<String, double>> results = {
    ...config.testers
        .asMap()
        .map((key, value) => MapEntry(value, <String, double>{})),
  };

  addAverages(summaries, results, percents, {
    'average_frame_build_time_millis': true,
    '90th_percentile_frame_build_time_millis': true,
    '99th_percentile_frame_build_time_millis': true,
    'worst_frame_build_time_millis': true,
    'new_gen_gc_count': true,
    'total_ui_gc_time': true
  });

  var averages = {
    'config': config.toJson()
      ..addAll({
        "args": [additionalArgs, ...args]
      }),
    ...results,
    'percent': percents,
  };

  var dir = Directory('${config.workingDir}/results');

  if (!dir.existsSync()) {
    dir.createSync();
  }

  File file;

  var i = 0;

  while (true) {
    file = File('${config.workingDir}/results/time_lime_averages_$i.json');

    if (file.existsSync()) {
      i++;
    } else {
      file.createSync();
      break;
    }
  }
  file.writeAsStringSync(json.encode(averages));
  stdout.writeln("Results saved to ${file.path}");
}

void addAverages(
  Map<String, List<Map<String, dynamic>>> summaries,
  Map<String, Map<String, double>> results,
  Map<String, dynamic> percents,
  Map<String, bool> fields,
) {
  for (var field in fields.keys) {
    Map<String, double> values = <String, double>{
      ...summaries.keys.toList().asMap().map((k, e) => MapEntry(e, 0.0))
    };

    for (var name in values.keys) {
      for (var i = 0; i < values.length; i++) {
        values[name] = values[name]! + summaries[name]![i][field]!;
      }
    }

    var en = values.entries.first;

    var minC = en.value;
    var minName = en.key;

    for (var name in values.keys) {
      if (values[name]! < minC) {
        minC = values[name]!;
        minName = name;
      }
    }

    for (var name in values.keys) {
      results[name]![field] =
          ((values[name]! / summaries[name]!.length) * 10000).floor() / 10000;
      percents[field] ??= {};

      if (name == minName) {
        percents[field]![name] = "% 0.0";
      }

      var m = (minC / (values[name]! - minC));

      if (m == 0) {
        percents[field]![name] = "% 0.0";
      } else {
        var p = 100 / m;
        percents[field]![name] = "% ${(p * 10000).floor() / 10000}";
      }
    }
  }
}
