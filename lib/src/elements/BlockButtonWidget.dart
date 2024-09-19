import 'package:flutter/material.dart';

class BlockButtonWidget extends StatelessWidget {
   const BlockButtonWidget({super.key, this.color,
       this.text,
       this.onPressed});

  final Color? color;
  final Text? text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: color,
      shape: const StadiumBorder(),
      child: text,
    );
  }
}
