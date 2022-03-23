///
/// Copyright (c) 2022 mytooyo. All rights reserved.
/// This software is released under the MIT License, see LICENSE.

import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
  }) : super(key: key);

  final String title;
  final void Function() onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.backgroundColor,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: widget.onPressed,
        child: Container(
          height: 52,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 12,
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: widget.foregroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                width: 60,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: widget.foregroundColor,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: widget.backgroundColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
