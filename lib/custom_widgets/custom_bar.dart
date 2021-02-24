import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wasfat_akl/custom_widgets/show_image_dialog.dart';
import 'package:intl/intl.dart' as intl;
import 'package:wasfat_akl/pages/sign_in_page.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/providers/dish_likes_provider.dart';
import 'package:provider/provider.dart';

class CustomBar extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String dishId;
  final double rating;

  const CustomBar({
    Key key,
    this.name,
    this.imageUrl,
    this.rating,
    this.dishId,
  }) : super(key: key);

  @override
  _CustomBarState createState() => _CustomBarState();
}

class _CustomBarState extends State<CustomBar> {
  double _barHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auth = context.watch<Auth>();
    final likes =
        widget.dishId == null ? null : context.watch<DishLikesProvider>();
    return SliverAppBar(
      backgroundColor:
          (_barHeight == (kToolbarHeight + MediaQuery.of(context).padding.top))
              ? Colors.amber[700]
              : (_barHeight < 90)
                  ? Colors.amber[500]
                  : (_barHeight < 120)
                      ? Colors.amber[300]
                      : Colors.white70,
      expandedHeight: size.height * 0.3,
      title: Text(
        (_barHeight == (kToolbarHeight + MediaQuery.of(context).padding.top))
            ? widget.name
            : '',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      pinned: true,
      stretch: true,
      flexibleSpace: InkWell(
        onTap: () async => await showDialog(
            context: context,
            builder: (_) => ShowImageDialog(
                  photoUrl: widget.imageUrl,
                )),
        child: LayoutBuilder(
          builder: (context, constraints) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() => _barHeight = constraints.biggest.height);
            });
            return FlexibleSpaceBar(
              background: Stack(children: [
                Positioned(
                  width: size.width,
                  height: size.height * 0.3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: const Radius.circular(100),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return ImageIcon(
                          AssetImage('assets/transparent_logo.ico'),
                          color: Colors.grey[100],
                          size: 30,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  height: size.height * 0.06,
                  width: size.width,
                  bottom: 0,
                  child: Row(
                    children: [
                      if (widget.dishId != null)
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () async {
                                  if (auth.isLoggedIn)
                                    await likes.likeDish(
                                      widget.dishId,
                                      auth.userId,
                                    );
                                  else
                                    await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const SignInPage()));
                                },
                                child: !likes.dishLikes.contains(auth.userId)
                                    ? const Icon(
                                        Icons.thumb_up,
                                        size: 26,
                                        color: Colors.black26,
                                      )
                                    : const Icon(
                                        Icons.thumb_up,
                                        color: Colors.blue,
                                      ),
                              ),
                            )),
                      if (widget.dishId != null)
                        Expanded(
                          flex: 1,
                          child: Text(
                              intl.NumberFormat.compact()
                                  .format(likes.dishLikes.length),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      Container(
                        width: size.width * 0.7,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: const Radius.circular(30),
                              bottomLeft: const Radius.circular(30)),
                          color: Colors.amber[700],
                        ),
                        child: Row(
                          children: [
                            if (widget.rating != null)
                              Expanded(
                                flex: 1,
                                child: Text(widget.rating.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            if (widget.rating != null)
                              Expanded(
                                flex: 1,
                                child: const Icon(
                                  Icons.star,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                widget.name,
                                textDirection: TextDirection.rtl,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}
