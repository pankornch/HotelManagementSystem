class Room {
  final String roomId;
  final int floor;
  late String? guestName;
  late int? guestAge;
  late String? keycardId;

  Room({
    required this.roomId,
    required this.floor,
    this.guestName,
    this.keycardId,
    this.guestAge,
  });
}
