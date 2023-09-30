import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFieldWidget extends StatefulWidget {
  final Function(String text)? oncomplete;
  final InputBorder border;
  final String labelText;
  final String hintText;
  final TextStyle style;
  final String text;
  final bool expands;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final TextAlign textAlign;

  const InputFieldWidget(
      {super.key,
      this.oncomplete,
      this.border = const OutlineInputBorder(),
      this.labelText = "",
      this.hintText = "",
      this.text = "",
      this.expands = false,
      this.textInputType = TextInputType.text,
      this.style = const TextStyle(),
      this.textAlign = TextAlign.left,
      this.inputFormatters = const []});

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
      text: widget.text,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focus) {
        if (!focus && widget.oncomplete != null) {
          widget.oncomplete!(_controller.text);
        }
      },
      child: TextField(
        textAlign: widget.textAlign,
        keyboardType: widget.textInputType,
        minLines: null,
        maxLines: null,
        expands: widget.expands,
        controller: _controller,
        style: widget.style,
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          border: widget.border,
          labelText: widget.labelText,
          labelStyle: widget.style,
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
