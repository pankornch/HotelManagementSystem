import '../models/keycard.dart';
import '../models/room.dart';

class HotelManagementService {
  List<Room> rooms = [];
  List<Keycard> keycards = [];

  List<Room> createHotel(int floors, int roomsPerFloor) {
    List<Room> _rooms = [];
    List<Keycard> _keycards = [];

    for (int f = 0; f < floors; f++) {
      for (int r = 0; r < roomsPerFloor; r++) {
        Room _room = Room(roomId: createRoomId(f + 1, r + 1), floor: f + 1);
        _rooms.add(_room);

        Keycard _keycard = new Keycard(keycardId: "${keycards.length + 1}");
        _keycards.add(_keycard);
      }
    }

    this.rooms = _rooms;
    this.keycards = _keycards;

    return this.rooms;
  }

  bookByUser() {}
  listAvailableRooms() {}
  checkoutByUser() {}
  listGuests() {}
  getGuestInRoom() {}
  listGuestsByAge() {}
  listGuestsByFloor() {}
  bookByFloor() {}
  checkoutGuestByFloor() {}

  static String createRoomId(int floor, int room) {
    return "$floor${room.toString().padLeft(2, "0")}";
  }
}
