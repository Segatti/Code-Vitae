import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';
import 'package:printing/printing.dart';

import '../../../../core/domain/entities/page_states.dart';
import '../stores/pdf_preview_store.dart';

class PdfPreviewPage extends StatefulWidget {
  final List<String> charactersIdList;
  const PdfPreviewPage({super.key, required this.charactersIdList});

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
    await store.startStore(widget.charactersIdList);
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
      // TODO: Buscar uma forma de otimizar o PDF (Olhar o Highlight Oversized Images)
      return PdfPreview(
        build: (format) async => store.pdf,
        canDebug: false,
        canChangeOrientation: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
        title: 'PDF Preview',
        padding: EdgeInsets.zero,
        child: Observer(builder: (context) {
          return buildState(store.pageState);
        }));
  }
}
