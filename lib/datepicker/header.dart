import 'dart:math';

import 'package:flutter/material.dart';

import 'enum.dart';

class DatePickerHeader extends StatelessWidget {
  const DatePickerHeader({
    Key? key,
    required this.calendarAnimController,
    required this.calendarAnimation,
    required this.keyboardAnimController,
    required this.keyboadAnimation,
    required this.onCalendar,
    required this.onChangeDate,
    required this.onChangTime,
    required this.onKeyboadClose,
    required this.onClose,
    required this.isWide,
    required this.pickerType,
    required this.backgroundColor,
  }) : super(key: key);

  final bool isWide;
  final DatePickerType pickerType;
  final AnimationController calendarAnimController;
  final Animation<double> calendarAnimation;
  final AnimationController keyboardAnimController;
  final Animation<double> keyboadAnimation;
  final void Function() onCalendar;
  final void Function(DateTime) onChangeDate;
  final void Function(DateTime) onChangTime;
  final void Function() onKeyboadClose;
  final void Function() onClose;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      margin: const EdgeInsets.only(top: 20, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardColor.withOpacity(0.99),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          if (pickerType != DatePickerType.time) ...[
            if (!isWide)
              Opacity(
                opacity: 0.6,
                child: IconButton(
                  onPressed: () {
                    onCalendar();
                  },
                  icon: Transform.rotate(
                    angle: pi * 2 * calendarAnimation.value,
                    child: Icon(
                      calendarAnimController.value > 0.5
                          ? Icons.view_day_rounded
                          : Icons.calendar_month_rounded,
                      size: 20,
                    ),
                  ),
                ),
              ),
            if (isWide) const SizedBox(width: 16),
            _textButton(
              context,
              'TODAY',
              () {
                onChangeDate(DateTime.now());
              },
            ),
            SizedBox(width: isWide ? 20 : 12),
            _textButton(
              context,
              'TOMORROW',
              () {
                onChangeDate(DateTime.now().add(const Duration(days: 1)));
              },
            ),
          ],
          if (pickerType == DatePickerType.time) ...[
            const SizedBox(width: 16),
            _textButton(
              context,
              'NOW',
              () {
                onChangTime(DateTime.now());
              },
            ),
          ],
          Expanded(child: Container()),
          Visibility(
            visible: keyboardAnimController.value != 0,
            child: Opacity(
              opacity: 0.8 * (1 - keyboadAnimation.value),
              child: IconButton(
                onPressed: () {
                  onKeyboadClose();
                },
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                ),
              ),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: IconButton(
              onPressed: () {
                onClose();
              },
              icon: const Icon(Icons.close_rounded),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textButton(
      BuildContext context, String title, void Function() callback) {
    return Material(
      color: backgroundColor.withOpacity(0.8),
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        child: Container(
          height: 28,
          padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 12),
          child: Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ),
        onTap: callback,
      ),
    );
  }
}
