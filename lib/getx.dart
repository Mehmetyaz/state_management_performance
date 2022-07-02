import 'package:flutter/material.dart';
import 'package:get/get.dart';

///
class CollectionChangesGetx extends StatefulWidget {
  ///
  const CollectionChangesGetx({Key? key, required this.count})
      : super(key: key);

  final int count;

  @override
  State<CollectionChangesGetx> createState() => _CollectionChangesGetxState();
}

class _CollectionChangesGetxState extends State<CollectionChangesGetx> {
  ///
  late final RxList<RxInt> list =
      RxList<RxInt>(List.generate(widget.count, (index) => 0.obs));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Obx(() => Text('SUM: $sum', key: const Key('sum_getx'))),
        ),
        body: ListView.separated(
          itemCount: list.length,
          cacheExtent: 2000,
          itemBuilder: (c, i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: CounterWidgetGetx(counter: list[i], index: i),
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
class CounterWidgetGetx extends StatelessWidget {
  ///
  const CounterWidgetGetx(
      {Key? key, required this.counter, required this.index})
      : super(key: key);

  ///
  final Rx<int> counter;

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
                    key: Key('increment_getx_$index'),
                    onTap: () {
                      counter.value++;
                    },
                    child: const Text('Counter Increment')),
                Obx(() => Text(
                  'value_getx_${index}_${counter.value}',
                  key: Key('value_getx_$index'),
                )),
                GestureDetector(
                    key: Key('decrement_getx_$index'),
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
