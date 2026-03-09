import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final bool expanded;
  final Color? color;
  final Color? textColor;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.expanded = true,
    this.color,
    this.textColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? 48;
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: color ?? Theme.of(context).primaryColor,
      foregroundColor: textColor ?? Colors.white,
      minimumSize: expanded ? Size(double.infinity, buttonHeight) : const Size(120, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    if (loading) {
      return Container(
        height: buttonHeight,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Text(text),
    );
  }
}