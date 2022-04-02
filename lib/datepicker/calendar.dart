import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerCalendar extends StatefulWidget {
  const DatePickerCalendar({
    Key? key,
    required this.selectedDate,
    required this.onChanged,
    required this.backgroundColor,
    this.initialDate,
  }) : super(key: key);

  final Color? backgroundColor;
  final DateTime selectedDate;
  final DateTime? initialDate;
  final void Function(DateTime) onChanged;

  @override
  DatePickerCalendarState createState() => DatePickerCalendarState();
}

class DatePickerCalendarState extends State<DatePickerCalendar> {
  final int initialPage = 999;
  int currentPage = 999;

  final pageController = PageController(initialPage: 999);

  late DateTime selectedDate;
  late DateTime initialDate;

  List<String> weekdays = ['SUN', 'MON', 'THU', 'WED', 'TUE', 'FRI', 'SAT'];

  final pageDuration = const Duration(milliseconds: 300);
  final pageCurve = Curves.easeIn;

  void updateByOutfield(DateTime date) {
    final diff = diffYMD(initialDate, date);
    pageController.animateToPage(
      initialPage + diff,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    setState(() {
      selectedDate = date;
    });
  }

  int diffYMD(DateTime then, DateTime now) {
    int years = now.year - then.year;
    int months = now.month - then.month;
    // int days = now.day - then.day;
    // if (months < 0) {
    //   years--;
    //   months += (days < 0 ? 11 : 12);
    // }
    // if (days < 0) {
    //   final monthAgo = DateTime(now.year, now.month - 1, then.day);
    //   days = now.difference(monthAgo).inDays + 1;
    // }

    // print("-----");
    // print(then);
    // print(now);
    // print('$years years $months months $days days');

    return years * 12 + months;
  }

  @override
  void initState() {
    selectedDate = widget.selectedDate;
    initialDate = widget.initialDate ?? widget.selectedDate;

    super.initState();
  }

  DateTime calcMonth(int diff) {
    DateTime date = initialDate;
    // 次月への遷移の場合
    if (diff > 0) {
      var nextYear = date.year;
      var nextMonth = date.month + diff;

      if (date.month >= 12) {
        final x = nextMonth % 12;
        nextYear += x;
        nextMonth = nextMonth ~/ 12;
      }
      date = DateTime(nextYear, nextMonth, 1);
    }
    // 前月へ遷移の場合
    else if (diff < 0) {
      DateTime _x = DateTime(date.year, date.month, 1);
      for (var i = 0; i < diff.abs(); i++) {
        final _y = _x.add(const Duration(days: -1));
        _x = DateTime(_y.year, _y.month, 1);
      }
      date = _x;
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: PageView.builder(
            controller: pageController,
            itemBuilder: (context, index) {
              final diff = index - initialPage;
              final date = calcMonth(diff);

              return Column(
                children: [
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(top: 20, left: 8),
                    child: Row(
                      children: [
                        Text(
                          DateFormat('MMMM').format(date),
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(width: 8),
                        Opacity(
                          opacity: 0.4,
                          child: Text(
                            DateFormat('yyyy').format(date),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                  Container(
                    height: 24,
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        for (var i = 0; i < 7; i++)
                          Expanded(
                            child: Center(
                              child: Text(
                                weekdays[i],
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(
                                      color: textColor(i),
                                    ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView(
                      padding: const EdgeInsets.all(0),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1,
                      ),
                      children: buildCalendarOfMonth(date),
                    ),
                  ),
                ],
              );
            },
            onPageChanged: (index) {
              currentPage = index;
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 40,
            margin: const EdgeInsets.only(top: 20, left: 8),
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Container(
                  color: widget.backgroundColor ?? Theme.of(context).cardColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          pageController.previousPage(
                              duration: pageDuration, curve: pageCurve);
                        },
                        icon: const Opacity(
                          opacity: 0.6,
                          child: Icon(
                            Icons.arrow_back_rounded,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          pageController.nextPage(
                              duration: pageDuration, curve: pageCurve);
                        },
                        icon: const Opacity(
                          opacity: 0.6,
                          child: Icon(
                            Icons.arrow_forward_rounded,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildCalendarOfMonth(DateTime date) {
    List<Widget> list = [];

    final x = DateTime(date.year, date.month, 1);
    final y =
        DateTime(date.year, date.month + 1, 1).add(const Duration(days: -1));

    // 7 * 6の形式で表示する

    // 月の最初の曜日を取得
    final first = x.weekday;
    // 最初の曜日が日曜日(7)の場合は追加なし
    if (first != 7) {
      // 最初の曜日までは空白を表示
      for (var i = 0; i < first; i++) {
        list.add(Container());
      }
    }

    // 月のデータを設定
    for (var i = 1; i <= y.day; i++) {
      final z = x.add(Duration(days: i - 1));
      final _selected = _compareDate(z, selectedDate);

      list.add(
        Material(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(50),
          child: InkWell(
            onTap: () {
              setState(() {
                selectedDate = z;
              });
              final to = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                initialDate.hour,
                initialDate.minute,
              );
              widget.onChanged(to);
            },
            child: Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selected
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    '$i',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color:
                              _selected ? Colors.white : textColor(z.weekday),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return list;
  }

  Color? textColor(int weekday) {
    if (weekday == 7 || weekday == 0) {
      return Colors.red;
    } else if (weekday == 6) {
      return Colors.blue;
    }
    return null;
  }

  bool _compareDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
