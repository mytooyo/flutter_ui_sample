///
/// Copyright (c) 2022 mytooyo. All rights reserved.
/// This software is released under the MIT License, see LICENSE.
///
/// Ptoho: Photo by <a href="https://unsplash.com/@zvandrei?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Andrey Zvyagintsev</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
/// Photo by <a href="https://unsplash.com/@timothyeberly?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Timothy Eberly</a> on <a href="https://unsplash.com/s/photos/sun?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
///

import 'package:flutter/material.dart';
import 'package:flutter_ui_sample/common/flexible_list.dart';
import 'package:flutter_ui_sample/common/tab_menu.dart';
import 'package:flutter_ui_sample/fansite/sns/instagram.dart';
import 'package:flutter_ui_sample/fansite/sns/twitter.dart';
import 'package:flutter_ui_sample/fansite/sns/youtube.dart';

class FanSitePage extends StatelessWidget {
  const FanSitePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth > 900
              ? const FanSiteMainWidePage()
              : const FanSiteMainPage();
        },
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    );
  }
}

class FanSiteMainWidePage extends StatefulWidget {
  const FanSiteMainWidePage({Key? key}) : super(key: key);

  @override
  _FanSiteMainWidePageState createState() => _FanSiteMainWidePageState();
}

class _FanSiteMainWidePageState extends State<FanSiteMainWidePage> {
  final FansMenuController menuController = FansMenuController(length: 3);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Image.asset(
                          'assets/images/fans/fans_bg_1.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: constraints.maxWidth * 3 / 4 - 180),
                          SizedBox(
                            height: 220,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 120,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(32),
                                        topRight: Radius.circular(32),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 40,
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.asset(
                                        'assets/images/fans/fans.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Flutter Creator',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 32),
                                Opacity(
                                  opacity: 0.8,
                                  child: Text(
                                    'Photographer, Model @fluuter.dev, Inc',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'I work as a photographer and model. I post the images I take on instagram. I also upload videos to youtube from time to time.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                        height: 1.6,
                                      ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Container(
                    height: 52,
                    color: Colors.white,
                    child: FansTabMenu(
                      menus: const ['Instagram', 'Youtube', 'Twitter'],
                      menuController: menuController,
                      textStyle: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: const Color.fromARGB(255, 241, 242, 245),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 80, left: 16, right: 16),
                        child: _FansSNSContentsWidget(
                          menuController,
                          true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FanSiteMainPage extends StatefulWidget {
  const FanSiteMainPage({Key? key}) : super(key: key);

  @override
  _FanSiteMainPageState createState() => _FanSiteMainPageState();
}

class _FanSiteMainPageState extends State<FanSiteMainPage>
    with TickerProviderStateMixin {
  final FansMenuController menuController = FansMenuController(length: 3);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 241, 242, 245),
      body: FlexibleListView(
        physics: const ClampingScrollPhysics(),
        builder: (context) {
          return [
            _TopImageBar(
              height: MediaQuery.of(context).size.width * 3 / 4 -
                  MediaQuery.of(context).padding.top,
            ),
            FansDescription(),
            FansSNSHeader(menuController),
            FansSNSContents(menuController),
            FlexibleEmptyObject(size: 100),
          ];
        },
      ),
    );
  }
}

class _TopImageBar extends FlexibleAppBarObject {
  final double height;
  _TopImageBar({required this.height});

  @override
  double? get expandedHeight => height;

  @override
  double? get collapsedHeight => 160;

  @override
  bool get stretch => true;

  @override
  Widget flexibleSpace(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fans/fans_bg_1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 128,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(
                        'assets/images/fans/fans.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    'Flutter Creator',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FansDescription extends _FansContentsObject {
  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Opacity(
          opacity: 0.8,
          child: Text(
            'Photographer, Model @fluuter.dev, Inc',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'I work as a photographer and model. I post the images I take on instagram. I also upload videos to youtube from time to time.',
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                height: 1.6,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class FansSNSHeader extends FlexibleAppBarObject {
  FansSNSHeader(this.menuController);
  final FansMenuController menuController;
  final double height = 44;

  @override
  double? get expandedHeight => kToolbarHeight - 40;
  @override
  double? get collapsedHeight => kToolbarHeight - 40;

  @override
  bool get stretch => false;

  @override
  Widget flexibleSpace(BuildContext context) {
    return Container(
      height: height,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FansTabMenu(
        menus: const ['Instagram', 'Youtube', 'Twitter'],
        menuController: menuController,
        textStyle: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}

class FansSNSContents extends _FansContentsObject {
  FansSNSContents(this.menuController);
  final FansMenuController menuController;

  @override
  bool get isWhite => false;

  @override
  Widget body(BuildContext context) {
    return _FansSNSContentsWidget(menuController, false);
  }
}

class _FansSNSContentsWidget extends StatefulWidget {
  const _FansSNSContentsWidget(this.menuController, this.isWide, {Key? key})
      : super(key: key);

  final bool isWide;
  final FansMenuController menuController;

  @override
  _FansSNSContentsWidgetState createState() => _FansSNSContentsWidgetState();
}

class _FansSNSContentsWidgetState extends State<_FansSNSContentsWidget>
    with TickerProviderStateMixin {
  List<AnimationController> animations = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.menuController.length; i++) {
      final c = AnimationController(
        vsync: this,
        duration: FansMenuController.animateDuration,
      );
      animations.add(c);
    }

    widget.menuController.addListener((index) {
      for (var i = 0; i < animations.length; i++) {
        if (i == index) {
          Future<void>.delayed(FansMenuController.animateDuration -
                  const Duration(milliseconds: 200))
              .then((_) {
            animations[i].forward();
          });
        } else {
          if (animations[i].isCompleted || animations[i].isAnimating) {
            animations[i].reverse();
          }
        }
      }
    });
    animations[0].forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var i = 0; i < animations.length; i++)
          _animationWrapper(animations[i], childWidget(i)),
      ],
    );
  }

  Widget childWidget(int index) {
    if (index == 0) {
      return _instagram();
    } else if (index == 1) {
      return _youtube();
    }
    return _twitter();
  }

  Widget _animationWrapper(AnimationController controller, Widget child) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _child) {
        return Visibility(
          visible: controller.value != 0.0,
          child: FadeTransition(
            opacity: controller
                .drive(
                  CurveTween(curve: Curves.easeInOutCubic),
                )
                .drive(
                  Tween<double>(begin: 0.0, end: 1),
                ),
            child: _child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _instagram() {
    final list = InstagramMock.data();
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      shrinkWrap: true,
      children: [
        for (final insta in list) InstagramWidget(insta: insta),
      ],
    );
  }

  Widget _youtube() {
    final list = YoutubeMock.data();
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        for (final youtube in list)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: YoutubeWidget(
              youtube: youtube,
              isWide: widget.isWide,
            ),
          ),
      ],
    );
  }

  Widget _twitter() {
    final list = TweetMock.data();
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        for (final tweet in list)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TwitterWidget(tweet: tweet),
          ),
      ],
    );
  }
}

abstract class _FansContentsObject extends FlexibleSingleObject {
  @override
  Widget object(BuildContext context) {
    return Container(
      color: isWhite ? Colors.white : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: body(context),
    );
  }

  bool get isWhite => true;

  Widget body(BuildContext context);

  Widget contentsHeader(BuildContext context, String title) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
