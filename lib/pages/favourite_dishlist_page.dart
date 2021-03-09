import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/shared_preferences_provider.dart';
import 'package:wasfat_akl/widgets/home_widgets.dart/fav_list.dart';

class FavouriteListPage extends StatelessWidget {
  const FavouriteListPage();
//   @override
//   _FavouriteListPageState createState() => _FavouriteListPageState();
// }

// class _FavouriteListPageState extends State<FavouriteListPage>
//     with TickerProviderStateMixin {
//   AnimationController _controller;

//   @override
//   void initState() {
//     _controller = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 500))
//       ..forward();
//     super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final shared = context.watch<SharedPreferencesProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاطباق المفضلة'),
      ),
      body: (shared.favouriteDishes.isEmpty)
          ? const Center(child: const Text("لا توجد اطباق مفضله"))
          : const FavList(),
    );
  }
}
