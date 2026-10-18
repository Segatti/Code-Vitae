import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/constants/terms_of_use_catalog.dart';

class TermsOfUsePage extends StatefulWidget {
  const TermsOfUsePage({super.key, required this.version});

  final String version;

  @override
  State<TermsOfUsePage> createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> {
  static const _textColor = Color(0xFF1A1A1A);
  static const _primaryColor = Color(0xFF2C29A3);
  static const _accentColor = Color(0xFFDF924B);

  String? _content;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final path = TermsOfUseCatalog.assetPathForVersion(widget.version);
    try {
      final text = await rootBundle.loadString(path);
      if (!mounted) return;
      setState(() {
        _content = text;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Não foi possível carregar os Termos de Uso.';
      });
    }
  }

  MarkdownStyleSheet _styleSheet() {
    TextStyle rubik({
      double fontSize = 14,
      FontWeight fontWeight = FontWeight.w400,
      Color? color,
      double? height,
    }) {
      return GoogleFonts.rubik(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? _textColor,
        height: height ?? 1.45,
      );
    }

    return MarkdownStyleSheet(
      h1: rubik(fontSize: 22, fontWeight: FontWeight.w600, color: _primaryColor),
      h1Padding: const EdgeInsets.only(top: 8, bottom: 12),
      h2: rubik(fontSize: 18, fontWeight: FontWeight.w600, color: _primaryColor),
      h2Padding: const EdgeInsets.only(top: 20, bottom: 8),
      h3: rubik(fontSize: 16, fontWeight: FontWeight.w600),
      h3Padding: const EdgeInsets.only(top: 12, bottom: 6),
      p: rubik(),
      pPadding: const EdgeInsets.only(bottom: 10),
      strong: rubik(fontWeight: FontWeight.w600),
      em: rubik().copyWith(fontStyle: FontStyle.italic),
      listBullet: rubik(),
      listIndent: 24,
      blockSpacing: 8,
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: _accentColor.withValues(alpha: 0.45), width: 1),
        ),
      ),
      blockquote: rubik(color: _textColor.withValues(alpha: 0.85)),
      blockquoteDecoration: BoxDecoration(
        color: _primaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: _primaryColor, width: 4),
        ),
      ),
      blockquotePadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Termos de Uso (v${widget.version})',
          style: GoogleFonts.rubik(fontWeight: FontWeight.w500),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(fontSize: 16),
          ),
        ),
      );
    }

    if (_content == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scrollbar(
      child: Markdown(
        data: _content!,
        selectable: true,
        styleSheet: _styleSheet(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      ),
    );
  }
}
