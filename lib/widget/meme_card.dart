// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import '../model/meme.dart';
import 'full_screen_image.dart';

class MemeCard extends StatelessWidget {
  final Meme meme;
  const MemeCard({Key? key, required this.meme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Card header:
            Row(
              children: [
                /// Card header image:
                Icon(
                  Icons.reddit,
                  size: 32,
                  color: Colors.red,
                ),
                SizedBox(width: 8),

                /// Subreddit & author:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meme.subreddit,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(meme.author,
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Spacer(),

                /// "More" button:
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.more_vert_rounded)),
              ],
            ),

            SizedBox(height: 8),

            /// Card meme image:
            InkWell(
              child: Image.network(meme.url, height: 640, width: 480),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullScreenPage(
                    child: Image.network(meme.url),
                  ),
                ),
              ),
            ),

            SizedBox(height: 8),

            /// Title, typically authors' comment
            Text(
              meme.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            SizedBox(height: 8),

            /// Card bottom buttons
            Row(
              children: [
                /// Upvote/Like & Downvote/Dislike button:
                IconButton(onPressed: () {}, icon: Icon(Icons.arrow_upward)),
                Text(meme.ups.toString()),
                IconButton(onPressed: () {}, icon: Icon(Icons.arrow_downward)),

                Spacer(),

                /// "Comment" button:
                MemeCardButton(
                  onTap: () {},
                  icon: Icons.comment,
                  label: 'Comment',
                ),

                Spacer(),

                /// "Share" button:
                MemeCardButton(
                  onTap: () {},
                  icon: Icons.share,
                  label: 'Share',
                ),

                Spacer(),

                /// "Award" button:
                MemeCardButton(
                  onTap: () {},
                  icon: Icons.card_giftcard,
                  label: 'Award',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MemeCardButton extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;
  final String label;
  final double borderRadius;
  const MemeCardButton({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.label,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
