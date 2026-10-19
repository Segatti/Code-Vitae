import '../enums/ticket_category.dart';

class CreateTicketInput {
  final String title;
  final TicketCategory category;
  final String description;
  final String? reportedAccountId;
  final String? reportContext;

  const CreateTicketInput({
    required this.title,
    required this.category,
    required this.description,
    this.reportedAccountId,
    this.reportContext,
  });
}
