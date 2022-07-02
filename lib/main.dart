import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_performance/riverpod.dart';
import 'package:state_management_performance/sign.dart';

import 'getx.dart';

void main() {
  runApp(const ProviderScope(child: VersusApp()));
}

class VersusApp extends StatelessWidget {
  const VersusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Versus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Builder(builder: (context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CollectionChangesRiverpod(
                                    count: 4,
                                  )));
                    },
                    child: const Text("Riverpod")),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CollectionChangesSign(
                                    count: 4,
                                  )));
                    },
                    child: const Text("Sign")),

                const SizedBox(
                  height: 20,
                ),

                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CollectionChangesGetx(
                                    count: 4,
                                  )));
                    },
                    child: const Text("Getx"))
              ],
            );
          }),
        ),
      ),
    );
  }
}
