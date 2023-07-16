import '../models/room.dart';

class RoomService {
  late List<Room> _rooms = [];

  List<Room> get rooms {
    return this._rooms;
  }

  setRooms(List<Room> rooms) {
    this._rooms = rooms;
  }

  int findIndexById(String roomId) {
    return this._rooms.indexWhere((room) => room.roomId == roomId);
  }

  Room? findById(String roomId) {
    int index = this.findIndexById(roomId);
    return this._rooms[index];
  }

  Room updateRoom(Room room) {
    int index = this.findIndexById(room.roomId);

    this._rooms[index] = room;
    return this._rooms[index];
  }

  List<Room> listAvailableRooms() {
    return this.filter((room) => room.bookedAt == null);
  }

  List<Room> listRoomsByFloor(int floor) {
    return this.filter((room) => room.floor == floor);
  }

  List<Room> listBookedRooms() {
    return this.filter((room) => room.bookedAt != null);
  }

  List<Room> filter(bool Function(Room) test) {
    return this._rooms.where(test).toList();
  }

  void clearRoom(String roomId) {
    int index = this.findIndexById(roomId);

    this._rooms[index].keycardId = null;
    this._rooms[index].guest = null;
    this._rooms[index].bookedAt = null;
  }

  static String createRoomId(int floor, int room) {
    return "$floor${room.toString().padLeft(2, "0")}";
  }
}
