import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:newzzy/utils/colors.dart';

class NewPageErorr extends StatelessWidget {
  String erroMessage;
  NewPageErorr({
    Key? key,
    required this.erroMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        alignment: Alignment.center,
        child: Text(
          erroMessage,
          style: TextStyle(
              color: failureColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }
}
