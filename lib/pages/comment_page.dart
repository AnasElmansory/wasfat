import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/custom_widgets/confirmation_dialog.dart';
import 'package:wasfat_akl/models/comment.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/providers/dish_actions_provider.dart';
import 'package:wasfat_akl/providers/expand_comment_provider.dart';

class CommentPage extends StatefulWidget {
  final Dish dish;

  const CommentPage({Key key, this.dish}) : super(key: key);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comment = context.watch<DishProvider>();
    final expandComment = context.watch<ExpandCommentProvider>();
    final auth = context.watch<Auth>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('التعليقات'),
        actions: [
          IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.view_list,
                progress: _controller,
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
      body: StreamBuilder<List<Comment>>(
        stream: comment.watchCommentByDish(widget.dish),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(
              child: const SpinKitThreeBounce(
                size: 30,
                color: Colors.amber,
              ),
            );
          else if (!snapshot.hasData)
            return const Center(child: const Text('لا توجد تعليقات'));
          else {
            return ListView.separated(
              itemCount: snapshot.data.length,
              separatorBuilder: (context, index) =>
                  const Divider(endIndent: 25, indent: 40),
              itemBuilder: (context, index) {
                final oneComment = snapshot.data[index];

                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                        onLongPress: (auth.userId != oneComment.ownerId)
                            ? null
                            : () async {
                                final result = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => confirmationDialog(
                                          "مسح التعليق",
                                          "هل تريد حقا مسح هذا التعليق",
                                          true,
                                          context,
                                        ));
                                if (result != null && result)
                                  await comment.deleteComment(
                                    commentId: oneComment.id,
                                    userId: auth.userId,
                                    commentOwnerId: oneComment.ownerId,
                                  );
                              },
                        child: ExpansionTileCard(
                          initiallyExpanded: expandComment.isAllExpanded,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (comment.usersRating
                                  .containsKey(oneComment.ownerId))
                                Text(comment.usersRating[oneComment.ownerId]
                                        .toString() ??
                                    ''),
                              if (comment.usersRating
                                  .containsKey(oneComment.ownerId))
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              Text(
                                oneComment.ownerName,
                                style: const TextStyle(
                                  color: const Color(0xFF00695C),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              oneComment.content,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          leading: Text(formatDate(
                              oneComment.commentDate, [hh, ':', nn])),
                          trailing: CircleAvatar(
                            backgroundColor: Colors.teal[800],
                            child: oneComment.ownerPhotoURL == null
                                ? const Icon(
                                    Icons.account_circle,
                                    color: Colors.white,
                                    size: 40,
                                  )
                                : null,
                            backgroundImage: oneComment.ownerPhotoURL != null
                                ? CachedNetworkImageProvider(
                                    oneComment.ownerPhotoURL,
                                  )
                                : null,
                          ),
                          children: [
                            ListTile(
                              leading: Text(
                                formatDate(oneComment.commentDate,
                                    [yyyy, '/', mm, '/', dd]),
                                style: TextStyle(
                                  color: Colors.teal[700],
                                ),
                              ),
                              title: Text(
                                'الاعجاب: ${oneComment.likes}',
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.thumb_up,
                                  color: oneComment.usersLikes
                                          .contains(auth.userId)
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                onPressed: () async {
                                  if (oneComment.usersLikes
                                      .contains(auth.userId))
                                    await comment.dislikeAComment(
                                      oneComment,
                                      auth.userId,
                                    );
                                  else
                                    await comment.likeAComment(
                                      oneComment,
                                      auth.userId,
                                    );
                                },
                              ),
                            ),
                          ],
                        )));
              },
            );
          }
        },
      ),
    );
  }
}
