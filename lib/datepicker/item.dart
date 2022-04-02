import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'item_option.dart';

class DatePickerItem extends StatefulWidget {
  const DatePickerItem({
    Key? key,
    required this.option,
    required this.onChanged,
    required this.onEditCompleted,
    required this.onFocus,
    required this.onScrollEnded,
  }) : super(key: key);

  final DatePickerItemOption option;
  final void Function(int) onChanged;
  final void Function() onEditCompleted;
  final void Function() onFocus;
  final void Function() onScrollEnded;

  @override
  DatePickerItemState createState() => DatePickerItemState();
}

class DatePickerItemState extends State<DatePickerItem> {
  final double itemSize = 44;

  late FixedExtentScrollController scrollController;
  late TextEditingController textController;

  int selected = 0;
  bool isTextEditing = false;
  bool isAnimating = false;

  final borderRadius = BorderRadius.circular(4);

  final duration = const Duration(milliseconds: 200);

  List<int> list = [];

  void onChange(int index) {
    setState(() {
      selected = widget.option.getValueFromIndex(index);
    });
    textController.text = '$selected';

    if (isAnimating) {
      Future.delayed(duration).then((_) {
        textController.selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length),
        );
        isAnimating = false;

        // 最大値の場合のみ
        if (widget.option.maxLength == textController.text.length) {
          widget.onEditCompleted();
        }
      });
    }

    widget.onChanged(selected);
  }

  void toAnimateChange(int index, {bool button = false}) {
    // リスト内に存在する場合のみ変更
    if (widget.option.list.contains(index)) {
      selected = index;
      if (!button) isAnimating = true;

      scrollController.animateToItem(
        widget.option.getIndex(index: selected),
        duration: duration,
        curve: Curves.easeIn,
      );
    }
  }

  void toFocus() {
    setState(() {
      isTextEditing = true;
    });
    widget.option.focusNode.requestFocus();
  }

  void updateState(List<int> _list) {
    setState(() {
      list = _list;
      // 選択中のインデックスが存在しない場合は最後のインデックスを指定
      if (widget.option.getIndex(index: selected) >= list.length) {
        selected = list.last;

        scrollController.animateToItem(
          widget.option.getIndex(index: selected),
          duration: duration,
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void initState() {
    list = widget.option.list;
    selected = widget.option.selected;
    scrollController = FixedExtentScrollController(
      initialItem: widget.option.getIndex(),
    );
    textController = TextEditingController(text: '$selected');

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Material(
              color: Colors.white,
              borderRadius: borderRadius,
              child: SizedBox(
                height: itemSize,
                width: double.infinity,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: NotificationListener(
                child: SizedBox(
                  height: itemSize * 5,
                  child: ListWheelScrollView.useDelegate(
                    controller: scrollController,
                    physics: const FixedExtentScrollPhysics(),
                    itemExtent: itemSize,
                    diameterRatio: 8,
                    perspective: 0.01,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    // useMagnifier: true,
                    onSelectedItemChanged: onChange,
                    childDelegate: ListWheelChildListDelegate(
                      children: [
                        for (final i in list) _itemWidget(i),
                      ],
                    ),
                  ),
                ),
                onNotification: (info) {
                  if (info is ScrollEndNotification) {
                    widget.onScrollEnded();
                  }
                  return true;
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isTextEditing = true;
                  });
                  widget.onFocus();
                  Future.delayed(const Duration(milliseconds: 50)).then((_) {
                    widget.option.focusNode.requestFocus();
                  });
                },
                borderRadius: borderRadius,
                child: SizedBox(
                  height: itemSize,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          Visibility(
            visible: isTextEditing,
            child: _centerAlign(
              TextField(
                controller: textController,
                focusNode: widget.option.focusNode,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 4, left: 2),
                ),
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(widget.option.maxLength),
                ],
                onChanged: (text) {
                  // 数値変換できるか確認
                  try {
                    int.parse(text);
                  } catch (_) {
                    // 数値変換でエラーの場合は無視
                    return;
                  }

                  final data = int.parse(text);
                  toAnimateChange(data);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _centerAlign(Widget child) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: itemSize,
        width: double.infinity,
        child: child,
      ),
    );
  }

  Widget _itemWidget(int i) {
    double opacity = 1.0;
    TextStyle? textStyle = Theme.of(context).textTheme.bodyText1;
    if (selected == i) {
      textStyle = textStyle?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 17,
      );
      opacity = isTextEditing ? 0.0 : 1.0;
    } else {
      textStyle = textStyle?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
      opacity = 0.4;
    }

    return Center(
      child: Opacity(
        opacity: opacity,
        child: Text(
          '$i',
          style: textStyle,
        ),
      ),
    );
  }
}
