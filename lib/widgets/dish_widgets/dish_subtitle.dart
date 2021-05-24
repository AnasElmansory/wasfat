import 'package:flutter/material.dart';

class DishSubtitle extends StatelessWidget {
  final String subtitle;

  const DishSubtitle({Key? key, required this.subtitle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        subtitle,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
