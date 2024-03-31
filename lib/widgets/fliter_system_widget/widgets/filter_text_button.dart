/*
build and display the FilterTextButton widget.
It returns an instance of the TextButton widget with its
onPressed function calling the onTap function passed to 
this widget. The child of the TextButton is an instance of 
the Text widget where it gets its properties assigned. 
However, if they are not assigned, the widget will be assigned 
the defaults, such as an empty string for the text property. 
Lastly, the style of the text is defined with various parameters
that determine its appearance.
*/

import 'package:flutter/material.dart';

class FilterTextButton extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final Function()? onTap;
  final bool isSecondary;
  final Color? txtColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const FilterTextButton({
    Key? key,
    this.text,
    this.style,
    this.onTap,
    this.isSecondary = false,
    this.txtColor,
    this.fontWeight,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        text ?? '',
        style: style ??
            (isSecondary
                ? Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: txtColor ?? Theme.of(context).primaryColor,
                      fontWeight: fontWeight,
                      fontSize: fontSize,
                    )
                : Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: txtColor ?? Theme.of(context).primaryColor,
                      fontWeight: fontWeight,
                      fontSize: fontSize,
                    )),
      ),
    );
  }
}
