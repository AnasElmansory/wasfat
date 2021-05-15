import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:date_format/date_format.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/providers/dish_comments_provider.dart';
import 'package:wasfat_akl/providers/expand_comment_provider.dart';
import 'package:wasfat_akl/utils/navigation.dart';
import 'package:wasfat_akl/widgets/core/confirmation_dialog.dart';

class CommentPage extends StatefulWidget {
  final Dish dish;

  const CommentPage({Key? key, required this.dish}) : super(key: key);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    context.read<DishCommentProvider>().listenToDishComments(widget.dish.id);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = context.watch<DishCommentProvider>();
    final expandComment = context.watch<ExpandCommentProvider>();
    final auth = context.watch<Auth>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('التعليقات'),
        actions: [
          IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.view_list,
                progress: _controller.view,
              ),
              onPressed: () async {
                final expandComment =
                    Provider.of<ExpandCommentProvider>(context, listen: false);
                if (expandComment.isAllExpanded)
                  await _controller.forward();
                else
                  await _controller.reverse();
                expandComment.isAllExpanded = !expandComment.isAllExpanded;
              })
        ],
      ),
      body: ListView.separated(
        itemCount: commentProvider.comments.length,
        separatorBuilder: (context, index) {
          return const Divider(endIndent: 25, indent: 40);
        },
        itemBuilder: (context, index) {
          final comment = commentProvider.comments[index];
          final rating = widget.dish.rating;
          final hasRated = rating.containsKey(comment.ownerId);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onLongPress: (auth.wasfatUser?.uid != comment.ownerId)
                  ? null
                  : () async {
                      if (!await auth.isLoggedIn())
                        return await navigateToSignPage();

                      final result = await showDialog<bool>(
                        context: context,
                        builder: (context) => confirmationDialog(
                          "مسح التعليق",
                          "هل تريد حقا مسح هذا التعليق",
                          true,
                          context,
                        ),
                      );
                      if (result != null && result)
                        await commentProvider.deleteComment(comment.id);
                    },
              child: ExpansionTileCard(
                initiallyExpanded: expandComment.isAllExpanded,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (hasRated) Text(rating[comment.ownerId].toString()),
                    if (hasRated) const Icon(Icons.star, color: Colors.amber),
                    Text(
                      comment.ownerName,
                      style: const TextStyle(color: const Color(0xFF00695C)),
                    ),
                  ],
                ),
                subtitle: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    comment.content,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                leading: Text(
                  formatDate(
                    comment.commentDate,
                    [hh, ':', nn],
                  ),
                ),
                trailing: CircularProfileAvatar(
                  comment.ownerPhotoURL ?? '',
                  initialsText: Text(
                      '${comment.ownerName.capitalizeFirst?[0] ?? 'User'}'),
                  borderColor: Colors.teal,
                  borderWidth: 2,
                ),
                children: [
                  ListTile(
                    leading: Text(
                      formatDate(
                        comment.commentDate,
                        [yyyy, '/', mm, '/', dd],
                      ),
                      style: TextStyle(
                        color: Colors.teal[700],
                      ),
                    ),
                    title: Text(
                      'الاعجاب: ${comment.likes}',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.thumb_up,
                        color: comment.usersLikes.contains(auth.wasfatUser?.uid)
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      onPressed: () async {
                        if (!await auth.isLoggedIn())
                          return await navigateToSignPage();
                        if (comment.usersLikes.contains(auth.wasfatUser?.uid))
                          await commentProvider.unlikeComment(comment.id);
                        else
                          await commentProvider.likeComment(comment.id);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
