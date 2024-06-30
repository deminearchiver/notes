import 'package:material/material.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({
    super.key,
    this.bottom,
  });

  final PreferredSizeWidget? bottom;

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _SearchAppBarDelegate(),
    );
  }
}

class _SearchAppBarDelegate extends SliverPersistentHeaderDelegate {
  const _SearchAppBarDelegate({
    this.bottom,
  });

  final PreferredSizeWidget? bottom;

  double get _extent => bottom != null ? bottom!.preferredSize.height + 72 : 72;

  @override
  double get maxExtent => _extent;

  @override
  double get minExtent => _extent;

  @override
  bool shouldRebuild(covariant _SearchAppBarDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    throw UnimplementedError();
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      children: [
        SearchBar(),
        if (bottom != null) bottom!,
      ],
    );
  }
}
