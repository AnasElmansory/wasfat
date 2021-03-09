import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final String dividerName;
  final double marginTop, marginBottom;

  const DividerWidget(this.dividerName, this.marginTop, this.marginBottom);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: marginTop, bottom: marginBottom),
      child: Row(
        children: [
          Expanded(
              child: Divider(
                height: 2,
                color: Colors.deepOrange,
              ),
              flex: 4),
          Text(
            "    " + dividerName + "    ",
          ),
          Expanded(
              child: Divider(
                height: 2,
                color: Colors.deepOrange,
              ),
              flex: 1),
        ],
      ),
    );
  }
}
