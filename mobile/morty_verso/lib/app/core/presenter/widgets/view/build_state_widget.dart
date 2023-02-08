import 'package:flutter/cupertino.dart';
import 'package:morty_verso/app/core/domain/entities/page_states.dart';

class BuildStateWidget extends StatelessWidget {
  final PageState pageState;
  final Widget widgetSuccessState;
  const BuildStateWidget({
    super.key,
    required this.pageState,
    required this.widgetSuccessState,
  });

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
      return widgetSuccessState;
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildState(pageState);
  }
}
