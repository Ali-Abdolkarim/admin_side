import 'package:flutter/material.dart';

typedef ActionP = Function();
typedef ActionRSIS = String? Function(String?);

class SimpleButton extends StatelessWidget {
  final ActionP? action;
  final String title;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? borderRadius;
  const SimpleButton(this.title,
      {super.key,
      this.action,
      this.backgroundColor,
      this.textColor,
      this.height,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              backgroundColor ?? const Color.fromARGB(255, 213, 44, 35)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 15),
            ),
          ),
        ),
        onPressed: action,
        child: Text(
          title,
          style: TextStyle(color: textColor ?? Colors.white),
        ),
      ),
    );
  }
}
