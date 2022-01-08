import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? borderColor;
  final double? borderSize;
  final double? horizontalPadding;
  final double? verticalPadding;
  final bool? rounded;
  final double? textSize;

  const SecondaryButton({
    this.title,
    this.onTap,
    this.textColor,
    this.borderColor,
    this.borderSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.rounded,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 12,
          vertical: verticalPadding ?? 12,
        ),
        decoration: BoxDecoration(
          color:
              onTap == null ? Colors.grey[300] : Colors.white.withOpacity(0.2),
          borderRadius:
              BorderRadius.circular(rounded != null && rounded! ? 999 : 5),
          border: Border.all(
            width: borderSize ?? 2,
            color: onTap == null
                ? Colors.grey
                : borderColor == null
                    ? Theme.of(context).primaryColor
                    : borderColor!,
          ),
        ),
        child: Center(
          child: Text(
            title!,
            style: TextStyle(
              fontSize: textSize ?? 18,
              letterSpacing: 1,
              color: onTap == null
                  ? Colors.grey
                  : textColor == null
                      ? Theme.of(context).primaryColor
                      : textColor,
            ),
          ),
        ),
      ),
    );
  }
}
