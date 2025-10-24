import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../providers/bookings_provider.dart';
import '../../providers/auth_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final _durationMinutes = ValueNotifier<int>(60);
  String _serviceType = 'lesson';
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bookingsCtrl = ref.watch(bookingsProvider);
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar & Booking')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2035, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            calendarFormat: CalendarFormat.month,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DropdownButton<String>(
                      value: _serviceType,
                      items: const [
                        DropdownMenuItem(value: 'lesson', child: Text('Swimming Lesson')),
                        DropdownMenuItem(value: 'therapy', child: Text('Aqua Therapy')),
                        DropdownMenuItem(value: 'performance', child: Text('Performance Training')),
                      ],
                      onChanged: (v) => setState(() => _serviceType = v ?? 'lesson'),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 140,
                      child: TextField(
                        controller: _notesController,
                        decoration: const InputDecoration(labelText: 'Notes'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ValueListenableBuilder<int>(
                      valueListenable: _durationMinutes,
                      builder: (_, value, __) => Row(
                        children: [
                          const Text('Duration:'),
                          IconButton(onPressed: () => _durationMinutes.value = (value - 15).clamp(15, 240), icon: const Icon(Icons.remove_circle_outline)),
                          Text('$value min'),
                          IconButton(onPressed: () => _durationMinutes.value = (value + 15).clamp(15, 240), icon: const Icon(Icons.add_circle_outline)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _selectedDay == null
                          ? null
                          : () {
                              final start = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day, 9, 0);
                              ref.read(bookingsProvider).addBooking(
                                    userId: auth.userId ?? 1,
                                    serviceType: _serviceType,
                                    start: start,
                                    duration: Duration(minutes: _durationMinutes.value),
                                    notes: _notesController.text.trim(),
                                  );
                            },
                      child: const Text('Request Booking'),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Text('Your Bookings for the day', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...bookingsCtrl
                    .bookingsForDay(_selectedDay ?? DateTime.now())
                    .map((b) => Card(
                          child: ListTile(
                            title: Text('${b.serviceType} • ${b.startTime.hour.toString().padLeft(2, '0')}:${b.startTime.minute.toString().padLeft(2, '0')} - ${b.endTime.hour.toString().padLeft(2, '0')}:${b.endTime.minute.toString().padLeft(2, '0')}'),
                            subtitle: Text('Status: ${b.status}${b.notes.isNotEmpty ? ' • ${b.notes}' : ''}'),
                          ),
                        ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
