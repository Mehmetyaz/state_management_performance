import 'package:flutter/material.dart';

///
class CollectionChangesDefault extends StatefulWidget {
  ///
  const CollectionChangesDefault({Key? key, required this.count})
      : super(key: key);

  final int count;

  @override
  State<CollectionChangesDefault> createState() =>
      _CollectionChangesDefaultState();
}

class _CollectionChangesDefaultState extends State<CollectionChangesDefault> {
  ///
  late final List<int> list = List.generate(widget.count, (index) => 0);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('SUM: $sum', key: const Key('sum_default')),
        ),
        body: ListView.separated(
          itemCount: list.length,
          cacheExtent: 2000,
          itemBuilder: (c, i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              children: [
                Container(
                  width: 200,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  child: Text(
                    'Index Of $i',
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          key: Key('increment_default_$i'),
                          onTap: () {
                            setState(() {
                              list[i]++;
                            });
                          },
                          child: const Text('Counter Increment')),
                      Text(
                        'value_default_${i}_${list[i]}',
                        key: Key('value_default_$i'),
                      ),
                      GestureDetector(
                          key: Key('decrement_default_$i'),
                          onTap: () {
                            setState(() {
                              list[i]--;
                            });
                          },
                          child: const Text('Counter Decrement'))
                    ],
                  ),
                ),
              ],
            ),
          ),
          separatorBuilder: (context, index) => const Divider(),
        ),
      );

  ///
  int get sum {
    var i = 0;
    for (var o in list) {
      i += o;
    }
    return i;
  }
}
