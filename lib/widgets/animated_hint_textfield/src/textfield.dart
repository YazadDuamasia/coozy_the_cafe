import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

enum AnimationType { fade, slide, typer }

class AnimatedHintTextField extends StatefulWidget {
  final InputDecoration decoration;
  final List<String>? hintTexts;
  final AnimationType animationType;
  final Duration animationDuration;
  final TextAlign hintTextAlign;
  final TextStyle hintTextStyle;
  final TextEditingController? controller;
  FocusNode? focusNode;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final String obscuringCharacter;
  final SmartDashesType smartDashesType;
  final SmartQuotesType smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final bool readOnly;
  final bool showCursor;

  AnimatedHintTextField({
    Key? key,
    required this.decoration,
    required this.hintTexts,
    this.animationType = AnimationType.fade,
    this.animationDuration = const Duration(milliseconds: 2000),
    this.hintTextAlign = TextAlign.start,
    this.hintTextStyle = const TextStyle(),
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.obscuringCharacter = '•',
    this.smartDashesType = SmartDashesType.enabled,
    this.smartQuotesType = SmartQuotesType.enabled,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.readOnly = false,
    this.showCursor = true,
  })  : assert(decoration != null),
        assert(hintTexts != null && hintTexts.isNotEmpty),
        assert(animationDuration != null),
        assert(hintTextAlign != null),
        assert(hintTextStyle != null),
        assert(autofocus != null),
        assert(obscureText != null),
        assert(autocorrect != null),
        assert(keyboardType != null),
        assert(textCapitalization != null),
        assert(textAlign != null),
        assert(obscuringCharacter != null && obscuringCharacter.isNotEmpty),
        assert(smartDashesType != null),
        assert(smartQuotesType != null),
        assert(enableSuggestions != null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(expands != null),
        assert(readOnly != null),
        assert(showCursor != null),
        super(key: key);

  @override
  _AnimatedHintTextFieldState createState() => _AnimatedHintTextFieldState();
}

class _AnimatedHintTextFieldState extends State<AnimatedHintTextField> {
  late ValueNotifier<String> inputValue;
  late ValueNotifier<bool> showHintValue;

  @override
  void initState() {
    super.initState();
    inputValue = ValueNotifier<String>(widget.controller?.text ?? '');
    showHintValue = ValueNotifier<bool>(true);
    widget.focusNode ??= new FocusNode();
    widget.controller?.addListener(() {
      inputValue.value = widget.controller!.text;
    });
  }

  InputDecoration _buildInputDecoration() => widget.decoration.copyWith(
    floatingLabelBehavior: widget.decoration.label != null
        ? null
        : FloatingLabelBehavior.never,
    label: widget.decoration.label ??
        (widget.hintTexts!.isEmpty
            ? null
            : ValueListenableBuilder<bool>(
          valueListenable: showHintValue,
          builder: (context, showHint, child) =>
              ValueListenableBuilder<String>(
                valueListenable: inputValue,
                builder: (context, text, child) =>
                text.isNotEmpty || !showHint
                    ? const SizedBox.shrink()
                    : AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: _buildAnimatedTexts(),
                ),
              ),
        )),
  );

  List<AnimatedText> _buildAnimatedTexts() => widget.hintTexts!.map((text) {
    switch (widget.animationType) {
      case AnimationType.typer:
        return TyperAnimatedText(
          text,
          speed: Duration(
              milliseconds:
              widget.animationDuration.inMilliseconds ~/ text.length),
          textAlign: widget.hintTextAlign,
          textStyle: widget.hintTextStyle,
        );
      case AnimationType.slide:
        return RotateAnimatedText(
          text,
          duration: widget.animationDuration,
          alignment: Alignment.centerLeft,
          textAlign: widget.hintTextAlign,
          textStyle: widget.hintTextStyle,
        );
      case AnimationType.fade:
      default:
        return FadeAnimatedText(
          text,
          duration: widget.animationDuration,
          textAlign: widget.hintTextAlign,
          textStyle: widget.hintTextStyle,
        );
    }
  }).toList();

  @override
  void dispose() {
    widget.controller?.removeListener(() {
      inputValue.value = widget.controller!.text;
    });
    inputValue.dispose();
    showHintValue.dispose();
    widget.focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      decoration: _buildInputDecoration(),
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      textDirection: widget.textDirection,
      obscuringCharacter: widget.obscuringCharacter,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      readOnly: widget.readOnly,
      showCursor: widget.showCursor,
    );
  }
}