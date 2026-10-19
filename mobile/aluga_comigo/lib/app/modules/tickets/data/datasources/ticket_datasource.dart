import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/domain/entities/failures.dart';
import '../../../../shared/domain/errors/supabase_error_handler.dart';
import '../../domain/entities/ticket_list_filters.dart';
import '../../domain/enums/ticket_category.dart';
import '../../domain/enums/ticket_reaction.dart';
import '../models/support_ticket_model.dart';

abstract interface class ITicketDatasource {
  static const pageSize = 20;

  Future<List<SupportTicketModel>> listTickets({
    required int page,
    required TicketListFilters filters,
  });

  Future<SupportTicketModel> getTicketById(String ticketId);

  Future<void> insertTicket({
    required String title,
    required TicketCategory category,
    required String description,
    String? reportedAccountId,
    String? reportContext,
  });

  Future<TicketReaction?> setReaction({
    required String ticketId,
    required TicketReaction? reaction,
  });

  Future<void> addComment({
    required String ticketId,
    required String body,
  });
}

class TicketDatasource implements ITicketDatasource {
  final SupabaseClient client;

  const TicketDatasource(this.client);

  static const _reactionsSelect =
      'support_ticket_reactions(reaction, account_id)';

  static const _ticketSelect =
      '*, $_reactionsSelect, support_ticket_comments(id, body, created_at)';

  /// Sempre o `auth.uid()` — conta pessoa e conta imóvel são logins distintos.
  String get _accountId {
    final id = client.auth.currentUser?.id;
    if (id == null || id.isEmpty) {
      throw FailureDatasource(message: 'Usuário não autenticado');
    }
    return id;
  }

  @override
  Future<List<SupportTicketModel>> listTickets({
    required int page,
    required TicketListFilters filters,
  }) async {
    try {
      final from = page * ITicketDatasource.pageSize;
      final to = from + ITicketDatasource.pageSize - 1;
      final trimmed = filters.searchQuery.trim();

      var filter = client
          .from('support_tickets')
          .select('*, $_reactionsSelect');

      final category = filters.category;
      if (category != null) {
        filter = filter.eq('category', category.storageValue);
      }

      final status = filters.status;
      if (status != null) {
        filter = filter.eq('status', status.storageValue);
      }

      if (trimmed.isNotEmpty) {
        final escaped = trimmed.replaceAll(',', ' ');
        filter = filter.or(
          'title.ilike.%$escaped%,description.ilike.%$escaped%',
        );
      }

      final rows = await filter
          .order('created_at', ascending: false)
          .range(from, to);
      return (rows as List)
          .map(
            (row) => SupportTicketModel.fromMap(
              Map<String, dynamic>.from(row as Map),
              currentAccountId: _accountId,
            ),
          )
          .toList();
    } on PostgrestException catch (error) {
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      if (error is FailureDatasource) rethrow;
      throw FailureDatasource(message: error.toString());
    }
  }

  @override
  Future<SupportTicketModel> getTicketById(String ticketId) async {
    try {
      final row = await client
          .from('support_tickets')
          .select(_ticketSelect)
          .eq('id', ticketId)
          .maybeSingle();

      if (row == null) {
        throw FailureDatasource(message: 'Ticket não encontrado');
      }

      return SupportTicketModel.fromMap(
        Map<String, dynamic>.from(row),
        currentAccountId: _accountId,
      );
    } on PostgrestException catch (error) {
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      if (error is FailureDatasource) rethrow;
      throw FailureDatasource(message: error.toString());
    }
  }

  @override
  Future<void> insertTicket({
    required String title,
    required TicketCategory category,
    required String description,
    String? reportedAccountId,
    String? reportContext,
  }) async {
    try {
      final payload = <String, dynamic>{
        'account_id': _accountId,
        'title': title.trim(),
        'category': category.storageValue,
        'description': description.trim(),
        'status': 'open',
      };
      final reportedId = reportedAccountId?.trim();
      if (reportedId != null && reportedId.isNotEmpty) {
        payload['reported_account_id'] = reportedId;
      }
      final context = reportContext?.trim();
      if (context != null && context.isNotEmpty) {
        payload['report_context'] = context;
      }
      await client.from('support_tickets').insert(payload);
    } on PostgrestException catch (error) {
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      if (error is FailureDatasource) rethrow;
      throw FailureDatasource(message: error.toString());
    }
  }

  @override
  Future<TicketReaction?> setReaction({
    required String ticketId,
    required TicketReaction? reaction,
  }) async {
    try {
      if (reaction == null) {
        await client
            .from('support_ticket_reactions')
            .delete()
            .eq('ticket_id', ticketId)
            .eq('account_id', _accountId);
        return null;
      }

      await client.from('support_ticket_reactions').upsert({
        'ticket_id': ticketId,
        'account_id': _accountId,
        'reaction': reaction.storageValue,
      });

      return reaction;
    } on PostgrestException catch (error) {
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      if (error is FailureDatasource) rethrow;
      throw FailureDatasource(message: error.toString());
    }
  }

  @override
  Future<void> addComment({
    required String ticketId,
    required String body,
  }) async {
    try {
      await client.from('support_ticket_comments').insert({
        'ticket_id': ticketId,
        'account_id': _accountId,
        'body': body.trim(),
      });
    } on PostgrestException catch (error) {
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      if (error is FailureDatasource) rethrow;
      throw FailureDatasource(message: error.toString());
    }
  }
}
