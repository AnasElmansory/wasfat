import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wasfat_akl/models/comment.dart';
import 'package:wasfat_akl/pages/sign_in_page.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/providers/dish_actions_provider.dart';
import 'package:provider/provider.dart';

class OneCommentWidget extends StatelessWidget {
  final Comment comment;

  const OneCommentWidget({Key key, this.comment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dishProvider = context.watch<DishProvider>();
    final auth = context.watch<Auth>();
    return ExpansionTileCard(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (dishProvider.usersRating.containsKey(comment.ownerId))
              Text(dishProvider.usersRating[comment.ownerId].toString() ?? ''),
            if (dishProvider.usersRating.containsKey(comment.ownerId))
              const Icon(
                Icons.star,
                color: Colors.amber,
              ),
            Text(
              comment.ownerName,
              style: const TextStyle(
                color: const Color(0xFF00695C),
              ),
            ),
          ],
        ),
        subtitle: Text(
          comment.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textDirection: TextDirection.rtl,
        ),
        leading: Text(formatDate(
          comment.commentDate,
          [hh, ':', nn],
        )),
        trailing: CircleAvatar(
          backgroundColor: const Color(0xFF00695C),
          child: comment.ownerPhotoURL == null
              ? const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 40,
                )
              : null,
          backgroundImage: comment.ownerPhotoURL != null
              ? CachedNetworkImageProvider(
                  comment.ownerPhotoURL,
                )
              : null,
        ),
        children: [
          ListTile(
            title: Text(
              'الاعجاب: ${comment.likes}',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            trailing: IconButton(
              padding: const EdgeInsets.symmetric(vertical: 2),
              icon: Icon(
                Icons.thumb_up,
                color: comment.usersLikes.contains(auth.userId)
                    ? Colors.blue
                    : Colors.grey,
              ),
              onPressed: () async {
                final alreadyLiked = comment.usersLikes.contains(auth.userId);
                if (auth.userId == null)
                  return Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => SignInPage()));
                alreadyLiked
                    ? await dishProvider.dislikeAComment(
                        comment,
                        auth.userId,
                      )
                    : await dishProvider.likeAComment(
                        comment,
                        auth.userId,
                      );
              },
            ),
          ),
        ]);
  }
}
