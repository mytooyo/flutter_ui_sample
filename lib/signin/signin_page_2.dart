///
/// Copyright (c) 2022 mytooyo. All rights reserved.
/// This software is released under the MIT License, see LICENSE.

import 'package:flutter/material.dart';
import 'package:flutter_ui_sample/common/signin_form.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInPage2 extends StatefulWidget {
  const SignInPage2({Key? key}) : super(key: key);

  static const assetName = 'assets/images/signin_2_bg.png';

  @override
  _SignInPage2State createState() => _SignInPage2State();
}

class _SignInPage2State extends State<SignInPage2> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth > 900
              ? const _SignInPage2WideWidget()
              : const _SignInPage2Widget();
        },
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    );
  }
}

class _SignInPage2WideWidget extends StatefulWidget {
  const _SignInPage2WideWidget({Key? key}) : super(key: key);

  @override
  _SignInPage2WideWidgetState createState() => _SignInPage2WideWidgetState();
}

class _SignInPage2WideWidgetState extends State<_SignInPage2WideWidget>
    with TickerProviderStateMixin {
  late AnimationController signInController;
  late AnimationController signUpController;

  late Animation<double> signInOpacityAnim;
  late Animation<double> signUpOpacityAnim;

  @override
  void initState() {
    super.initState();

    signInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    signUpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    const delay = Duration(milliseconds: 100);

    signInController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future<void>.delayed(delay).then((_) => signUpController.forward());
      }
    });

    signUpController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        Future<void>.delayed(delay).then((_) => signInController.reverse());
      }
    });

    final curve = CurveTween(curve: Curves.easeInOutCubic);
    signInOpacityAnim = signInController
        .drive(curve)
        .drive(Tween<double>(begin: 1.0, end: 0.0));
    signUpOpacityAnim = signUpController
        .drive(curve)
        .drive(Tween<double>(begin: 0.0, end: 1.0));
  }

  @override
  Widget build(BuildContext context) {
    final curve = CurveTween(curve: Curves.easeInOutCubic);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Image.asset(
                      SignInPage2.assetName,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                _positionWrapper(
                  AnimatedBuilder(
                    animation: signInController,
                    builder: (context, child) {
                      return SizeTransition(
                        sizeFactor: signInController
                            .drive(curve)
                            .drive(Tween<double>(begin: 1.0, end: 0.0)),
                        axis: Axis.horizontal,
                        axisAlignment: -1.0,
                        child: _introductionWrapper(_signinIntroduction()),
                      );
                    },
                  ),
                ),
                _positionWrapper(
                  AnimatedBuilder(
                    animation: signUpController,
                    builder: (context, child) {
                      return SizeTransition(
                        sizeFactor: signUpController
                            .drive(curve)
                            .drive(Tween<double>(begin: 0.0, end: 1.0)),
                        axis: Axis.horizontal,
                        axisAlignment: -1.0,
                        child: _introductionWrapper(_signupIntroduction()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 360,
            height: double.infinity,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              body: SafeArea(
                child: Stack(
                  children: [
                    _positionWrapper(
                      AnimatedBuilder(
                        animation: signInController,
                        builder: (context, child) {
                          return Visibility(
                            visible: signInController.value != 1.0,
                            child: Opacity(
                              opacity: signInOpacityAnim.value,
                              child: _formWrapper(const SignInForm()),
                            ),
                          );
                        },
                      ),
                    ),
                    _positionWrapper(
                      AnimatedBuilder(
                        animation: signUpController,
                        builder: (context, child) {
                          return Visibility(
                            visible: signUpController.value != 0.0,
                            child: Opacity(
                              opacity: signUpOpacityAnim.value,
                              child: _formWrapper(const SignUpForm()),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _introductionWrapper(Widget child) {
    return Align(
      alignment: Alignment.centerLeft,
      child: child,
    );
  }

  Widget _positionWrapper(Widget child) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.centerLeft,
        child: child,
      ),
    );
  }

  Widget _formWrapper(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [child],
      ),
    );
  }

  Widget _signinIntroduction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: _WideIntroductionWidget(
        msg: 'Welcome Back!',
        description:
            'We have been waiting for you!\nWe hope that using the app will bring some positive emotions into your life. So, sign in and enjoy!',
        button: _textButton(
          'Don\'t have an account?',
          Icons.arrow_forward_rounded,
          () {
            signInController.forward();
          },
        ),
      ),
    );
  }

  Widget _signupIntroduction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: _WideIntroductionWidget(
        msg: 'Hello, My friend!',
        description:
            'Want to create an account and try it out?\nIt will surely help you in your life!\nWe hope that using the app will bring some positive emotions into your life. Let\'s get started and create an account!',
        button: _textButton(
          'Do you have an account?',
          Icons.arrow_forward_rounded,
          () {
            signUpController.reverse();
          },
        ),
      ),
    );
  }

  Widget _textButton(
    String title,
    IconData icon,
    void Function() onTap,
  ) {
    Icon iconWidget = Icon(
      icon,
      color: Colors.orange,
      size: 18,
    );
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.orange[700],
                      height: 1,
                    ),
              ),
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
              style: GoogleFonts.pacifico(
                textStyle: Theme.of(context).textTheme.headline2?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Text(
          description,
          style: Theme.of(context).textTheme.headline6?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.92),
                height: 1.9,
              ),
        ),
        const SizedBox(height: 100),
        button,
      ],
    );
  }
}

