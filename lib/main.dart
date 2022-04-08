///
/// Copyright (c) 2022 mytooyo. All rights reserved.
/// This software is released under the MIT License, see LICENSE.
import 'package:flutter/material.dart';
import 'package:flutter_ui_sample/datepicker/datepicker_page.dart';
import 'package:flutter_ui_sample/fansite/fan_sites_page.dart';
import 'package:flutter_ui_sample/payment/card_page.dart';
import 'package:flutter_ui_sample/pinterest/pinterest_page.dart';
import 'package:flutter_ui_sample/signin/signin_page_1.dart';
import 'package:flutter_ui_sample/signin/signin_page_2.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter ui sample',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PinterestPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 900;

        final titleStyle = isWide
            ? Theme.of(context).textTheme.headline2
            : Theme.of(context).textTheme.headline4;

        return Scaffold(
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: isWide ? 40 : 32,
                      ),
                      child: GradientText(
                        'Flutter UI Sample',
                        gradient: const LinearGradient(
                          colors: [
                            Colors.pink,
                            Colors.purple,
                            Colors.deepPurple,
                            Colors.indigo,
                            Colors.blue,
                            Colors.lightBlue,
                            Colors.cyan,
                            Colors.green,
                            Colors.yellow,
                            Colors.orange,
                          ],
                        ),
                        style: GoogleFonts.pacifico(
                          textStyle: titleStyle?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.6,
                          child: Text(
                            'Choose the design you want to see!',
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isWide ? 80 : 44),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        spacing: 32,
                        runSpacing: 20,
                        children: [
                          _item(
                            context,
                            isWide,
                            title: 'Simple Sign in',
                            next: const SignInPage1(),
                          ),
                          _item(
                            context,
                            isWide,
                            title: 'Paging Sign in',
                            next: const SignInPage2(),
                          ),
                          _item(
                            context,
                            isWide,
                            title: 'Card Payment Design',
                            next: const CardPage(),
                          ),
                          _item(
                            context,
                            isWide,
                            title: 'Fan Site',
                            next: const FanSitePage(),
                          ),
                          _item(
                            context,
                            isWide,
                            title: 'Date Picker',
                            next: const DatePickerPage(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _item(
    BuildContext context,
    bool isWide, {
    required String title,
    required Widget next,
    Color? color,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: color ?? const Color.fromARGB(255, 236, 242, 247),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => next));
        },
        child: SizedBox(
          height: isWide ? 200 : 72,
          width: isWide ? 200 : double.infinity,
          child: Center(
            child: Text(
              title,
              style: isWide
                  ? Theme.of(context).textTheme.headline6
                  : Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    Key? key,
    required this.gradient,
    this.style,
  }) : super(key: key);

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
