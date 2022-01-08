import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final VoidCallback? onTap;
  final double? padding;
  final bool? rounded;
  final double? height;
  final double? textSize;
  final FontWeight? textWeight;
  final double? iconSize;
  final Color? backColor;

  const PrimaryButton({
    this.title,
    this.icon,
    this.onTap,
    this.padding,
    this.rounded,
    this.height,
    this.textSize,
    this.textWeight,
    this.iconSize,
    this.backColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: onTap != null ? onTap : () => '',
        child: Container(
          padding: EdgeInsets.all(padding ?? 12),
          // width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(rounded != null && rounded! ? 999 : 3),
            color: onTap == null
                ? Colors.grey
                : backColor ?? Theme.of(context).primaryColor,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                title != null
                    ? Text(
                        title!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: textSize ?? 18,
                          letterSpacing: 1,
                          fontWeight: textWeight ?? FontWeight.bold,
                        ),
                      )
                    : Container(),
                icon != null
                    ? Row(
                        children: [
                          SizedBox(width: title != null ? 5 : 0),
                          Icon(
                            icon,
                            color: Colors.white,
                            size: iconSize ?? 20,
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
