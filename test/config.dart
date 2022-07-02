TestConfig config = TestConfig(
    workingDir: "C:\\projects\\state_management_performance",
    device: "windows",
    repeatTest: 4,
    repeatState: 20,
    counterCount: 4,
    testers: [
      "riverpod",
      "sign",
      "default",
      "getx",
    ]);

class TestConfig {
  TestConfig(
      {required this.device,
      required this.repeatTest,
      required this.repeatState,
      required this.testers,
      required this.counterCount,
      required this.workingDir});

  Map<String, dynamic> toJson() {
    return {
      "device": device,
      "repeatTest": repeatTest,
      "repeatState": repeatState,
      "counter_count": counterCount,
      "time": DateTime.now().toString(),
      "testers": testers,
    };
  }

  List<String> testers;

  String device;
  String workingDir;

  int repeatTest;
  int repeatState;
  int counterCount;
}
