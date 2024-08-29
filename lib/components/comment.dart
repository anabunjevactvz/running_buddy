import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  const Comment({super.key, required this.text, required this.user, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text),

          const SizedBox(height: 5),
          Row(
            children: [
              Text(user, style: const TextStyle(color: Colors.grey)),
              const Text(" . ", style: TextStyle(color: Colors.grey)),
              Text(time, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ]
      ),
    );
  }
}
