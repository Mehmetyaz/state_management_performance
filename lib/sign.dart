import 'package:flutter/material.dart';

import 'package:sign_flutter/sign_flutter.dart';

///
class CollectionChangesSign extends StatefulWidget {
  ///
  const CollectionChangesSign({Key? key, required this.count}) : super(key: key);

  final int count;

  @override
  State<CollectionChangesSign> createState() => _CollectionChangesSignState();
}

class _CollectionChangesSignState extends State<CollectionChangesSign> {
  ///
  late final List<Signal<int>> list =
      List.generate(widget.count, (index) => 0).signals;

  late final MultiSignal allNotifier = list.multiSignal;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: allNotifier
              .builder((value) => Text('SUM: $sum', key: const Key('sum_sign'))),
        ),
        body: ListView.separated(
          itemCount: list.length,
          cacheExtent: 2000,
          itemBuilder: (c, i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: CounterWidgetSign(counter: list[i], index: i),
          ),
          separatorBuilder: (context, index) => const Divider(),
        ),
      );

  ///
  int get sum {
    var i = 0;
    for (var o in list) {
      i += o.value;
    }
    return i;
  }
}

///
class CounterWidgetSign extends StatelessWidget {
  ///
  const CounterWidgetSign({Key? key, required this.counter, required this.index})
      : super(key: key);

  ///
  final Signal<int> counter;

  ///
  final int index;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 200,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: Text(
              'Index Of $index',
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    key: Key('increment_sign_$index'),
                    onTap: () {
                      counter.value++;
                    },
                    child: const Text('Counter Increment')),
                counter.builder((value) => Text(
                      'value_sign_${index}_$value',
                      key: Key('value_sign_$index'),
                    )),
                GestureDetector(
                    key: Key('decrement_sign_$index'),
                    onTap: () {
                      counter.value--;
                    },
                    child: const Text('Counter Decrement'))
              ],
            ),
          ),
        ],
      );
}
