import 'package:flutter/material.dart';

Widget confirmationDialog(
  String title,
  String content,
  bool toRemove,
  BuildContext context,
) {
  return AlertDialog(
    title: Text(
      '$title',
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
    ),
    content: Text(
      '$content',
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
    ),
    titleTextStyle: const TextStyle(color: const Color(0xFF00695C)),
    contentTextStyle: const TextStyle(color: const Color(0xFF00796b)),
    actions: [
      IconButton(
          icon: toRemove
              ? const Icon(Icons.delete, color: Colors.red)
              : const Icon(Icons.done, color: Colors.green),
          onPressed: () => Navigator.of(context).pop(true)),
      IconButton(
          icon: const Icon(Icons.cancel),
          color: Colors.grey,
          onPressed: () => Navigator.of(context).pop(false))
    ],
  );
}
