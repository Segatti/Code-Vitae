import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/data/services/session_service.dart';
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

  static const _ticketSelect =
      '*, support_ticket_reactions(reaction), support_ticket_comments(id, body, created_at)';

  String get _accountId {
    final id = SessionService.customer?.id;
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
          .select('*, support_ticket_reactions(reaction)')
          .eq('account_id', _accountId);

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
          .eq('account_id', _accountId)
          .maybeSingle();

      if (row == null) {
        throw FailureDatasource(message: 'Ticket não encontrado');
      }

      return SupportTicketModel.fromMap(Map<String, dynamic>.from(row));
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
  }) async {
    try {
      await client.from('support_tickets').insert({
        'account_id': _accountId,
        'title': title.trim(),
        'category': category.storageValue,
        'description': description.trim(),
        'status': 'open',
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
