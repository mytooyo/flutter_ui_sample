import 'package:flutter/material.dart';
import 'package:flutter_ui_sample/datepicker/calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'enum.dart';
import 'header.dart';
import 'item.dart';
import 'item_option.dart';

class DatePickerPage extends StatefulWidget {
  const DatePickerPage({Key? key}) : super(key: key);

  @override
  _DatePickerPageState createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  final DatePcikerController controller = DatePcikerController();

  final key = GlobalKey<_DatePickerContentsState>();

  @override
  Widget build(BuildContext context) {
    return DatePickerProvider(
      controller: controller,
      builder: (context) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 21, 29, 59),
          body: _DatePickerContents(
            key: key,
            controller: controller,
          ),
        );
      },
      onChanged: (val) {
        key.currentState?.change(val);
      },
      type: DatePickerType.datetime,
      showType: DatePickerShowType.bottomOverlay,
    );
  }
}

class _DatePickerContents extends StatefulWidget {
  const _DatePickerContents({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final DatePcikerController controller;

  @override
  _DatePickerContentsState createState() => _DatePickerContentsState();
}

class _DatePickerContentsState extends State<_DatePickerContents> {
  DateTime datetime = DateTime.now();
  DateTime date = DateTime.now();
  DateTime time = DateTime.now();

  DatePickerType? editing;

  @override
  Widget build(BuildContext context) {
    // final _time = TimeOfDay.fromDateTime(time);
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 40),
                child: Text(
                  'Date Picker',
                  style: GoogleFonts.pacifico(
                    textStyle: Theme.of(context).textTheme.headline4?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _item(
                        title: 'DateTime',
                        icon: Icons.date_range_rounded,
                        type: DatePickerType.datetime,
                        val: datetime,
                        format: 'yyyy/MM/dd HH:mm',
                        color: Colors.blue,
                      ),
                      _item(
                        title: 'Date',
                        icon: Icons.date_range_rounded,
                        type: DatePickerType.date,
                        val: date,
                        format: 'yyyy/MM/dd',
                        color: Colors.orange,
                      ),
                      _item(
                        title: 'Time',
                        icon: Icons.schedule_rounded,
                        type: DatePickerType.time,
                        val: time,
                        format: 'HH:mm',
                        color: Colors.pink,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () => widget.controller.close(),
                        child: const Text('閉じる'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item({
    required String title,
    required IconData icon,
    required DatePickerType type,
    required DateTime val,
    required String format,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            widget.controller.open(type, val);
            editing = type;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                Material(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 36,
                    width: 36,
                    child: Center(
                      child: Icon(
                        icon,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    DateFormat(format).format(val),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void change(DateTime val) {
    if (editing == null) return;

    setState(() {
      switch (editing!) {
        case DatePickerType.datetime:
          datetime = val;
          break;
        case DatePickerType.date:
          date = val;
          break;
        case DatePickerType.time:
          time = val;
          break;
      }
    });
  }
}

class DatePcikerController {
  final GlobalKey<_DatePickerProviderState> key = GlobalKey();

  void open(DatePickerType openType, DateTime val) {
    key.currentState?.openPicker(openType, val);
  }

  void close() {
    key.currentState?.closePicker();
  }
}

class DatePickerProvider extends StatefulWidget {
  DatePickerProvider({
    Key? key,
    required this.builder,
    required this.controller,
    required this.onChanged,
    this.type = DatePickerType.datetime,
    this.showType = DatePickerShowType.bottomResize,
    this.initialDate,
    this.backgroundColor,
  }) : super(key: controller.key);

  final DatePcikerController controller;
  final Widget Function(BuildContext context) builder;
  final void Function(DateTime) onChanged;
  final DatePickerType type;
  final DatePickerShowType showType;
  final Color? backgroundColor;
  final DateTime? initialDate;

  @override
  _DatePickerProviderState createState() => _DatePickerProviderState();
}

class _DatePickerProviderState extends State<DatePickerProvider>
    with TickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> sizeAnimation;

  late AnimationController keyboardAnimController;
  late Animation<double> keyboadAnimation;

  late AnimationController calendarAnimController;
  late Animation<double> calendarAnimation;
  late Animation<double> pickerFormAnimation;

  late DateTime date;

  /// フォーカスノード管理用
  List<FocusNode> focusNodes = [];
  late List<DatePickerItemOption> options;

  /// カレンダーWidgetのキー
  final GlobalKey<DatePickerCalendarState> calendarKey = GlobalKey();

  final backgroundColor = const Color.fromARGB(255, 235, 235, 241);

  List<DateType> updatingCalendar = [];

  late DatePickerType pickerType;

  @override
  void initState() {
    super.initState();

    pickerType = widget.type;
    date = widget.initialDate ?? DateTime.now();

    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      // value: 1.0,
    );

    keyboardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    calendarAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    final curve = CurveTween(curve: Curves.easeInOut);
    sizeAnimation = animController.drive(curve).drive(
          Tween<double>(begin: 0.0, end: 1.0),
        );

    keyboadAnimation = keyboardAnimController.drive(curve).drive(
          Tween<double>(begin: 1.0, end: 0.0),
        );

    calendarAnimation = calendarAnimController.drive(curve).drive(
          Tween<double>(begin: 0.0, end: 1.0),
        );
    pickerFormAnimation = calendarAnimController.drive(curve).drive(
          Tween<double>(begin: 1.0, end: 0.0),
        );

    setupOptions();
  }

  void setupOptions() {
    options = [
      if ([DatePickerType.date, DatePickerType.datetime]
          .contains(pickerType)) ...[
        DatePickerItemOption.init(DateType.year, date),
        DatePickerItemOption.init(DateType.month, date),
        DatePickerItemOption.init(DateType.day, date),
      ],
      if ([DatePickerType.time, DatePickerType.datetime]
          .contains(pickerType)) ...[
        DatePickerItemOption.init(DateType.hour, date),
        DatePickerItemOption.init(DateType.minute, date),
      ],
    ];

    for (final x in focusNodes) {
      x.dispose();
    }

    focusNodes = [];
    for (final x in options) {
      focusNodes.add(x.focusNode..addListener(keyboardListener));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;

        Widget child = AnimatedBuilder(
          animation: animController,
          builder: (context, child) {
            return Visibility(
              visible: animController.value != 0.0,
              child: SizeTransition(
                sizeFactor: sizeAnimation,
                axis: Axis.vertical,
                axisAlignment: -1.0,
                child: AnimatedBuilder(
                  animation: keyboardAnimController,
                  builder: (context, child) {
                    return _calendarAnimatedBuilder(isWide);
                  },
                ),
              ),
            );
          },
        );

        Widget body;
        switch (widget.showType) {
          case DatePickerShowType.bottomResize:
            body = Column(
              children: [
                Expanded(
                  child: widget.builder(context),
                ),
                child,
              ],
            );
            break;
          default:
            body = Stack(
              children: [
                Positioned.fill(child: widget.builder(context)),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: child,
                ),
              ],
            );
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: body,
        );
      },
    );
  }

  Widget header(bool isWide) => DatePickerHeader(
        calendarAnimController: calendarAnimController,
        calendarAnimation: calendarAnimation,
        keyboardAnimController: keyboardAnimController,
        keyboadAnimation: keyboadAnimation,
        onCalendar: () {
          if (calendarAnimController.value == 0.0) {
            // カレンダーを開くときにキーボードを閉じる
            for (final x in options) {
              if (x.focusNode.hasFocus) {
                x.focusNode.unfocus();
              }
            }
            calendarAnimController.forward();
          } else if (calendarAnimController.isCompleted) {
            calendarAnimController.reverse();
          }
        },
        onChangeDate: (val) {
          changeDate(val);
        },
        onChangTime: (val) {
          changeTime(val);
        },
        onKeyboadClose: () {
          for (final x in options) {
            if (x.focusNode.hasFocus) {
              x.focusNode.unfocus();
            }
          }
        },
        onClose: () {
          closePicker();
        },
        isWide: isWide,
        pickerType: pickerType,
        backgroundColor: backgroundColor,
      );

  Widget calendar({Color? background}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          color: background ?? Colors.transparent,
          child: DatePickerCalendar(
            key: calendarKey,
            backgroundColor: background,
            selectedDate: date,
            onChanged: (val) {
              date = val;
              for (final x in options) {
                // 変更が必要な場合のみ実施
                if (x.type == DateType.year && x.selected != val.year) {
                  updatingCalendar.add(DateType.year);
                  x.changeDate(val);
                }
                if (x.type == DateType.month && x.selected != val.month) {
                  updatingCalendar.add(DateType.month);
                  x.changeDate(val);
                }
                if (x.type == DateType.day && x.selected != val.day) {
                  updatingCalendar.add(DateType.day);
                  x.changeDate(val);
                }
              }
              widget.onChanged(date);
            },
          ),
        ),
      );

  Widget picker() => Visibility(
        visible: calendarAnimController.value != 1,
        child: FadeTransition(
          opacity: pickerFormAnimation,
          child: Container(
            color: backgroundColor,
            child: Align(
              alignment: Alignment.topCenter,
              child: Row(
                children: options
                    .map(
                      (x) => Expanded(
                        flex: x.flex,
                        child: DatePickerItem(
                          key: x.statekey,
                          option: x,
                          onChanged: (val) {
                            // 年月が変更された場合は日付が存在するかチェック
                            if ([DateType.year, DateType.month]
                                .contains(x.type)) {
                              checkExistsDate(x, val);
                            }

                            x.selected = val;
                            date = x.calcDate(date);
                            widget.onChanged(date);
                            // カレンダー側も更新する
                            // 更新対象外の場合は行わない
                            if (!updatingCalendar.contains(x.type)) {
                              // 時間の場合は更新しない
                              if (![DateType.hour, DateType.minute]
                                  .contains(x.type)) {
                                calendarKey.currentState
                                    ?.updateByOutfield(date);
                              }
                            }
                          },
                          onEditCompleted: () {
                            final index = options.indexOf(x);
                            if (index < 0 || index >= options.length - 1) {
                              return;
                            }

                            final option = options[index + 1];
                            if (option.focusNode.canRequestFocus) {
                              option.toFocus();
                            }
                          },
                          onFocus: () {},
                          onScrollEnded: () {
                            if (updatingCalendar.contains(x.type)) {
                              updatingCalendar.remove(x.type);
                            }
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      );

  Widget _calendarAnimatedBuilder(bool isWide) {
    // タブレットサイズの場合
    if (isWide) {
      return Container(
        height: pickerType == DatePickerType.time ? 320 : 440,
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              if (pickerType != DatePickerType.time)
                Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 12,
                  ),
                  child: calendar(),
                ),
              Expanded(
                child: Column(
                  children: [
                    header(isWide),
                    Expanded(child: picker()),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _contents() {
      return Stack(
        children: [
          Visibility(
            visible: calendarAnimController.value != 0,
            child: FadeTransition(
              opacity: calendarAnimation,
              child: calendar(background: backgroundColor),
            ),
          ),
          picker(),
        ],
      );
    }

    return AnimatedBuilder(
      animation: calendarAnimController,
      builder: (context, child) {
        return Container(
          height: 200 +
              (180 * calendarAnimation.value) +
              (keyboadAnimation.value * 140),
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SafeArea(
            top: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  header(isWide),
                  Expanded(child: _contents()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void openPicker(DatePickerType type, DateTime val) {
    date = val;
    pickerType = type;
    setupOptions();

    // 時間表示指定でカレンダーが表示されていた場合は戻す
    if (type == DatePickerType.time && calendarAnimController.isCompleted) {
      calendarAnimController.reset();
    }

    keyboardAnimController.reset();
    animController.forward();
  }

  void closePicker() {
    animController.reverse();
  }

  void keyboardListener() {
    // フォーカス保持中のFocusNode取得
    final hasFocuses = focusNodes.where((x) => x.hasFocus).toList();

    //　フォーカスされていない場合
    if (hasFocuses.isEmpty && keyboardAnimController.isCompleted) {
      Future<void>.delayed(const Duration(milliseconds: 200)).then((_) {
        keyboardAnimController.reverse();
      });
    } else if (hasFocuses.isNotEmpty && keyboardAnimController.value == 0.0) {
      Future<void>.delayed(const Duration(milliseconds: 300)).then((_) {
        keyboardAnimController.forward();
      });
    }
  }

  // 日付更新
  void changeDate(DateTime val) {
    for (final x in options) {
      // 変更が必要な場合のみ実施
      if (x.type == DateType.year && x.selected != val.year) {
        updatingCalendar.add(DateType.year);
        x.changeDate(val);
      } else if (x.type == DateType.month && x.selected != val.month) {
        updatingCalendar.add(DateType.month);
        x.changeDate(val);
      } else if (x.type == DateType.day && x.selected != val.day) {
        updatingCalendar.add(DateType.day);
        x.changeDate(val);
      }
    }

    calendarKey.currentState?.updateByOutfield(val);
  }

  // 時間更新
  void changeTime(DateTime val) {
    for (final x in options) {
      if (x.type == DateType.hour && x.selected != val.hour) {
        x.changeDate(val);
      } else if (x.type == DateType.minute && x.selected != val.minute) {
        x.changeDate(val);
      }
    }
  }

  /// 月の最終日付を取得
  void checkExistsDate(DatePickerItemOption x, int val) {
    var year =
        options.where((x) => x.type == DateType.year).toList().first.selected;
    var month =
        options.where((x) => x.type == DateType.month).toList().first.selected;

    if (x.type == DateType.year) {
      year = val;
    } else if (x.type == DateType.month) {
      month = val;
    }

    // 翌月を指定してマイナス1日する
    month += 1;
    if (month > 12) month = 1;
    final _date = DateTime(year, month, 1).add(const Duration(days: -1));

    // 日付を更新
    final day = options.where((x) => x.type == DateType.day).toList().first;
    day.updateList(_date.day);
    date = day.calcDate(date);
  }

  bool isValidDate(String input) {
    final date = DateTime.parse(input);
    final originalFormatString = toOriginalFormatString(date);
    return input == originalFormatString;
  }

  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }
}
