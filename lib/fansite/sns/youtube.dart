///
/// Copyright (c) 2022 mytooyo. All rights reserved.
/// This software is released under the MIT License, see LICENSE.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Youtube {
  final DateTime date;
  final String title;
  final String thumbnail;

  Youtube({required this.date, required this.title, required this.thumbnail});
}

class YoutubeMock {
  static final List<String> movies = [
    'Traveling to Japan, day1 - exploring Tokyo.',
    'Traveling to Japan, day2 - exploring Kyoto.',
    'Traveling to Japan, day3 - exploring Osaka.',
    'Traveling to Japan, day4 - exploring Nagoya.',
    'Traveling to Japan, day5 - exploring Fukuoka.',
    'Traveling to Japan, day6 - exploring Okinawa.',
    'Traveling to Japan, day7 - exploring Hokkaido.',
    'Traveling to Japan, day8 - exploring Sendai.',
    'Traveling to Japan, day9 - exploring Yokohama.',
    'Traveling to Japan, last - exploring Narita-airport.',
  ];

  static final List<String> urls = [
    'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2388&q=80',
    'https://images.unsplash.com/photo-1503640538573-148065ba4904?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80',
    'https://images.unsplash.com/photo-1571242352061-7611fbafbd42?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2346&q=80',
    'https://images.unsplash.com/photo-1618726413100-a842cc62e332?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1587&q=80',
    'https://images.unsplash.com/photo-1605088298038-2876387a80c1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2342&q=80',
    'https://images.unsplash.com/photo-1610971250019-f677bc1300be?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1587&q=80',
    'https://images.unsplash.com/photo-1598176433730-2aca0907a717?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80',
    'https://images.unsplash.com/photo-1608223019906-a24aa2c60193?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2346&q=80',
    'https://images.unsplash.com/photo-1604674286849-81c0fb34ed4c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2274&q=80',
    'https://images.unsplash.com/photo-1578242042196-386fc24b91b0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1585&q=80',
  ];

  static List<Youtube> data() {
    List<Youtube> list = [];

    for (var i = 0; i < movies.length; i++) {
      list.add(
        Youtube(
          date: DateTime.now().add(Duration(days: i, hours: i)),
          title: movies[i],
          thumbnail: urls[i],
        ),
      );
    }
    return list;
  }
}

class YoutubeWidget extends StatelessWidget {
  const YoutubeWidget({
    Key? key,
    required this.youtube,
    required this.isWide,
  }) : super(key: key);

  final Youtube youtube;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      // color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          height: isWide ? 92 : 68,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: youtube.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Opacity(
                        opacity: 0.8,
                        child: Text(
                          DateFormat('yyyy/MM/dd').format(youtube.date),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        youtube.title,
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
