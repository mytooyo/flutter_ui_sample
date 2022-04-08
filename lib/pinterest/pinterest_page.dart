import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'pinterest_signin.dart';

class PinterestPage extends StatefulWidget {
  const PinterestPage({Key? key}) : super(key: key);

  @override
  _PinterestPageState createState() => _PinterestPageState();
}

class _PinterestPageState extends State<PinterestPage>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollController2 = ScrollController();

  late AnimationController animController;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();

    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    opacityAnimation = animController
        .drive(
          CurveTween(curve: Curves.easeInOutCubic),
        )
        .drive(
          Tween<double>(begin: 0.0, end: 1.0),
        );

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        animController.forward();
      } else if (animController.isCompleted) {
        animController.reverse();
      }

      // scrollController.animateTo(
      //   scrollController.position.maxScrollExtent,
      //   duration: const Duration(milliseconds: 300),
      //   curve: Curves.easeInCubic,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  _header(),
                  const SizedBox(height: 160),
                  const FlixibleGlidView(),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: animController,
              builder: (context, child) {
                return Visibility(
                  visible: animController.value != 0,
                  child: FadeTransition(
                    opacity: opacityAnimation,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.black.withOpacity(0.65),
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 24),
                                  child: Text(
                                    '簡単登録でアイデア\nと繋がろう',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 68,
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 32),
                              SingleChildScrollView(
                                controller: scrollController2,
                                child: const PinterestSignin(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    Widget _textLink(String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: InkWell(
          onTap: () {},
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      );
    }

    Widget _textButton(String title, Color bg, Color textColor) {
      return Material(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
              ),
            ),
          ),
          onTap: () {},
        ),
      );
    }

    return Container(
      height: 80,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            'FlutterUI',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Expanded(child: Container()),
          _textLink('概要'),
          _textLink('ビジネス向け'),
          _textLink('プレスルーム'),
          const SizedBox(width: 32),
          _textButton('ログイン', Theme.of(context).primaryColor, Colors.white),
          const SizedBox(width: 20),
          _textButton('無料登録', Colors.grey[300]!, Colors.black87),
        ],
      ),
    );
  }
}

class FlixibleGlidView extends StatefulWidget {
  final double spacing;
  final double runSpacing;

  const FlixibleGlidView({
    Key? key,
    this.spacing = 20,
    this.runSpacing = 20,
  }) : super(key: key);

  @override
  _FlixibleGlidViewState createState() => _FlixibleGlidViewState();
}

class _FlixibleGlidViewState extends State<FlixibleGlidView> {
  final ScrollController scrollController = ScrollController();

  final int rowLength = 7;
  final int centerIndex = 3;
  double cardWidth = 240;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(top: 60),
          physics: const NeverScrollableScrollPhysics(),
          controller: scrollController,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final allPadding = widget.spacing * rowLength;
              final list = colImages.values.toList();
              return Align(
                alignment: Alignment.topCenter,
                child: SizedBox.fromSize(
                  size: Size(
                    MediaQuery.of(context).size.width,
                    cardWidth * 1.6 * 4.2,
                  ),
                  child: OverflowBox(
                    alignment: Alignment.topCenter,
                    minWidth: cardWidth * rowLength + allPadding,
                    maxWidth: cardWidth * rowLength + allPadding,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < list.length; i++)
                            Container(
                              width: cardWidth,
                              margin: EdgeInsets.only(
                                top: _topMargin(i),
                                left: widget.spacing / 2,
                                right: widget.spacing / 2,
                              ),
                              child: _GridColumn(
                                images: list[i],
                                runSpacing: widget.runSpacing,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'FlutterUIで見つけよう',
                      style: Theme.of(context).textTheme.headline2?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: Text(
                        'インテリアのアイデア',
                        style: Theme.of(context).textTheme.headline2?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _PagingControl(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _topMargin(int i) {
    if (i < centerIndex) {
      return cardWidth * 1.6 * 0.3 * i;
    } else if (i == centerIndex) {
      return cardWidth * 1.6 * 0.36 * i;
    }
    return ((rowLength - 1) - i) * cardWidth * 1.6 * 0.3;
  }
}

class _PagingControl extends StatefulWidget {
  const _PagingControl({Key? key}) : super(key: key);

  @override
  _PagingControlState createState() => _PagingControlState();
}

class _PagingControlState extends State<_PagingControl> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < 4; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected == i ? Colors.green : Colors.grey[300],
              ),
            ),
          ),
      ],
    );
  }
}

