import 'dart:math';

import '../models/event.dart';

abstract class EventRepository {
  Future<List<Event>> fetchAllEvents();
}

class FakeEventRepository implements EventRepository {
  @override
  Future<List<Event>> fetchAllEvents() async {
    // Simulate a small network delay for realism
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _sampleEvents;
  }

  static final List<Event> _sampleEvents = _generateSampleEvents();

  static List<Event> _generateSampleEvents() {
    final DateTime now = DateTime.now();
    final Random random = Random(42);

    Event e({
      required String id,
      required String title,
      required String org,
      required int daysFromNow,
      required int hourOfDay,
      required String location,
      required String city,
      required bool isLocal,
      required String description,
      String? rsvp,
      String? image,
    }) {
      final DateTime dt = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(Duration(days: daysFromNow, hours: hourOfDay));
      return Event(
        id: id,
        title: title,
        organization: org,
        startDateTime: dt,
        location: location,
        city: city,
        description: description,
        isLocalCampus: isLocal,
        rsvpUrl: rsvp,
        imageUrl: image,
      );
    }

    return <Event>[
      e(
        id: 'evt_${random.nextInt(99999)}',
        title: 'Welcome Fair',
        org: 'Student Union',
        daysFromNow: 2,
        hourOfDay: 11,
        location: 'Main Quad',
        city: 'Your Campus',
        isLocal: true,
        description:
            'Explore student clubs, grab freebies, and meet new friends at the Welcome Fair.',
      ),
      e(
        id: 'evt_${random.nextInt(99999)}',
        title: 'Study Jam Night',
        org: 'Library Committee',
        daysFromNow: 3,
        hourOfDay: 18,
        location: 'Room 210, Library',
        city: 'Your Campus',
        isLocal: true,
        description:
            'Focus session with snacks and quiet zones. Bring coursework and grind together.',
      ),
      e(
        id: 'evt_${random.nextInt(99999)}',
        title: 'Global Hackathon 24h',
        org: 'Open Dev Collective',
        daysFromNow: 6,
        hourOfDay: 9,
        location: 'Virtual',
        city: 'Worldwide',
        isLocal: false,
        description:
            'Join teams across the globe to build projects in 24 hours. Prizes and swag.',
      ),
      e(
        id: 'evt_${random.nextInt(99999)}',
        title: 'Campus Career Fair',
        org: 'Career Services',
        daysFromNow: 8,
        hourOfDay: 10,
        location: 'Athletics Center',
        city: 'Your Campus',
        isLocal: true,
        description:
            'Meet recruiters from tech, finance, and startups. Bring resumes and dress smart.',
      ),
      e(
        id: 'evt_${random.nextInt(99999)}',
        title: 'International Students Meetup',
        org: 'Global Students Assoc.',
        daysFromNow: 4,
        hourOfDay: 16,
        location: 'Community Hall',
        city: 'Berlin',
        isLocal: false,
        description:
            'Connect with students from around the world. Games, snacks, and culture swap.',
      ),
      e(
        id: 'evt_${random.nextInt(99999)}',
        title: 'AI in Education Webinar',
        org: 'EdTech Club',
        daysFromNow: 5,
        hourOfDay: 13,
        location: 'Online',
        city: 'Worldwide',
        isLocal: false,
        description:
            'Panel on how AI is reshaping learning. Q&A with researchers and practitioners.',
      ),
      e(
        id: 'evt_${random.nextInt(99999)}',
        title: 'Rivalry Basketball Game',
        org: 'Athletics',
        daysFromNow: 1,
        hourOfDay: 19,
        location: 'Campus Arena',
        city: 'Your Campus',
        isLocal: true,
        description:
            'Cheer on the home team in the biggest game of the season. Wear school colors!',
      ),
      e(
        id: 'evt_${random.nextInt(99999)}',
        title: 'Spring Concert',
        org: 'Music Department',
        daysFromNow: 10,
        hourOfDay: 20,
        location: 'Open Air Stage',
        city: 'Your Campus',
        isLocal: true,
        description:
            'Student bands and guest artists. Bring blankets. Limited seating available.',
      ),
      e(
        id: 'evt_${random.nextInt(99999)}',
        title: 'Undergrad Research Symposium',
        org: 'Research Office',
        daysFromNow: 12,
        hourOfDay: 9,
        location: 'Science Building',
        city: 'Boston',
        isLocal: false,
        description:
            'Poster sessions and lightning talks showcasing student research across disciplines.',
      ),
      e(
        id: 'evt_${random.nextInt(99999)}',
        title: 'Sustainability Summit',
        org: 'Green Campus Initiative',
        daysFromNow: 15,
        hourOfDay: 10,
        location: 'Convention Center',
        city: 'Tokyo',
        isLocal: false,
        description:
            'Talks and workshops on climate action, campus initiatives, and green careers.',
      ),
    ];
  }
}
