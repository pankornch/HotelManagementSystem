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

        Keycard _keycard = new Keycard(keycardId: "${_keycards.length + 1}");
        _keycards.add(_keycard);
      }
    }

    this.rooms = _rooms;
    this.keycards = _keycards;

    return this.rooms;
  }

  Room bookByUser(String roomId, String guestName, int guestAge) {
    int _index = this.rooms.indexWhere((room) => room.roomId == roomId);
    Room _room = this.rooms[_index];

    if (_room.guestName != null) {
      throw "Cannot book room $roomId for $guestName, The room is currently booked by ${_room.guestName}.";
    }

    int _keyCardIndex = this.getAvailableKeycardIndex();

    Keycard _keycard = new Keycard(
      keycardId: this.keycards[_keyCardIndex].keycardId,
      guestName: guestName,
      roomId: roomId,
    );

    _room.guestName = guestName;
    _room.guestAge = guestAge;
    _room.keycardId = _keycard.keycardId;

    this.keycards[_keyCardIndex] = _keycard;

    return _room;
  }

  listAvailableRooms() {}

  Room checkoutByUser(String keycardId, String guestName) {
    int _keycardIndex =
        this.keycards.indexWhere((keycard) => keycard.keycardId == keycardId);
    Keycard _keycard = this.keycards[_keycardIndex];

    if (_keycard.guestName != guestName) {
      throw "Only ${_keycard.guestName} can checkout with keycard number $keycardId.";
    }

    int _roomIndex = this.rooms.indexWhere((room) => room.keycardId == keycardId);
    
    Room _room = [...this.rooms][_roomIndex];

    this.keycards[_keycardIndex].roomId = null;
    this.keycards[_keycardIndex].guestName = null;

    this.rooms[_roomIndex].keycardId = null;
    this.rooms[_roomIndex].guestName = null;
    this.rooms[_roomIndex].guestAge = null;

    return _room;
  }

  listGuests() {}
  getGuestInRoom() {}
  listGuestsByAge() {}
  listGuestsByFloor() {}
  bookByFloor() {}
  checkoutGuestByFloor() {}

  static String createRoomId(int floor, int room) {
    return "$floor${room.toString().padLeft(2, "0")}";
  }

  int getAvailableKeycardIndex() {
    return this.keycards.indexWhere((keycard) => keycard.roomId == null);
  }
}
