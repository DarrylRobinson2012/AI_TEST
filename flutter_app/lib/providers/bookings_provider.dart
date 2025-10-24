import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking.dart';

final bookingsProvider = ChangeNotifierProvider<BookingsController>((ref) {
  return BookingsController();
});

class BookingsController extends ChangeNotifier {
  final List<BookingModel> _bookings = [];
  List<BookingModel> get bookings => List.unmodifiable(_bookings);

  List<BookingModel> bookingsForDay(DateTime day) {
    final d0 = DateTime(day.year, day.month, day.day);
    final d1 = d0.add(const Duration(days: 1));
    return _bookings.where((b) => b.startTime.isAfter(d0) && b.startTime.isBefore(d1)).toList();
  }

  void addBooking({
    required int userId,
    required String serviceType,
    required DateTime start,
    required Duration duration,
    String notes = '',
  }) {
    final id = (_bookings.isEmpty ? 1 : _bookings.last.id + 1);
    final booking = BookingModel(
      id: id,
      userId: userId,
      serviceType: serviceType,
      startTime: start,
      endTime: start.add(duration),
      status: 'pending',
      notes: notes,
    );
    // Naive conflict check (same user, overlap)
    final conflict = _bookings.any((b) => b.userId == userId && b.startTime.isBefore(booking.endTime) && b.endTime.isAfter(booking.startTime));
    if (conflict) {
      // Ignore for now or handle elsewhere
    }
    _bookings.add(booking);
    notifyListeners();
  }
}
