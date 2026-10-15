import '../enums/ticket_category.dart';

class CreateTicketInput {
  final String title;
  final TicketCategory category;
  final String description;

  const CreateTicketInput({
    required this.title,
    required this.category,
    required this.description,
  });
}
