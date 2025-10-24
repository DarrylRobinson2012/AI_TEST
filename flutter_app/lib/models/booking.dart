class BookingModel {
  final int id;
  final int userId;
  final String serviceType; // lesson | therapy | performance
  final DateTime startTime;
  final DateTime endTime;
  final String status; // pending | confirmed | cancelled
  final String notes;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.serviceType,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.notes = '',
  });
}
