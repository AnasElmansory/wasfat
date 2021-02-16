import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class FavouriteButtonProvider extends ChangeNotifier {
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool _scrollingList = false;
  bool get scrollingList => _scrollingList;
  set scrollingList(bool value) {
    _scrollingList = value;
    notifyListeners();
  }

  void listenToUserScroll() => controller.addListener(() {
        if (controller.position.userScrollDirection == ScrollDirection.forward)
          scrollingList = true;
        if (controller.position.userScrollDirection == ScrollDirection.reverse)
          scrollingList = false;
      });
}
