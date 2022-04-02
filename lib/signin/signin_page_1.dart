///
/// Copyright (c) 2022 mytooyo. All rights reserved.
/// This software is released under the MIT License, see LICENSE.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ui_sample/common/signin_form.dart';

class SignInPage1 extends StatefulWidget {
  const SignInPage1({Key? key}) : super(key: key);

  static const assetName = 'assets/images/signin_1_bg.png';

  @override
  _SignInPage1State createState() => _SignInPage1State();
}

class _SignInPage1State extends State<SignInPage1> {
  static const double headerSize = 80;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth > 900
              ? const _SignInPage1WideWidget()
              : _SignInPage1Widget();
        },
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    );
  }
}

class _SignInPage1WideWidget extends StatefulWidget {
  const _SignInPage1WideWidget({Key? key}) : super(key: key);

  @override
  _SignInPage1WideWidgetState createState() => _SignInPage1WideWidgetState();
}

class _SignInPage1WideWidgetState extends State<_SignInPage1WideWidget>
    with SingleTickerProviderStateMixin {
  final double maxHeight = 550;
  final double maxWidth = 880;

  late AnimationController controller;
  late Animation<double> moveAnimation;
  late Animation<double> signinFormAnimation;
  late Animation<double> signupFormAnimation;
  late Animation<double> signinIntroductionAnimation;
  late Animation<double> signupIntroductionAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    final curve = controller.drive(CurveTween(curve: Curves.easeOutCubic));
    moveAnimation = curve.drive(Tween<double>(begin: 0.0, end: 1.0));
    signinFormAnimation = curve.drive(Tween<double>(begin: 1.0, end: 0.0));
    signupFormAnimation = curve.drive(Tween<double>(begin: 0.0, end: 1.0));
    signinIntroductionAnimation =
        curve.drive(Tween<double>(begin: 1.0, end: 0.0));
    signupIntroductionAnimation =
        curve.drive(Tween<double>(begin: 0.0, end: 1.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 240),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
              maxWidth: maxWidth,
            ),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Row(
                          children: [
                            Expanded(
                              child: _centerWrapper(
                                Opacity(
                                  opacity: signupFormAnimation.value,
                                  child: const SignUpForm(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: _centerWrapper(
                                Opacity(
                                  opacity: signinFormAnimation.value,
                                  child: const SignInForm(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: (maxWidth * 0.5) * moveAnimation.value,
                        bottom: 0,
                        child: Container(
                          width: maxWidth / 2,
                          color: const Color.fromARGB(255, 160, 172, 197),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  SignInPage1.assetName,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: _signinIntroduction(),
                              ),
                              Positioned.fill(
                                child: _signupIntroduction(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _centerWrapper(Widget child) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: child,
      ),
    );
  }

  Widget _signinIntroduction() {
    return _centerWrapper(
      Visibility(
        visible: controller.value != 1.0,
        child: Opacity(
          opacity: signinIntroductionAnimation.value,
          child: _WideIntroductionWidget(
            msg: 'Welcome Back!',
            description:
                'We have been waiting for you!\nWe hope that using the app will bring some positive emotions into your life. So, sign in and enjoy!',
            button: _textButton(
              'Don\'t have an account?',
              Icons.arrow_forward_rounded,
              () {
                controller.forward();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _signupIntroduction() {
    return _centerWrapper(
      Visibility(
        visible: controller.value != 0.0,
        child: Opacity(
          opacity: signupIntroductionAnimation.value,
          child: _WideIntroductionWidget(
            msg: 'Hello, My friend!',
            description:
                'Want to create an account and try it out?\nIt will surely help you in your life!\nWe hope that using the app will bring some positive emotions into your life. Let\'s get started and create an account!',
            button: _textButton(
              'Do you have an account?',
              Icons.arrow_back_rounded,
              () {
                controller.reverse();
              },
              isIconLeft: true,
            ),
          ),
        ),
      ),
    );
  }

  Widget _textButton(String title, IconData icon, void Function() onTap,
      {bool isIconLeft = false}) {
    Icon iconWidget = Icon(
      icon,
      color: Colors.orange,
      size: 18,
    );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isIconLeft)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: iconWidget,
                ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1,
                    ),
              ),
              if (!isIconLeft)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: iconWidget,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WideIntroductionWidget extends StatelessWidget {
  const _WideIntroductionWidget({
    Key? key,
    required this.msg,
    required this.description,
    required this.button,
  }) : super(key: key);

  final String msg;
  final String description;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              msg,
              style: Theme.of(context).textTheme.headline4?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.92),
                height: 1.9,
              ),
        ),
        const SizedBox(height: 80),
        button,
      ],
    );
  }
}

/// Mobile size
class _SignInPage1Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 240),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                child: Image.asset(
                  SignInPage1.assetName,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.36,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Welcome Back!',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ),
                      const SignInForm(),
                      SizedBox(
                        height: _SignInPage1State.headerSize +
                            MediaQuery.of(context).padding.bottom,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SignUpWidget(
              begin: _SignInPage1State.headerSize +
                  MediaQuery.of(context).padding.bottom,
              end: MediaQuery.of(context).size.height * 0.88,
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({
    Key? key,
    required this.begin,
    required this.end,
  }) : super(key: key);

  final double begin;
  final double end;

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    final curve = CurveTween(curve: Curves.easeOutCubic);
    animation = controller
        .drive(curve)
        .drive(Tween<double>(begin: widget.begin, end: widget.end));
    opacityAnimation =
        controller.drive(curve).drive(Tween<double>(begin: 1.0, end: 0.0));
  }

  @override
  Widget build(BuildContext context) {
    Widget header = Container(
      height: _SignInPage1State.headerSize,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              if (controller.isCompleted) {
                controller.reverse();
              } else {
                controller.forward();
              }
            },
            child: SizedBox(
              height: 52,
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: FadeTransition(
                      opacity: opacityAnimation,
                      child: Opacity(
                        opacity: 0.7,
                        child: Text(
                          'Don\'t have an account?',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[700],
                                  ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) {
                      return Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.value > 0.5
                              ? const Color.fromARGB(255, 160, 172, 197)
                              : Colors.orange[700],
                        ),
                        child: Center(
                          child: Transform.rotate(
                            angle: pi * controller.value,
                            child: Icon(
                              controller.value > 0.5
                                  ? Icons.close_rounded
                                  : Icons.add_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Widget body = Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hello, My friend!',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.orange[700],
                    ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const SignUpForm(),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: animation.value,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              physics: controller.value < 0.1
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              reverse: false,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    header,
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom *
                          (1 - controller.value),
                    ),
                    body,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
