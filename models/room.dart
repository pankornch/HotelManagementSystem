import 'guest.dart';

class Room {
  final String roomId;
  final int floor;
  late Guest? guest; 
  late String? keycardId;
  late DateTime? bookedAt;

  Room({
    required this.roomId,
    required this.floor,
    this.guest,
    this.keycardId,
    this.bookedAt,
  });
}
