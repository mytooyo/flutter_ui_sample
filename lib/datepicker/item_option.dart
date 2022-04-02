import 'package:flutter/material.dart';

import 'enum.dart';
import 'item.dart';

class DatePickerItemOption {
  final int flex;
  final FocusNode focusNode;
  List<int> list;
  final DateType type;
  final int maxLength;
  int selected;

  DatePickerItemOption({
    required this.flex,
    required this.focusNode,
    required this.list,
    required this.type,
    required this.selected,
    required this.maxLength,
  });

  final statekey = GlobalKey<DatePickerItemState>();

  factory DatePickerItemOption.init(DateType type, DateTime date) {
    List<int> _list = [];
    int _selected;
    switch (type) {
      case DateType.year:
        return DatePickerItemOption.year(date);
      case DateType.month:
        for (var i = 1; i <= 12; i++) {
          _list.add(i);
        }
        _selected = date.month;
        break;
      case DateType.day:
        for (var i = 1; i <= 31; i++) {
          _list.add(i);
        }
        _selected = date.day;
        break;
      case DateType.hour:
        for (var i = 0; i <= 23; i++) {
          _list.add(i);
        }
        _selected = date.hour;
        break;
      case DateType.minute:
        for (var i = 0; i <= 59; i++) {
          _list.add(i);
        }
        _selected = date.minute;
        break;
    }

    return DatePickerItemOption(
      flex: 1,
      focusNode: FocusNode(),
      list: _list,
      type: type,
      selected: _selected,
      maxLength: 2,
    );
  }

  factory DatePickerItemOption.year(DateTime date) {
    List<int> _list = [];
    for (var i = 2020; i < 2040; i++) {
      _list.add(i);
    }
    return DatePickerItemOption(
      flex: 2,
      focusNode: FocusNode(),
      list: _list,
      type: DateType.year,
      selected: date.year,
      maxLength: 4,
    );
  }

  void updateList(int maxDay) {
    List<int> _list = [];
    for (var i = 1; i <= maxDay; i++) {
      _list.add(i);
    }
    list = _list;

    if (selected >= list.length) {
      selected = list.last;
    }

    statekey.currentState?.updateState(list);
  }

  int getIndex({int? index}) {
    switch (type) {
      case DateType.year:
        return (index ?? selected) - 2020;
      case DateType.month:
      case DateType.day:
        return (index ?? selected) - 1;
      default:
        return index ?? selected;
    }
  }

  int getValueFromIndex(int index) {
    switch (type) {
      case DateType.year:
        return 2020 + index;
      case DateType.month:
      case DateType.day:
        return index + 1;
      default:
        return index;
    }
  }

  void changeDate(DateTime date) {
    switch (type) {
      case DateType.year:
        selected = date.year;
        break;
      case DateType.month:
        selected = date.month;
        break;
      case DateType.day:
        selected = date.day;
        break;
      case DateType.hour:
        selected = date.hour;
        break;
      case DateType.minute:
        selected = date.minute;
        break;
    }
    statekey.currentState?.toAnimateChange(selected, button: true);
  }

  void toFocus() {
    statekey.currentState?.toFocus();
  }

  DateTime calcDate(DateTime date, {int? index}) {
    switch (type) {
      case DateType.year:
        return DateTime(
          (index ?? selected),
          date.month,
          date.day,
          date.hour,
          date.minute,
        );
      case DateType.month:
        return DateTime(
          date.year,
          (index ?? selected),
          date.day,
          date.hour,
          date.minute,
        );
      case DateType.day:
        return DateTime(
          date.year,
          date.month,
          (index ?? selected),
          date.hour,
          date.minute,
        );
      case DateType.hour:
        return DateTime(
          date.year,
          date.month,
          date.day,
          (index ?? selected),
          date.minute,
        );
      case DateType.minute:
        return DateTime(
          date.year,
          date.month,
          date.day,
          date.hour,
          (index ?? selected),
        );
    }
  }
}
