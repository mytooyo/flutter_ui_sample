///
/// Copyright (c) 2022 mytooyo. All rights reserved.
/// This software is released under the MIT License, see LICENSE.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef FansMenuListener = void Function(int index);

class FansMenuController {
  FansMenuController({required this.length});
  final int length;

  static const Duration animateDuration = Duration(milliseconds: 600);

  final _listeners = ObserverList<FansMenuListener>();

  void addListener(FansMenuListener listener) {
    _listeners.add(listener);
  }

  void removeListener(FansMenuListener listener) {
    _listeners.remove(listener);
  }

  void notifyListeners(int index) {
    for (final listener in _listeners) {
      listener.call(index);
    }
  }
}

class FansTabMenu extends StatefulWidget {
  const FansTabMenu({
    Key? key,
    required this.menuController,
    required this.menus,
    required this.textStyle,
    this.selectedIndex,
  }) : super(key: key);

  final FansMenuController menuController;
  final List<String> menus;
  final TextStyle? textStyle;
  final int? selectedIndex;

  @override
  _FansTabMenuState createState() => _FansTabMenuState();
}

class _FansTabMenuState extends State<FansTabMenu>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> moveAnimation;
  late Animation<TextStyle?> selectStyleAnimation;
  late Animation<TextStyle?> unselectStyleAnimation;

  double oneSize = 0;

  late int selectedIndex;
  int? beforeSelected;

  TextStyle? get standardStyle => widget.textStyle;
  TextStyle? get selectStyle => widget.textStyle?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.orange[800],
      );

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: FansMenuController.animateDuration,
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
      }
    });

    selectedIndex = widget.selectedIndex ?? 0;

    selectStyleAnimation = TextStyleTween(
      begin: standardStyle,
      end: selectStyle,
    ).animate(controller);

    unselectStyleAnimation = TextStyleTween(
      begin: selectStyle,
      end: standardStyle,
    ).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        oneSize = constraints.maxWidth / widget.menus.length;
        moveAnimation = controller
            .drive(
              CurveTween(curve: Curves.easeInOutCubic),
            )
            .drive(
              Tween<double>(begin: 0.0, end: oneSize),
            );

        return Material(
          color: Colors.transparent,
          child: SizedBox(
            height: 44,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: controller.isAnimating
                          ? moveAnimation.value
                          : oneSize * selectedIndex,
                      child: Container(
                        height: 3,
                        width: oneSize,
                        decoration: BoxDecoration(
                          color: Colors.orange[700],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Row(
                        children: [
                          for (var i = 0; i < widget.menus.length; i++)
                            _item(i),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _item(int i) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (selectedIndex == i || controller.isAnimating) return;

            moveAnimation = controller
                .drive(
                  CurveTween(curve: Curves.easeInOutCubic),
                )
                .drive(
                  Tween<double>(
                    begin: selectedIndex * oneSize,
                    end: i * oneSize,
                  ),
                );

            beforeSelected = selectedIndex;
            selectedIndex = i;
            controller.forward();
            widget.menuController.notifyListeners(i);
          },
          child: Center(
            child: Text(
              widget.menus[i],
              style: _textStyle(i),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle? _textStyle(int i) {
    if (selectedIndex == i) {
      return controller.isAnimating ? selectStyleAnimation.value : selectStyle;
    }
    if (beforeSelected != null && beforeSelected == i) {
      return controller.isAnimating
          ? unselectStyleAnimation.value
          : standardStyle;
    }
    return standardStyle;
  }
}
