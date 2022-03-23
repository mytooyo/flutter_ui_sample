///
/// Copyright (c) 2022 mytooyo. All rights reserved.
/// This software is released under the MIT License, see LICENSE.

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.obscureText = false,
    this.icon,
    this.isKeepIconSize = false,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool obscureText;
  final IconData? icon;
  final bool isKeepIconSize;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late TextEditingController textController;
  late FocusNode focusNode;

  late AnimationController controller;
  late Animation<Color?> colorAnimation;

  @override
  void initState() {
    super.initState();

    textController = widget.controller ?? TextEditingController();
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller.forward();
      } else {
        controller.reverse();
      }
    });

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      reverseDuration: const Duration(milliseconds: 400),
    );
    colorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.orange,
    ).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textField = TextField(
      controller: textController,
      focusNode: focusNode,
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
        hintText: widget.hintText ?? 'TextField',
        hintStyle: textStyle(context)?.copyWith(
          fontWeight: FontWeight.w500,
          color: textStyle(context)?.color?.withOpacity(0.3),
        ),
        border: inputBorder(Colors.transparent),
        enabledBorder: inputBorder(Colors.grey[300]!),
        focusedBorder: inputBorder(Colors.grey[300]!),
        errorBorder: inputBorder(Colors.red[700]!),
      ),
      style: textStyle(context),
      cursorColor: Colors.orange,
      cursorWidth: 2.0,
      obscureText: widget.obscureText,
    );

    return Row(
      children: [
        if (widget.icon != null)
          Container(
            margin: const EdgeInsets.only(top: 4, right: 8),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Icon(
                  widget.icon,
                  size: 20,
                  color: colorAnimation.value,
                );
              },
            ),
          ),
        if (widget.icon == null && widget.isKeepIconSize)
          const SizedBox(width: 28),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 44,
                child: textField,
              ),
              AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return SizeTransition(
                    axis: Axis.horizontal,
                    sizeFactor: controller
                        .drive(CurveTween(curve: Curves.easeOutCubic))
                        .drive(Tween<double>(begin: 0.0, end: 1.0)),
                    axisAlignment: 1.0,
                    child: Container(
                      height: 2.4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle? textStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 17);

  InputBorder inputBorder(Color color) => UnderlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: color,
        ),
      );
}
