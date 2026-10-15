import 'package:aluga_comigo/app/shared/domain/extends/string.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class SearchablePickerOption {
  final String value;
  final String label;

  const SearchablePickerOption({required this.value, required this.label});
}

/// Campo de formulário que abre lista filtrável (estado, cidade, etc.).
class SearchablePickerField extends FormField<String> {
  SearchablePickerField({
    super.key,
    super.initialValue,
    super.validator,
    super.onSaved,
    super.enabled,
    required List<SearchablePickerOption> options,
    required String hint,
    required String sheetTitle,
    ValueChanged<String?>? onChanged,
  }) : super(
         builder: (field) {
           final selectedLabel = _labelForValue(options, field.value);

           Future<void> openPicker() async {
             if (field.widget.enabled == false) return;
             if (options.isEmpty) return;

             final picked = await showModalBottomSheet<String>(
               context: field.context,
               isScrollControlled: true,
               useSafeArea: true,
               builder: (sheetContext) {
                 var query = '';

                 return StatefulBuilder(
                   builder: (context, setSheetState) {
                     final normalized = query
                         .trim()
                         .removeDiacritics()
                         .toLowerCase();
                     final filtered = normalized.isEmpty
                         ? options
                         : options
                               .where(
                                 (option) => option.label
                                     .removeDiacritics()
                                     .toLowerCase()
                                     .contains(normalized),
                               )
                               .toList();

                     return DraggableScrollableSheet(
                       initialChildSize: 0.75,
                       minChildSize: 0.45,
                       maxChildSize: 0.95,
                       expand: false,
                       builder: (_, scrollController) {
                         return Column(
                           crossAxisAlignment: CrossAxisAlignment.stretch,
                           children: [
                             Padding(
                               padding: const EdgeInsets.fromLTRB(
                                 16,
                                 16,
                                 16,
                                 8,
                               ),
                               child: Text(
                                 sheetTitle,
                                 style: GoogleFonts.rubik(
                                   fontSize: 18,
                                   fontWeight: FontWeight.w600,
                                 ),
                               ),
                             ),
                             Padding(
                               padding: const EdgeInsets.symmetric(
                                 horizontal: 16,
                               ),
                               child: TextField(
                                 autofocus: true,
                                 decoration: InputDecoration(
                                   hintText: 'Pesquisar...',
                                   prefixIcon: const Icon(Icons.search),
                                   border: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(12),
                                   ),
                                   isDense: true,
                                 ),
                                 onChanged: (value) {
                                   setSheetState(() => query = value);
                                 },
                               ),
                             ),
                             const SizedBox(height: 8),
                             Expanded(
                               child: filtered.isEmpty
                                   ? Center(
                                       child: Text(
                                         'Nenhum resultado.',
                                         style: GoogleFonts.rubik(
                                           color: Colors.black54,
                                         ),
                                       ),
                                     )
                                   : ListView.builder(
                                       controller: scrollController,
                                       itemCount: filtered.length,
                                       itemBuilder: (context, index) {
                                         final option = filtered[index];
                                         return ListTile(
                                           title: Text(
                                             option.label,
                                             style: GoogleFonts.rubik(),
                                           ),
                                           onTap: () => Navigator.of(
                                             sheetContext,
                                           ).pop(option.value),
                                         );
                                       },
                                     ),
                             ),
                           ],
                         );
                       },
                     );
                   },
                 );
               },
             );

             if (picked != null) {
               field.didChange(picked);
               onChanged?.call(picked);
             }
           }

           final hasError = field.hasError;

           return InkWell(
             onTap: openPicker,
             borderRadius: BorderRadius.circular(25.7),
             child: InputDecorator(
               decoration: InputDecoration(
                 filled: true,
                 fillColor: Colors.white,
                 errorStyle: const TextStyle(fontSize: 0),
                 contentPadding: const EdgeInsets.only(
                   left: 24,
                   right: 16,
                   bottom: 12,
                   top: 12,
                 ),
                 enabledBorder: OutlineInputBorder(
                   borderSide: const BorderSide(color: Colors.white),
                   borderRadius: BorderRadius.circular(25.7),
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderSide: const BorderSide(color: Colors.white),
                   borderRadius: BorderRadius.circular(25.7),
                 ),
                 errorBorder: OutlineInputBorder(
                   borderSide: const BorderSide(color: Colors.red, width: 3),
                   borderRadius: BorderRadius.circular(25.7),
                 ),
                 focusedErrorBorder: OutlineInputBorder(
                   borderSide: const BorderSide(color: Colors.red, width: 3),
                   borderRadius: BorderRadius.circular(25.7),
                 ),
               ),
               child: Row(
                 children: [
                   Expanded(
                     child: Text(
                       selectedLabel ?? hint,
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                       textAlign: TextAlign.center,
                       style: GoogleFonts.rubik(
                         fontSize: 18,
                         color: selectedLabel == null
                             ? Colors.black54
                             : Colors.black87,
                       ),
                     ),
                   ),
                   Icon(
                     Icons.expand_more,
                     color: hasError ? Colors.red : Colors.black54,
                   ),
                 ],
               ),
             ),
           );
         },
       );

  static String? _labelForValue(
    List<SearchablePickerOption> options,
    String? value,
  ) {
    if (value == null || value.isEmpty) return null;
    for (final option in options) {
      if (option.value == value) return option.label;
    }
    return value;
  }
}
