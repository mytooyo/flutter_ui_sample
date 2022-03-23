///
/// Copyright (c) 2022 mytooyo. All rights reserved.
/// This software is released under the MIT License, see LICENSE.

import 'package:flutter/material.dart';
import 'package:flutter_ui_sample/common/button.dart';
import 'package:flutter_ui_sample/common/text_field.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomTextField(
          hintText: 'Email address',
          icon: Icons.mail_rounded,
        ),
        const SizedBox(height: 40),
        const CustomTextField(
          hintText: 'Password',
          obscureText: true,
          icon: Icons.lock_rounded,
        ),
        const SizedBox(height: 52),
        CustomButton(
          title: 'Sign in',
          onPressed: () {},
          backgroundColor: Colors.orange[700]!,
          foregroundColor: Colors.white,
        ),
      ],
    );
  }
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomTextField(
          hintText: 'Email address',
          icon: Icons.mail_rounded,
        ),
        const SizedBox(height: 32),
        const CustomTextField(
          hintText: 'Password',
          obscureText: true,
          icon: Icons.lock_rounded,
        ),
        const SizedBox(height: 32),
        const CustomTextField(
          hintText: 'Password (confirm)',
          obscureText: true,
          // icon: Icons.lock_rounded,
          isKeepIconSize: true,
        ),
        const SizedBox(height: 68),
        CustomButton(
          title: 'Sign up',
          onPressed: () {},
          backgroundColor: const Color.fromARGB(255, 160, 172, 197),
          foregroundColor: Colors.white,
        ),
      ],
    );
  }
}
