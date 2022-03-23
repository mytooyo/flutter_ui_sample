///
/// Copyright (c) 2022 mytooyo. All rights reserved.
/// This software is released under the MIT License, see LICENSE.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tweet {
  final DateTime date;
  final String text;

  Tweet({required this.date, required this.text});
}

class TweetMock {
  static final texts = [
    'we asked the engineers if we could pin a DM and they said NO! YOU CAN PIN SIX!',
    'laughing but crying',
    'this Tweet is our Super Bowl commercial',
    'oh good you\'re up, here are a million Tweets to look at',
    'you ever think about Fleets? \nsame.',
    'to everyone procrastinating, you\'ve come to the right place',
    'It’s time to flex those Twitter fingers and take it to the next level 💪\n\nTwitter Blue is now available for subscription in the US, New Zealand, Canada, and Australia on iOS, Android, and web',
    'the timeline is in retrograde',
    'hello literally everyone',
    'apparently it\'s october',
    'we asked the engineers if we could pin a DM and they said NO! YOU CAN PIN SIX!',
    'laughing but crying',
    'this Tweet is our Super Bowl commercial',
    'oh good you\'re up, here are a million Tweets to look at',
    'you ever think about Fleets? \nsame.',
    'to everyone procrastinating, you\'ve come to the right place',
    'It’s time to flex those Twitter fingers and take it to the next level 💪\n\nTwitter Blue is now available for subscription in the US, New Zealand, Canada, and Australia on iOS, Android, and web',
    'the timeline is in retrograde',
    'hello literally everyone',
    'apparently it\'s october',
  ];

  static List<Tweet> data() {
    List<Tweet> list = [];

    for (var i = 0; i < 20; i++) {
      list.add(
        Tweet(
          date: DateTime.now().add(Duration(days: i, minutes: i)),
          text: texts[i],
        ),
      );
    }

    return list;
  }
}

class TwitterWidget extends StatelessWidget {
  const TwitterWidget({
    Key? key,
    required this.tweet,
  }) : super(key: key);

  final Tweet tweet;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                opacity: 0.8,
                child: Text(
                  DateFormat('yyyy/MM/dd HH:mm').format(tweet.date),
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tweet.text,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
