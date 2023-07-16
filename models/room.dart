class Room {
  final String roomId;
  final int floor;
  late String? guestName;
  late int? guestAge;
  late String? keycardId;
  late DateTime? bookedAt;

  Room({
    required this.roomId,
    required this.floor,
    this.guestName,
    this.keycardId,
    this.guestAge,
    this.bookedAt,
  });
}
