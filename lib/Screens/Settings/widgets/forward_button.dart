import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:unipay/components/constants.dart';

class ForwardButton extends StatelessWidget {
  final Function() onTap;

  const ForwardButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color14,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          Ionicons.chevron_forward_outline, // Using Ionicons here
          color: Colors.white,
        ),
      ),
    );
  }
}
