import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:wasfat_akl/models/comment.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/providers/dish_comments_provider.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/expand_comment_provider.dart';
import 'package:wasfat_akl/utils/navigation.dart';

class OneCommentWidget extends StatelessWidget {
  final Comment comment;
  final Dish dish;
  final bool inCommentPage;
  const OneCommentWidget({
    Key? key,
    required this.comment,
    required this.dish,
    this.inCommentPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentProvider = context.watch<DishCommentProvider>();
    final expandComment = context.watch<ExpandCommentProvider>();
    final auth = context.watch<Auth>();
    final rating = dish.rating;
    final hasRated = dish.rating.containsKey(comment.ownerId);
    final isLiked = comment.usersLikes.contains(auth.wasfatUser?.uid);
    final isExpanded = expandComment.isExpanded(comment.id, inCommentPage);
    print(comment.id);
    void onTap() {
      final isExpanded = expandComment.isExpanded(comment.id, inCommentPage);
      if (isExpanded)
        expandComment.collapseOneComment(comment.id);
      else
        expandComment.expandOneComment(comment.id);
    }

    return GFListTile(
        onTap: onTap,
        title: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: const Color(0xFF00695C),
                ),
              ),
            ],
          ),
        ),
        subTitle: Align(
          alignment: Alignment.centerRight,
          child: AutoSizeText(
            comment.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
        ),
        avatar: Text(
          formatDate(
            comment.commentDate,
            [hh, ':', nn],
          ),
        ),
        icon: CircleAvatar(
          child: CircularProfileAvatar(
            comment.ownerPhotoURL ?? '',
            initialsText:
                Text('${comment.ownerName.capitalizeFirst?[0] ?? 'User'}'),
            borderColor: Colors.white,
            borderWidth: 2,
          ),
        ),
        description: isExpanded
            ? GFListTile(
                selected: true,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                title: Text(
                  'الاعجاب  :  ${comment.likes}',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                icon: IconButton(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  icon: Icon(
                    Icons.thumb_up,
                    color: isLiked ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () async {
                    if (!await auth.isLoggedIn())
                      return await navigateToSignPageUntil();
                    if (isLiked)
                      await commentProvider.unlikeComment(comment.id);
                    else
                      await commentProvider.likeComment(comment.id);
                  },
                ),
              )
            : Container());
  }
}
