import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final String dividerName;
  final double marginTop, marginBottom;

  const DividerWidget({
    required this.dividerName,
    this.marginTop = 0.0,
    this.marginBottom = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: marginTop, bottom: marginBottom),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Divider(
              height: 2,
              color: Colors.deepOrange,
            ),
          ),
          Text(
            "    " + dividerName + "    ",
          ),
          Expanded(
            flex: 1,
            child: Divider(
              height: 2,
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }
}
