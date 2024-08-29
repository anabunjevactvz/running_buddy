import 'package:flutter/material.dart';

class AcceptButton extends StatefulWidget {
  final bool isAccepted;
  final Function()? onTap;
  const AcceptButton({super.key, required this.isAccepted, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isAccepted ? Icons.check_circle: Icons.check_circle_outline,
        color: isAccepted ? Colors.green : Colors.grey,
      ),
    );
  }

  @override
  State<AcceptButton> createState() => _AcceptButtonState();
}

class _AcceptButtonState extends State<AcceptButton> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
