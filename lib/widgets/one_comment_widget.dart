import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:date_format/date_format.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wasfat_akl/models/comment.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/providers/dish_comments_provider.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/utils/navigation.dart';

class OneCommentWidget extends StatelessWidget {
  final Comment comment;
  final Dish dish;
  const OneCommentWidget({Key? key, required this.comment, required this.dish})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final commentProvider = context.watch<DishCommentProvider>();
    final auth = context.watch<Auth>();
    final rating = dish.rating;
    final hasRated = dish.rating.containsKey(comment.ownerId);
    final isLiked = comment.usersLikes.contains(auth.wasfatUser?.uid);
    return ExpansionTileCard(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (hasRated) Text(rating[comment.ownerId].toString()),
            if (hasRated)
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
        leading: Text(
          formatDate(
            comment.commentDate,
            [hh, ':', nn],
          ),
        ),
        trailing: CircularProfileAvatar(
          comment.ownerPhotoURL ?? '',
          initialsText:
              Text('${comment.ownerName.capitalizeFirst?[0] ?? 'User'}'),
          borderColor: Colors.teal,
          borderWidth: 2,
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
                color: isLiked ? Colors.blue : Colors.grey,
              ),
              onPressed: () async {
                if (!await auth.isLoggedIn()) return await navigateToSignPage();
                if (isLiked)
                  await commentProvider.unlikeComment(comment.id);
                else
                  await commentProvider.likeComment(comment.id);
              },
            ),
          ),
        ]);
  }
}
