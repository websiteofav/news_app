import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:newzzy/utils/colors.dart';

class FirstLoadErorr extends StatelessWidget {
  String erroMessage;
  VoidCallback onRefresh;
  FirstLoadErorr({Key? key, required this.erroMessage, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Text(
          erroMessage,
          style: TextStyle(
              color: textColor2, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(40),
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.4,
        child: ElevatedButton(
          onPressed: onRefresh,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(borderColor1)),
          child: const Text(
            'Try Again',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    ]);
  }
}
