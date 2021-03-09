import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wasfat_akl/models/comment.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/providers/dish_actions_provider.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/pages/comment_page.dart';
import 'package:wasfat_akl/providers/expand_comment_provider.dart';
import 'package:wasfat_akl/providers/shared_preferences_provider.dart';
import 'package:wasfat_akl/widgets/core/confirmation_dialog.dart';
import 'package:wasfat_akl/widgets/dish_custom_bar.dart';
import 'package:wasfat_akl/widgets/core/divider_widget.dart';
import 'package:wasfat_akl/widgets/one_comment_widget.dart';
import 'package:wasfat_akl/widgets/show_image_dialog.dart';

class OneDishPage extends StatefulWidget {
  final Dish dish;

  const OneDishPage({Key key, this.dish}) : super(key: key);

  @override
  _OneDishPageState createState() => _OneDishPageState();
}

class _OneDishPageState extends State<OneDishPage>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1,
    );
    context.read<DishProvider>().listenToDish(widget.dish.id);
    context.read<SharedPreferencesProvider>().setLastVisitedDish(widget.dish);
    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        // Scrolling up - forward the animation (value goes to 1)
        case ScrollDirection.forward:
          _animationController.forward();
          break;
        // Scrolling down - reverse the animation (value goes to 0)
        case ScrollDirection.reverse:
          _animationController.reverse();
          break;
        // Idle - keep FAB visibility unchanged
        case ScrollDirection.idle:
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scrollController?.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auth = context.watch<Auth>();
    final dishProvider = context.watch<DishProvider>();
    final shared = context.watch<SharedPreferencesProvider>();
    return Scaffold(
      body: StreamBuilder<List<Comment>>(
        stream: dishProvider.watchFirstTwoComments(widget.dish.id),
        builder: (context, snapshot) {
          return Stack(
            children: [
              Positioned.fill(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    DishCustomBar(dish: widget.dish),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8),
                          margin: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            widget.dish.subtitle,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            margin: const EdgeInsets.all(12.0),
                            width: size.width,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Html(
                              data: widget.dish.dishDescription,
                              onImageTap: (imageUrl) async {
                                await showDialog(
                                    context: context,
                                    builder: (context) => ShowImageDialog(
                                          photoUrl: imageUrl,
                                        ));
                              },
                              style: {
                                "h2": Style(
                                    textAlign: TextAlign.right,
                                    direction: TextDirection.rtl,
                                    color: Colors.red),
                                "p": Style(
                                  direction: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                ),
                              },
                            )),
                        const DividerWidget("أضف تقييم", 2.0, 0),
                        Container(
                          width: size.width * 0.8,
                          height: size.height * .2,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          margin: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'أضف تعليق',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            maxLines: null,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(12.0),
                          width: size.width,
                          child: Column(children: [
                            RatingBar.builder(
                              initialRating:
                                  dishProvider.rating?.toDouble() ?? 5,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: const Color(0xFFFFA000),
                              ),
                              onRatingUpdate: (rating) =>
                                  dishProvider.rating = rating.floor(),
                            ),
                            const SizedBox(height: 20.0),
                            MaterialButton(
                                onPressed: () async => await dishProvider
                                    .onSendPressed(
                                      context,
                                      _controller.text,
                                      auth,
                                    )
                                    .then((_) => _controller.clear()),
                                minWidth: size.width * 0.7,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 2.0,
                                textColor: Colors.white,
                                color: Colors.amber[700],
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('ارسال',
                                        style: const TextStyle(fontSize: 18)),
                                    const SizedBox(width: 20.0),
                                    const Icon(Icons.add_comment_rounded),
                                  ],
                                ))
                          ]),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? Center(
                                  child: SpinKitThreeBounce(
                                    color: Colors.amber[700],
                                    size: 30,
                                  ),
                                )
                              : (snapshot.data.isEmpty)
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: const Text(
                                        'لا توجد تعليقات',
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : Column(children: [
                                      InkWell(
                                        onLongPress: (auth.userId !=
                                                snapshot.data.first.ownerId)
                                            ? null
                                            : () async {
                                                final result =
                                                    await showDialog<bool>(
                                                        context: context,
                                                        builder: (context) =>
                                                            confirmationDialog(
                                                              "مسح التعليق",
                                                              "هل تريد حقا مسح هذا التعليق",
                                                              true,
                                                              context,
                                                            ));
                                                if (result != null && result)
                                                  await dishProvider
                                                      .deleteComment(
                                                    commentId:
                                                        snapshot.data.first.id,
                                                    userId: auth.userId,
                                                    commentOwnerId: snapshot
                                                        .data.first.ownerId,
                                                  );
                                              },
                                        child: OneCommentWidget(
                                          comment: snapshot.data.first,
                                        ),
                                      ),
                                      if (snapshot.data.length > 1)
                                        InkWell(
                                          onLongPress: (auth.userId !=
                                                  snapshot.data.last.ownerId)
                                              ? null
                                              : () async {
                                                  final result =
                                                      await showDialog<bool>(
                                                          context: context,
                                                          builder: (context) =>
                                                              confirmationDialog(
                                                                "مسح التعليق",
                                                                "هل تريد حقا مسح هذا التعليق",
                                                                true,
                                                                context,
                                                              ));
                                                  if (result != null && result)
                                                    await dishProvider
                                                        .deleteComment(
                                                      commentId:
                                                          snapshot.data.last.id,
                                                      userId: auth.userId,
                                                      commentOwnerId: snapshot
                                                          .data.last.ownerId,
                                                    );
                                                },
                                          child: OneCommentWidget(
                                            comment: snapshot.data.last,
                                          ),
                                        ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        ChangeNotifierProvider(
                                                          create: (context) =>
                                                              ExpandCommentProvider(),
                                                          child: CommentPage(
                                                            dish: widget.dish,
                                                          ),
                                                        )));
                                          },
                                          child: const Text(
                                            'شاهد كل التعليقات',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: const Color(0xFF00796B),
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: 18),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      )
                                    ]),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                right: 0,
                child: FadeTransition(
                  opacity: _animationController,
                  child: RotationTransition(
                    turns: _animationController,
                    child: MaterialButton(
                      padding: const EdgeInsets.all(12),
                      child: shared.favouriteDishes.contains(widget.dish)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 30,
                            )
                          : const Icon(
                              Icons.favorite,
                              color: Colors.white70,
                              size: 30,
                            ),
                      onPressed: () async =>
                          shared.favouriteDishes.contains(widget.dish)
                              ? await shared.removeFavouriteDish(widget.dish)
                              : await shared.addFavouriteDish(widget.dish),
                      color: const Color(0xFFFF8F00),
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
