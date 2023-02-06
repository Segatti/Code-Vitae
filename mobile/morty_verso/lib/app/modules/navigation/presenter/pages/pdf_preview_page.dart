import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/build_state_widget.dart';
import 'package:printing/printing.dart';

import '../../../../core/domain/entities/page_states.dart';
import '../stores/pdf_preview_store.dart';

class PdfPreviewPage extends StatefulWidget {
  final List<String> charactersIdList;
  final List<String> locationsIdList;
  final List<String> episodesIdList;
  const PdfPreviewPage({
    super.key,
    required this.charactersIdList,
    required this.locationsIdList,
    required this.episodesIdList,
  });

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  late PdfPreviewStore store;

  @override
  void initState() {
    store = Modular.get<PdfPreviewStore>();
    _init();
    super.initState();
  }

  Future _init() async {
    await store.startStore(
      widget.charactersIdList,
      widget.locationsIdList,
      widget.episodesIdList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
      title: 'PDF Preview',
      padding: EdgeInsets.zero,
      child: Observer(
        builder: (context) {
          return BuildStateWidget(
            pageState: store.pageState,
            widgetSuccessState: PdfPreview(
              build: (format) async => store.pdf,
              canDebug: false,
              canChangeOrientation: false,
            ),
          );
        },
      ),
    );
  }
}
