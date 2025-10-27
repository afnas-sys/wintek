enum TicketStatus { pending, inProgress, resolved, closed }

enum TicketType { wallet, game, account, payment, technical, other }

class TicketModel {
  final String id;
  final String title;
  final String description;
  final TicketType type;
  final TicketStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  String get statusText {
    switch (status) {
      case TicketStatus.pending:
        return 'Pending';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.resolved:
        return 'Resolved';
      case TicketStatus.closed:
        return 'Closed';
    }
  }

  String get statusColor {
    switch (status) {
      case TicketStatus.pending:
        return '#F98500';
      case TicketStatus.inProgress:
        return '#6041FF';
      case TicketStatus.resolved:
        return '#00C851';
      case TicketStatus.closed:
        return '#757575';
    }
  }

  String get typeIcon {
    switch (type) {
      case TicketType.wallet:
      case TicketType.payment:
        return 'wallet';
      case TicketType.game:
        return 'game';
      case TicketType.account:
      case TicketType.technical:
      case TicketType.other:
        return 'support';
    }
  }

  String get formattedCreatedDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final day = createdAt.day.toString().padLeft(2, '0');
    final month = months[createdAt.month - 1];
    final year = createdAt.year;
    final hour = createdAt.hour > 12
        ? createdAt.hour - 12
        : createdAt.hour == 0
        ? 12
        : createdAt.hour;
    final minute = createdAt.minute.toString().padLeft(2, '0');
    final ampm = createdAt.hour >= 12 ? 'PM' : 'AM';

    return 'Created: $day $month $year, ${hour.toString().padLeft(2, '0')}:$minute $ampm';
  }

  TicketModel copyWith({
    String? id,
    String? title,
    String? description,
    TicketType? type,
    TicketStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TicketModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Sample data for testing - will be replaced with real API data later
  static List<TicketModel> getSampleTickets() {
    return [
      TicketModel(
        id: 'SUP-45921',
        title: 'SUP-45921',
        description:
            'I added ₹1000 via UPI but it didn\'t reflect in my wallet.',
        type: TicketType.wallet,
        status: TicketStatus.pending,
        createdAt: DateTime(2025, 9, 2, 11, 25),
      ),
      TicketModel(
        id: 'SUP-45905',
        title: 'SUP-45905',
        description:
            'Game disconnected in the middle and my entry fee was deducted.',
        type: TicketType.game,
        status: TicketStatus.inProgress,
        createdAt: DateTime(2025, 9, 2, 11, 25),
      ),
      TicketModel(
        id: 'SUP-45922',
        title: 'SUP-45922',
        description: 'Unable to withdraw winnings to my bank account.',
        type: TicketType.payment,
        status: TicketStatus.pending,
        createdAt: DateTime(2025, 9, 1, 15, 30),
      ),
      TicketModel(
        id: 'SUP-45906',
        title: 'SUP-45906',
        description: 'App crashes when trying to join tournament.',
        type: TicketType.technical,
        status: TicketStatus.inProgress,
        createdAt: DateTime(2025, 9, 1, 10, 15),
      ),
    ];
  }
}
