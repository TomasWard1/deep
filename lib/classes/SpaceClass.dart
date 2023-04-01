import 'dart:ui';

class Space {
  //variables
  final String name;
  final String description;
  final String id;
  final String imageUrl;
  final List<String> participantIds;
  final Color color;

  //initialization
  Space(
      {required this.name,
      required this.description,
      required this.id,
      required this.color,
      required this.imageUrl,
      required this.participantIds});

  //getters
  int get participantCount => participantIds.length;
}