class _GridColumn extends StatelessWidget {
  _GridColumn({
    Key? key,
    required this.images,
    required this.runSpacing,
  }) : super(key: key);

  final double runSpacing;
  final List<String> images;

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final image in images)
            Padding(
              padding: EdgeInsets.only(bottom: runSpacing),
              child: _GirdItem(
                image: image,
              ),
            ),
        ],
      ),
    );
  }
}

class _GirdItem extends StatelessWidget {
  const _GirdItem({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: AspectRatio(
        aspectRatio: 1 / 1.6,
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

final Map<int, List<String>> colImages = {
  0: [
    'https://images.unsplash.com/photo-1425913397330-cf8af2ff40a1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2274&q=80',
    'https://images.unsplash.com/photo-1516214104703-d870798883c5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80',
    'https://images.unsplash.com/photo-1470115636492-6d2b56f9146d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80',
    'https://images.unsplash.com/photo-1532211387405-12202cb81d7b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80',
  ],
  1: [
    'https://images.unsplash.com/photo-1516214104703-d870798883c5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80',
    'https://images.unsplash.com/photo-1470115636492-6d2b56f9146d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80',
    'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2342&q=80',
    'https://images.unsplash.com/photo-1523437237164-d442d57cc3c9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1603&q=80',
  ],
  2: [
    'https://images.unsplash.com/photo-1621848296279-7751546e9acc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2380&q=80',
    'https://images.unsplash.com/photo-1444930694458-01babf71870c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2163&q=80',
    'https://images.unsplash.com/photo-1471696035578-3d8c78d99684?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80',
    'https://images.unsplash.com/photo-1530236151267-67d11db700e3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2274&q=80',
  ],
  3: [
    'https://images.unsplash.com/photo-1532211387405-12202cb81d7b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80',
    'https://images.unsplash.com/photo-1428992858642-0908d119bd3e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2274&q=80',
    'https://images.unsplash.com/photo-1513010072333-792fcc02ee7d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80',
    'https://images.unsplash.com/photo-1630769608725-6bcabb0afac9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2342&q=80',
  ],
  4: [
    'https://images.unsplash.com/photo-1532274402911-5a369e4c4bb5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80',
    'https://images.unsplash.com/photo-1520690214124-2405c5217036?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80',
    'https://images.unsplash.com/photo-1523437237164-d442d57cc3c9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1603&q=80',
    'https://images.unsplash.com/photo-1532211387405-12202cb81d7b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80',
  ],
  5: [
    'https://images.unsplash.com/photo-1556712691-5c39e0e32a8e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80',
    'https://images.unsplash.com/photo-1464693117936-6dada4d0523b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80',
    'https://images.unsplash.com/photo-1530236151267-67d11db700e3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2274&q=80',
    'https://images.unsplash.com/photo-1523437237164-d442d57cc3c9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1603&q=80',
  ],
  6: [
    'https://images.unsplash.com/photo-1543862475-eb136770ae9b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1635&q=80',
    'https://images.unsplash.com/photo-1437209484568-e63b90a34f8b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2378&q=80',
    'https://images.unsplash.com/photo-1630769608725-6bcabb0afac9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2342&q=80',
    'https://images.unsplash.com/photo-1530236151267-67d11db700e3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2274&q=80',
  ],
};
