class Room {
  final String roomId;
  final int floor;
  late String? guest;
  late int? keycardId;

  Room({required this.roomId,required this.floor, this.guest, this.keycardId});
}