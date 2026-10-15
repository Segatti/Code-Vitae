import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/support_ticket.dart';
import '../../domain/entities/ticket_list_filters.dart';
import '../../domain/enums/ticket_category.dart';
import '../../domain/enums/ticket_reaction.dart';
import '../../domain/enums/ticket_status.dart';
import '../../domain/usecases/list_tickets_page.dart';
import '../../domain/usecases/set_ticket_reaction.dart';

abstract interface class ITicketsController extends ChangeNotifier {
  List<String> loadingList = [];
  String errorMessage = '';
  List<SupportTicket> items = [];
  String searchQuery = '';
  TicketCategory? categoryFilter;
  TicketStatus? statusFilter;
  bool hasMore = true;
  int currentPage = 0;

  Future<Unit> initialize();
  Future<void> refresh();
  Future<void> loadMore();
  void updateSearch(String value);
  void setCategoryFilter(TicketCategory? category);
  void setStatusFilter(TicketStatus? status);
  Future<void> toggleReaction(String ticketId, TicketReaction reaction);
}

class TicketsController extends ITicketsController {
  final IListTicketsPage _listTicketsPage;
  final ISetTicketReaction _setTicketReaction;

  TicketsController(this._listTicketsPage, this._setTicketReaction);

  Timer? _searchDebounce;

  TicketListFilters get _filters => TicketListFilters(
    searchQuery: searchQuery,
    category: categoryFilter,
    status: statusFilter,
  );

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Future<Unit> initialize() async {
    await refresh();
    return unit;
  }

  @override
  Future<void> refresh() async {
    loadingList.add('loadTickets');
    errorMessage = '';
    currentPage = 0;
    hasMore = true;
    notifyListeners();

    final result = await _listTicketsPage(page: 0, filters: _filters);

    loadingList.remove('loadTickets');
    result.fold(
      (page) {
        items = page.items;
        hasMore = page.hasMore;
        errorMessage = '';
      },
      (failure) {
        items = [];
        hasMore = false;
        errorMessage = failure.toString().replaceFirst('Exception: ', '');
      },
    );
    notifyListeners();
  }

  @override
  Future<void> loadMore() async {
    if (!hasMore || loadingList.contains('loadMoreTickets')) return;

    loadingList.add('loadMoreTickets');
    notifyListeners();

    final nextPage = currentPage + 1;
    final result = await _listTicketsPage(
      page: nextPage,
      filters: _filters,
    );

    loadingList.remove('loadMoreTickets');
    result.fold(
      (page) {
        if (page.items.isEmpty) {
          hasMore = false;
        } else {
          currentPage = nextPage;
          items = [...items, ...page.items];
          hasMore = page.hasMore;
        }
      },
      (_) {},
    );
    notifyListeners();
  }

  @override
  void updateSearch(String value) {
    searchQuery = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      unawaited(refresh());
    });
    notifyListeners();
  }

  @override
  void setCategoryFilter(TicketCategory? category) {
    categoryFilter = category;
    notifyListeners();
    unawaited(refresh());
  }

  @override
  void setStatusFilter(TicketStatus? status) {
    statusFilter = status;
    notifyListeners();
    unawaited(refresh());
  }

  @override
  Future<void> toggleReaction(String ticketId, TicketReaction reaction) async {
    final index = items.indexWhere((item) => item.id == ticketId);
    if (index < 0) return;

    final current = items[index];
    final nextReaction =
        current.userReaction == reaction ? null : reaction;

    items[index] = current.copyWith(
      userReaction: nextReaction,
      clearReaction: nextReaction == null,
    );
    notifyListeners();

    final result = await _setTicketReaction(
      ticketId: ticketId,
      reaction: nextReaction,
    );

    result.fold(
      (_) => notifyListeners(),
      (_) {
        items[index] = current;
        notifyListeners();
      },
    );
  }
}
