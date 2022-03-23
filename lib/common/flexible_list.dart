///
/// Copyright (c) 2022 mytooyo. All rights reserved.
/// This software is released under the MIT License, see LICENSE.

import 'package:flutter/material.dart';

class FlexibleListView extends StatelessWidget {
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final EdgeInsets padding;
  final bool shrinkWrap;
  final List<FlexibleObjectItem> Function(BuildContext context) builder;

  const FlexibleListView({
    Key? key,
    this.scrollController,
    this.physics,
    this.padding = const EdgeInsets.all(0),
    this.shrinkWrap = false,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: CustomScrollView(
        controller: scrollController,
        physics: physics,
        shrinkWrap: shrinkWrap,
        slivers: [
          for (final item in builder(context)) item.objects(context),
        ],
      ),
    );
  }
}

enum FlexibleObjectItemType { appbar, list, grid, single }

abstract class FlexibleObjectItem<T> {
  final FlexibleObjectItemType type;

  FlexibleObjectItem({required this.type});

  /// Get object data
  T objects(BuildContext context);

  /// Get list item header
  Widget? get header => null;

  /// Delegate
  SliverChildDelegate delegate(BuildContext context);
}

abstract class FlexibleAppBarObject extends FlexibleObjectItem<SliverAppBar> {
  /// AppBar constructor
  FlexibleAppBarObject() : super(type: FlexibleObjectItemType.appbar);

  @override
  SliverAppBar objects(BuildContext context) => SliverAppBar(
        backgroundColor: backgroundColor,
        expandedHeight: expandedHeight,
        flexibleSpace: flexibleSpace(context),
        automaticallyImplyLeading: automaticallyImplyLeading,
        leading: leading(context),
        pinned: true,
        stretch: stretch,
        collapsedHeight: collapsedHeight,
        toolbarHeight: collapsedHeight ?? kToolbarHeight,
        elevation: 0,
      );

  Color get backgroundColor => Colors.transparent;
  double? get expandedHeight => null;
  bool get stretch => true;
  double? get collapsedHeight => null;

  Widget flexibleSpace(BuildContext context);

  bool get automaticallyImplyLeading => false;
  Widget? leading(BuildContext context) => null;

  /// Delegate
  @override
  SliverChildDelegate delegate(BuildContext context) =>
      SliverChildListDelegate([]);
}

abstract class FlexibleListObject extends FlexibleObjectItem<SliverList> {
  /// List view constructor
  FlexibleListObject() : super(type: FlexibleObjectItemType.list);

  @override
  SliverList objects(BuildContext context) => SliverList(
        delegate: delegate(context),
      );

  @override
  SliverChildDelegate delegate(BuildContext context) => SliverChildListDelegate(
        [
          if (header != null) header!,
          ...data(context),
        ],
      );

  List<Widget> data(BuildContext context);
}

abstract class FlexibleGridObject extends FlexibleObjectItem<SliverList> {
  /// List view constructor
  FlexibleGridObject() : super(type: FlexibleObjectItemType.grid);

  /// Grid delegate
  SliverGridDelegate gridDelegate(BuildContext context);

  @override
  SliverList objects(BuildContext context) => SliverList(
        delegate: delegate(context),
      );

  @override
  SliverChildDelegate delegate(BuildContext context) => SliverChildListDelegate(
        [
          if (header != null) header!,
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: gridDelegate(context),
            children: data(context),
          ),
        ],
      );

  List<Widget> data(BuildContext context);
}

abstract class FlexibleSingleObject
    extends FlexibleObjectItem<SliverMultiBoxAdaptorWidget> {
  /// List view constructor
  FlexibleSingleObject() : super(type: FlexibleObjectItemType.single);

  double? get itemExtent => null;

  /// Delegate
  @override
  SliverChildDelegate delegate(BuildContext context) => SliverChildListDelegate(
        [
          if (header != null) header!,
          object(context),
        ],
      );

  @override
  SliverMultiBoxAdaptorWidget objects(BuildContext context) =>
      itemExtent != null
          ? SliverFixedExtentList(
              delegate: delegate(context), itemExtent: itemExtent!)
          : SliverList(
              delegate: delegate(context),
            );

  Widget object(BuildContext context);
}

class FlexibleEmptyObject extends FlexibleSingleObject {
  final double size;
  FlexibleEmptyObject({this.size = 60});

  @override
  Widget object(BuildContext context) {
    return SizedBox(height: size);
  }
}

abstract class SelectCardSingleFlexibleObject extends FlexibleSingleObject {
  String get title;
  IconData? get icon => null;
  Color? get itemColor => null;
  void callback(BuildContext context);

  @override
  Widget object(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => callback(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: itemColor,
                      ),
                ),
              ),
              Opacity(
                opacity: 0.4,
                child: Icon(
                  icon ?? Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: itemColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
