import 'package:flutter/material.dart';

import '../data/event_repository.dart';
import '../models/event.dart';
import 'event_detail_page.dart';

enum FeedMode { local, worldwide }

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final EventRepository eventRepository = FakeEventRepository();

  List<Event> allEvents = <Event>[];
  bool isLoading = true;
  String searchQuery = '';
  FeedMode selectedMode = FeedMode.local;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final List<Event> events = await eventRepository.fetchAllEvents();
    if (!mounted) return;
    setState(() {
      allEvents = events;
      isLoading = false;
    });
  }

  List<Event> get filteredEvents {
    final String normalized = searchQuery.trim().toLowerCase();

    final Iterable<Event> scoped = allEvents.where((Event e) {
      final bool inScope = selectedMode == FeedMode.worldwide || e.isLocalCampus;
      if (!inScope) return false;
      if (normalized.isEmpty) return true;
      final String haystack = (
        '${e.title} ${e.organization} ${e.city} ${e.location} ${e.description}'
      ).toLowerCase();
      return haystack.contains(normalized);
    });

    final List<Event> results = scoped.toList()
      ..sort((Event a, Event b) => a.startDateTime.compareTo(b.startDateTime));

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              setState(() => isLoading = true);
              await _loadEvents();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search events, clubs, or cities',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (String value) {
                setState(() => searchQuery = value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SegmentedButton<FeedMode>(
              segments: const <ButtonSegment<FeedMode>>[
                ButtonSegment<FeedMode>(value: FeedMode.local, label: Text('Local')),
                ButtonSegment<FeedMode>(value: FeedMode.worldwide, label: Text('Worldwide')),
              ],
              selected: <FeedMode>{selectedMode},
              showSelectedIcon: false,
              onSelectionChanged: (Set<FeedMode> selection) {
                if (selection.isEmpty) return;
                setState(() => selectedMode = selection.first);
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    final List<Event> items = filteredEvents;
    if (items.isEmpty) {
      return const Center(child: Text('No events found'));
    }

    final MaterialLocalizations localizations = MaterialLocalizations.of(context);

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        final Event event = items[index];
        final String date = localizations.formatShortDate(event.startDateTime);
        final String time = localizations.formatTimeOfDay(
          TimeOfDay.fromDateTime(event.startDateTime),
          alwaysUse24HourFormat: false,
        );

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(event.title),
            subtitle: Text('$date • $time • ${event.displayLocation}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => EventDetailPage(event: event),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
