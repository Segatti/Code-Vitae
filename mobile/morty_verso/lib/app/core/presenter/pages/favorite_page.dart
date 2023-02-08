import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/entities/favorite_item.dart';
import '../../domain/entities/page_states.dart';
import '../stores/favorite_store.dart';
import '../widgets/general/card_favorite.dart';
import '../widgets/view/base_page_widget.dart';

class FavoritePage extends StatefulWidget {
  final String favoriteType;
  const FavoritePage({super.key, required this.favoriteType});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late FavoriteStore store;

  @override
  void initState() {
    store = Modular.get<FavoriteStore>();
    _init();
    super.initState();
  }

  Future _init() async {
    await store.startStore(widget.favoriteType);
  }

  Widget _buildState(PageState pageState) {
    if (pageState is StartState) {
      return const Center(
        child: Text('Starting dimensional portal...'),
      );
    } else if (pageState is LoadingState) {
      return const Center(
        child: RepaintBoundary(child: CupertinoActivityIndicator()),
      );
    } else if (pageState is ErrorState) {
      return const Center(
        child: Text('Error: Problems with the dimensional portal'),
      );
    } else {
      return ListView.builder(
        itemBuilder: (_, index) {
          FavoriteItem favoriteItem = store.favoriteItemsList[index];
          return CardFavorite(
            favoriteItem: favoriteItem,
          );
        },
        itemCount: store.favoriteItemsList.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
      title: "Favorites",
      padding: EdgeInsets.zero,
      child: Observer(builder: (context) {
        return _buildState(store.pageState);
      }),
    );
  }
}
