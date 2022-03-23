///
/// Copyright (c) 2022 mytooyo. All rights reserved.
/// This software is released under the MIT License, see LICENSE.

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth > 900
              ? const CardMainWidePage()
              : const CardMainPage();
          // return const CardMainPage();
        },
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    );
  }
}

class CardMainWidePage extends StatelessWidget {
  const CardMainWidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Scaffold(
            // backgroundColor: const Color.fromARGB(255, 119, 86, 156),
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/card/wide_bg.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 40),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 520,
                        ),
                        child: Column(
                          children: [
                            const CardWidget(isWide: true),
                            const SizedBox(height: 40),
                            Row(
                              children: const [
                                Expanded(
                                  child: _CardPageMenuItem(
                                    title: 'Payment',
                                    icon: Icons.paid_rounded,
                                    center: true,
                                    color: Color(0xff0C3C73),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _CardPageMenuItem(
                                    title: 'Scan',
                                    icon: Icons.qr_code_scanner_rounded,
                                    center: true,
                                    color: Color(0xff4F0753),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: const [
                                Expanded(
                                  child: _CardPageMenuItem(
                                    title: 'Deposit',
                                    icon: Icons.payment_rounded,
                                    center: true,
                                    color: Color(0xff0C3C73),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _CardPageMenuItem(
                                    title: 'Send',
                                    icon: Icons.send_rounded,
                                    center: true,
                                    color: Color(0xff4F0753),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 44),
                            const _CardPageMenuItem(
                              title: 'History',
                              icon: Icons.history_rounded,
                              type: _CardMenuItemType.top,
                              next: true,
                            ),
                            const _CardPageMenuItem(
                              title: 'Card Information',
                              icon: Icons.info_outline_rounded,
                              type: _CardMenuItemType.middle,
                              next: true,
                            ),
                            const _CardPageMenuItem(
                              title: 'Notifications',
                              icon: Icons.notifications_rounded,
                              type: _CardMenuItemType.bottom,
                              next: true,
                            ),
                            const SizedBox(height: 44),
                            const _CardPageMenuItem(
                              title: 'Account',
                              icon: Icons.account_circle_rounded,
                              next: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 239, 245, 252),
            body: SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 300,
                          child: HistoryChart.withData(),
                        ),
                        const SizedBox(height: 56),
                        ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            for (final item in _HistoryMock.data())
                              _item(context, item),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _item(BuildContext context, _History item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 36,
          child: Row(
            children: [
              Container(
                width: 68,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.only(right: 20),
                child: Center(
                  child: Text(
                    item.date,
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          color: const Color(0xff0C3C73),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              Expanded(
                child: Opacity(
                  opacity: 0.7,
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
              Text(
                item.payment,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: const Color(0xff0C3C73).withOpacity(0.1),
          margin: const EdgeInsets.only(left: 88, bottom: 12),
        ),
      ],
    );
  }
}

class CardMainPage extends StatefulWidget {
  const CardMainPage({Key? key}) : super(key: key);

  @override
  _CardMainPageState createState() => _CardMainPageState();
}

class _CardMainPageState extends State<CardMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 119, 86, 156),
              ),
              child: Image.asset(
                'assets/images/card/wide_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 5,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: contents(),
          ),
        ],
      ),
    );
  }

  Widget contents() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  const CardWidget(),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(
                        child: _CardPageMenuItem(
                          title: 'Payment',
                          icon: Icons.paid_rounded,
                          center: true,
                          color: Color(0xff0C3C73),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _CardPageMenuItem(
                          title: 'Scan',
                          icon: Icons.qr_code_scanner_rounded,
                          center: true,
                          color: Color(0xff4F0753),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Expanded(
                        child: _CardPageMenuItem(
                          title: 'Deposit',
                          icon: Icons.payment_rounded,
                          center: true,
                          color: Color(0xff0C3C73),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _CardPageMenuItem(
                          title: 'Send',
                          icon: Icons.send_rounded,
                          center: true,
                          color: Color(0xff4F0753),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 44),
                  SizedBox(
                    height: 180,
                    child: HistoryChart.withData(),
                  ),
                  const SizedBox(height: 44),
                  const _CardPageMenuItem(
                    title: 'History',
                    icon: Icons.history_rounded,
                    type: _CardMenuItemType.top,
                    next: true,
                  ),
                  const _CardPageMenuItem(
                    title: 'Card Information',
                    icon: Icons.info_outline_rounded,
                    type: _CardMenuItemType.middle,
                    next: true,
                  ),
                  const _CardPageMenuItem(
                    title: 'Notifications',
                    icon: Icons.notifications_rounded,
                    type: _CardMenuItemType.bottom,
                    next: true,
                  ),
                  const SizedBox(height: 44),
                  const _CardPageMenuItem(
                    title: 'Account',
                    icon: Icons.account_circle_rounded,
                    next: true,
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _CardMenuItemType { top, middle, bottom, only }

extension _CardMenuItemTypeExtenion on _CardMenuItemType {
  BorderRadius borderRadius() {
    const double radius = 12;
    switch (this) {
      case _CardMenuItemType.top:
        return const BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        );
      case _CardMenuItemType.middle:
        return const BorderRadius.all(Radius.circular(0));
      case _CardMenuItemType.bottom:
        return const BorderRadius.only(
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        );
      case _CardMenuItemType.only:
        return BorderRadius.circular(radius);
    }
  }
}

class _CardPageMenuItem extends StatelessWidget {
  const _CardPageMenuItem({
    Key? key,
    required this.title,
    required this.icon,
    this.center = false,
    this.color,
    this.type = _CardMenuItemType.only,
    this.next = false,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final bool center;
  final Color? color;
  final _CardMenuItemType type;
  final bool next;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      title,
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
    );

    return Material(
      color: const Color.fromARGB(255, 239, 245, 252),
      borderRadius: type.borderRadius(),
      child: InkWell(
        onTap: () {},
        borderRadius: type.borderRadius(),
        child: Container(
          height: 52,
          padding: EdgeInsets.symmetric(horizontal: center ? 16 : 24),
          child: Row(
            mainAxisAlignment:
                center ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: center ? 20 : 22,
                color: color,
              ),
              SizedBox(width: center ? 8 : 16),
              if (center) text,
              if (!center) Expanded(child: text),
              if (next)
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: Color(0xff0C3C73),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({Key? key, this.isWide = false}) : super(key: key);

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 1.616,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/card/bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: isWide ? 40 : 24,
                  horizontal: isWide ? 36 : 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.flutter_dash_rounded,
                            color: Colors.white,
                            size: isWide ? 28 : 18,
                          ),
                        ),
                        Text(
                          'Flutter UI Sample Card',
                          style: isWide
                              ? Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.white,
                                  )
                              : Theme.of(context).textTheme.bodyText2?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'XXXX XXXX XXXX XXXX',
                          style: isWide
                              ? Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )
                              : Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FLUTTER USER',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '01 / 25',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.qr_code_rounded,
                          color: Colors.white,
                          size: isWide ? 80 : 60,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryChart extends StatelessWidget {
  final List<charts.Series<OrdinalSales, String>> seriesList;
  final bool animate;

  const HistoryChart(this.seriesList, {Key? key, required this.animate})
      : super(key: key);

  factory HistoryChart.withData() {
    return HistoryChart(
      _createSampleData(),
      animate: true,
    );
  }

  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      OrdinalSales('03/01', 15),
      OrdinalSales('03/02', 60),
      OrdinalSales('03/03', 10),
      OrdinalSales('03/04', 100),
      OrdinalSales('03/05', 40),
      OrdinalSales('03/06', 20),
      OrdinalSales('03/06', 8),
    ];

    const colors = [
      charts.Color(r: 12, g: 60, b: 115),
      charts.Color(r: 12, g: 60, b: 115),
      charts.Color(r: 34, g: 41, b: 107),
      charts.Color(r: 59, g: 19, b: 98),
      charts.Color(r: 69, g: 13, b: 91),
      charts.Color(r: 79, g: 7, b: 83),
      charts.Color(r: 79, g: 7, b: 83),
    ];

    return [
      charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
        labelAccessorFn: (OrdinalSales sales, _) =>
            '\$${sales.sales.toString()}',
        seriesColor: const charts.Color(r: 12, g: 60, b: 115),
        colorFn: (sales, i) {
          if (i == null || i >= colors.length) {
            return const charts.Color(r: 12, g: 60, b: 115);
          }
          return colors[i];
        },
        radiusPxFn: (sales, i) => 12,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      barRendererDecorator: charts.BarLabelDecorator<String>(
        labelPadding: 8,
      ),
      domainAxis: const charts.OrdinalAxisSpec(
        showAxisLine: true,
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11, lineHeight: 1.8),
          lineStyle: charts.LineStyleSpec(
            color: charts.MaterialPalette.transparent,
          ),
          axisLineStyle: charts.LineStyleSpec(
            color: charts.Color(r: 12, g: 60, b: 115, a: 100),
          ),
        ),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        renderSpec: charts.NoneRenderSpec(),
      ),
    );
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class _History {
  final String date;
  final String title;
  final String payment;

  _History(this.date, this.title, this.payment);
}

class _HistoryMock {
  static List<_History> data() {
    List<_History> list = [];

    for (var i = 1; i <= 31; i++) {
      list.add(_History(
        '03/' + i.toString().padLeft(2, '0'),
        'Online Shop',
        '\$${i * 10}',
      ));
    }

    return list;
  }
}
