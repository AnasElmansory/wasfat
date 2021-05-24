import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/dish_comments_provider.dart';
import 'package:wasfat_akl/providers/expand_comment_provider.dart';
import 'package:wasfat_akl/widgets/ads/banner_wrap_list.dart';
import 'package:wasfat_akl/widgets/dish_widgets/one_comment_widget.dart';

class CommentPage extends StatefulWidget {
  final Dish dish;

  const CommentPage({Key? key, required this.dish}) : super(key: key);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Dish get dish => widget.dish;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    context.read<DishCommentProvider>().listenToDishComments(dish.id);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expandComment = context.watch<ExpandCommentProvider>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('التعليقات'),
          actions: [
            IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.list_view,
                progress: _controller,
              ),
              onPressed: () async {
                if (expandComment.isAllExpanded()) {
                  await _controller.reverse();
                  expandComment.collapseAll();
                } else {
                  await _controller.forward();
                  expandComment.expandAll();
                }
              },
            )
          ],
        ),
        body: BannerWrapList(
          listType: ListType.ListBuilder,
          listBuilder: CommentBuilderWidget(dish: dish),
        ));
  }
}

class CommentBuilderWidget extends StatelessWidget {
  final Dish dish;

  const CommentBuilderWidget({Key? key, required this.dish}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('build CommentBuilderWidget');
    final commentProvider = context.watch<DishCommentProvider>();
    return ListView.separated(
      itemCount: commentProvider.comments.length,
      separatorBuilder: (context, index) {
        return const Divider(endIndent: 25, indent: 40);
      },
      itemBuilder: (context, index) {
        final comment = commentProvider.comments[index];
        return OneCommentWidget(
          comment: comment,
          dish: dish,
          inCommentPage: true,
        );
      },
    );
  }
}
