import '../enums/ticket_category.dart';
import '../enums/ticket_status.dart';

class TicketListFilters {
  final String searchQuery;
  final TicketCategory? category;
  final TicketStatus? status;

  const TicketListFilters({
    this.searchQuery = '',
    this.category,
    this.status,
  });

  TicketListFilters copyWith({
    String? searchQuery,
    TicketCategory? category,
    TicketStatus? status,
    bool clearCategory = false,
    bool clearStatus = false,
  }) {
    return TicketListFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      category: clearCategory ? null : (category ?? this.category),
      status: clearStatus ? null : (status ?? this.status),
    );
  }
}
