import 'package:flutter/material.dart';
import 'package:newzzy/utils/colors.dart';

class FilterSource extends StatefulWidget {
  FilterSource({Key? key}) : super(key: key);

  @override
  _FilterSourceState createState() => _FilterSourceState();
}

class _FilterSourceState extends State<FilterSource> {
  static int _len = 10;
  List<bool> isChecked = List.generate(_len, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(children: [
        const Text('Filter by sources',
            style: TextStyle(
                color: textColor2, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 20,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _len,
            itemBuilder: (context, index) {
              return _checkbocItem("Item $index", index);
            }),
      ]),
    );
  }

  Widget _checkbocItem(title, index) {
    return ListTile(
      title: Text(
        "Item $index",
        style: TextStyle(
          color: isChecked[index]
              ? appBarColor
              : Theme.of(context).unselectedWidgetColor,
          fontSize: 16,
        ),
      ),
      trailing: Checkbox(
          onChanged: (checked) {
            setState(
              () {
                isChecked[index] = checked!;
                // _title = _getTitle();
              },
            );
          },
          value: isChecked[index]),
    );
  }
}