class _SignInPage2Widget extends StatefulWidget {
  const _SignInPage2Widget({Key? key}) : super(key: key);

  @override
  _SignInPage2WidgetState createState() => _SignInPage2WidgetState();
}

class _SignInPage2WidgetState extends State<_SignInPage2Widget> {
  final bcColor = const Color.fromARGB(255, 234, 234, 240);

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bcColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: SizedBox(
              child: Image.asset(
                SignInPage2.assetName,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Expanded(
                      child: _page(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _page() {
    return PageView(
      controller: pageController,
      children: [
        _PagingWidget(
          title: 'Welcome Back!',
          description:
              'We have been waiting for you!\nWe hope that using the app will bring some positive emotions into your life. So, sign in and enjoy!',
          formWidget: const SignInForm(),
          buttonText: 'Don\'t have an account?',
          buttonIcon: Icons.arrow_forward_rounded,
          onTap: () {
            pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
            );
          },
        ),
        _PagingWidget(
          title: 'Hello, My friend!',
          description:
              'It will surely help you in your life!\nWe hope that using the app will bring some positive emotions into your life. Let\'s get started and create an account!',
          formWidget: const SignUpForm(),
          buttonText: 'Do you have an account?',
          buttonIcon: Icons.arrow_back_rounded,
          isButtonIconLeft: true,
          onTap: () {
            pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
            );
          },
        ),
      ],
    );
  }
}

class _PagingWidget extends StatelessWidget {
  const _PagingWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.formWidget,
    required this.buttonText,
    required this.buttonIcon,
    this.isButtonIconLeft = false,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final String description;
  final Widget formWidget;
  final String buttonText;
  final IconData buttonIcon;
  final bool isButtonIconLeft;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    Icon iconWidget = Icon(
      buttonIcon,
      color: Colors.orange,
      size: 18,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        title,
                        style: GoogleFonts.pacifico(
                          textStyle:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Opacity(
                        opacity: 0.88,
                        child: Text(
                          description,
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    height: 1.6,
                                    color: Colors.white,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 44, horizontal: 16),
                        child: Column(
                          children: [
                            formWidget,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isButtonIconLeft)
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: iconWidget,
                              ),
                            Text(
                              buttonText,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                            ),
                            if (!isButtonIconLeft)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: iconWidget,
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
