import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class CustomFabProvider extends ChangeNotifier {
  ScrollController? _scrollController;

  ScrollController handlefavouriteFabButton(
    AnimationController animationController,
  ) {
    this._scrollController?.dispose();
    this._scrollController = ScrollController();
    this._scrollController!.addListener(() {
      switch (this._scrollController!.position.userScrollDirection) {
        case ScrollDirection.forward:
          animationController.forward();
          break;
        case ScrollDirection.reverse:
          animationController.reverse();
          break;
        case ScrollDirection.idle:
          break;
      }
    });
    return this._scrollController!;
  }

  @override
  void dispose() {
    this._scrollController?.dispose();
    super.dispose();
  }
}
