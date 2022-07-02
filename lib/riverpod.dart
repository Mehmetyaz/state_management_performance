import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class CollectionChangesRiverpod extends StatefulWidget {
  ///
  const CollectionChangesRiverpod({Key? key, required this.count})
      : super(key: key);

  final int count;

  @override
  State<CollectionChangesRiverpod> createState() =>
      _CollectionChangesRiverpodState();
}

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;

  void decrement() => state--;
}

class _CollectionChangesRiverpodState extends State<CollectionChangesRiverpod> {
  ///
  late final List<StateNotifierProvider<Counter, int>> list = List.generate(
      widget.count,
      (index) => StateNotifierProvider<Counter, int>((ref) => Counter()));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Consumer(
            builder: (_, watch, __) =>
                Text('SUM: ${sum(watch)}', key: const Key('sum_riverpod')),
          ),
        ),
        body: ListView.separated(
          itemCount: list.length,
          cacheExtent: 2000,
          itemBuilder: (c, i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Consumer(builder: (_, ref, __) {
              return CounterWidgetProvider(
                counter: ref.read(list[i].originProvider),
                index: i,
                counterProvider: list[i],
              );
            }),
          ),
          separatorBuilder: (context, index) => const Divider(),
        ),
      );

  ///
  int sum(WidgetRef ref) {
    var i = 0;
    for (var o in list) {
      i += ref.watch(o);
    }
    return i;
  }
}

///
class CounterWidgetProvider extends ConsumerWidget {
  ///
  const CounterWidgetProvider(
      {Key? key,
      required this.counter,
      required this.index,
      required this.counterProvider})
      : super(key: key);

  ///
  final Counter counter;
  final StateNotifierProvider<Counter, int> counterProvider;

  ///
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
        children: [
          Container(
            width: 200,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: Text('Index Of $index'),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    key: Key('increment_riverpod_$index'),
                    onTap: () {
                      counter.increment();
                    },
                    child: const Text('Counter Increment')),
                Consumer(builder: (_, ref, __) {
                  var c = ref.watch(counterProvider).toString();
                  return Text(
                    'value_riverpod_${index}_$c',
                    key: Key('value_riverpod_$index'),
                  );
                }),
                GestureDetector(
                    key: Key('decrement_riverpod_$index'),
                    onTap: () {
                      counter.decrement();
                    },
                    child: const Text('Counter Decrement'))
              ],
            ),
          ),
        ],
      );
}
