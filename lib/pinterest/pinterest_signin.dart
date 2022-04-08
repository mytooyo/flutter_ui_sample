import 'package:flutter/material.dart';
import 'package:flutter_ui_sample/common/text_field.dart';

class PinterestSignin extends StatelessWidget {
  const PinterestSignin({Key? key}) : super(key: key);

  final double formWidth = 280;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 400,
        height: 840,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 44, horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      'FlutterUIへようこそ !',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'アイデア探しツール | FlutterUI',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: formWidth,
                      child: const CustomTextField(
                        hintText: 'Email address',
                        icon: Icons.mail_rounded,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: formWidth,
                      child: const CustomTextField(
                        hintText: 'Password',
                        obscureText: true,
                        icon: Icons.lock_rounded,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: formWidth,
                      child: const CustomTextField(
                        hintText: 'Age',
                        icon: Icons.person_rounded,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _button(context, '続行'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'または',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    _button(
                      context,
                      'Facebookでログイン',
                      color: Colors.blueAccent[700],
                    ),
                    const SizedBox(height: 16),
                    _button(
                      context,
                      'Googleで続ける',
                      color: Colors.grey[200],
                      textColor: Colors.black87,
                    ),
                    const SizedBox(height: 16),
                    _button(context, 'LINEで続行', color: Colors.green),
                    const SizedBox(height: 16),
                    Text(
                      '続行することでFlutterUIの利用規約に同意し、\nFlutterUIのプライバシーポリシーを読んだものと\nみなされます',
                      style: Theme.of(context).textTheme.caption?.copyWith(
                            height: 1.6,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'アカウントをお持ちの場合: ログイン',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'ビジネスアカウントとして無料で登録する',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Text(
                    '無料のビジネスアカウントを作成する',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _button(BuildContext context, String text,
      {Color? color, Color? textColor}) {
    return Material(
      color: color ?? Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        child: Container(
          width: formWidth,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Stack(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: textColor ?? Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
