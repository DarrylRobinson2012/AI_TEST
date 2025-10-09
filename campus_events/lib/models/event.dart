class Event {
  final String id;
  final String title;
  final String organization;
  final DateTime startDateTime;
  final String location;
  final String city;
  final String description;
  final bool isLocalCampus;
  final String? imageUrl;
  final String? rsvpUrl;

  const Event({
    required this.id,
    required this.title,
    required this.organization,
    required this.startDateTime,
    required this.location,
    required this.city,
    required this.description,
    required this.isLocalCampus,
    this.imageUrl,
    this.rsvpUrl,
  });

  String get displayLocation => city.isEmpty ? location : "$location, $city";
}
