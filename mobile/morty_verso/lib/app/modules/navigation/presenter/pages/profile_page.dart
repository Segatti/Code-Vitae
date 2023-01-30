// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/entities/page_states.dart';
import 'package:morty_verso/app/core/domain/patterns/padding_pattern.dart';
import 'package:morty_verso/app/core/presenter/widgets/general/text_widget.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';
import '../stores/profile_store.dart';
import '../widgets/profile_favorite.dart';

class ProfilePage extends StatefulWidget {
  final String title;
  const ProfilePage({Key? key, this.title = 'Home'}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileStore store;
  late CupertinoThemeData theme;

  @override
  void initState() {
    store = Modular.get<ProfileStore>();
    _init();
    super.initState();
  }

  Future _init() async {
    await store.startStore();
  }

  Widget buildState(PageState pageState) {
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
      return ProfileFavorite(
        characters: store.favoriteCharactersIdList,
        locations: store.favoriteLocationsIdList,
        episodes: store.favoriteEpisodesIdList,
        generatePDF: () {
          Modular.to.pushNamed('/pdf', arguments: {
            "characters_id": store.favoriteCharactersIdList,
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);

    return BasePageWidget(
      title: 'Profile',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 180,
                height: 180,
                padding: const EdgeInsets.all(PaddingPattern.medium),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: <Color>[
                      Color.fromARGB(127, 236, 154, 31),
                      Color.fromARGB(127, 252, 48, 255),
                    ],
                  ),
                ),
                child: ClipOval(
                  child: Container(
                    padding: const EdgeInsets.all(PaddingPattern.medium),
                    color: theme.barBackgroundColor,
                    child: Image.asset('assets/images/profile.png'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: PaddingPattern.medium),
          const TextWidget(
            text: 'God Morty',
            fontSize: 17,
          ),
          const SizedBox(height: PaddingPattern.medium),
          Observer(builder: (context) {
            return buildState(store.pageState);
          }),
        ],
      ),
    );
  }
}
