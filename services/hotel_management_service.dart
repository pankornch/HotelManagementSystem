import '../models/guest.dart';
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
    _room.bookedAt = new DateTime.now();

    this.keycards[_keyCardIndex] = _keycard;

    return _room;
  }

  List<Room> listAvailableRooms() {
    return this.rooms.where((room) => room.keycardId == null).toList();
  }

  Room checkoutByUser(String keycardId, String guestName) {
    int _keycardIndex =
        this.keycards.indexWhere((keycard) => keycard.keycardId == keycardId);
    Keycard _keycard = this.keycards[_keycardIndex];

    if (_keycard.guestName != guestName) {
      throw "Only ${_keycard.guestName} can checkout with keycard number $keycardId.";
    }

    int _roomIndex =
        this.rooms.indexWhere((room) => room.keycardId == keycardId);

    Room _room = [...this.rooms][_roomIndex];

    clearKeycard(keycardId);
    clearRoom(_room.roomId);

    return _room;
  }

  List<Guest> listGuests() {
    List<Room> _bookedRooms =
        this.rooms.where((room) => room.guestName != null).toList();

    _bookedRooms.sort((a, b) => a.bookedAt!.compareTo(b.bookedAt!));

    return _bookedRooms
        .map((room) =>
            new Guest(guestName: room.guestName!, guestAge: room.guestAge!))
        .toList();
  }

  Guest getGuestInRoom(String roomId) {
    Room _room = this.rooms.firstWhere((room) => room.roomId == roomId);
    return new Guest(guestName: _room.guestName!, guestAge: _room.guestAge!);
  }

  List<Guest> listGuestsByAge(String operation, int age) {
    List<Guest> _guests = this.listGuests();

    switch (operation) {
      case "<":
        return _guests.where((guest) => guest.guestAge < age).toList();
      case "<=":
        return _guests.where((guest) => guest.guestAge <= age).toList();
      case ">":
        return _guests.where((guest) => guest.guestAge > age).toList();
      case ">=":
        return _guests.where((guest) => guest.guestAge >= age).toList();
      case "==":
        return _guests.where((guest) => guest.guestAge == age).toList();
      default:
        return _guests;
    }
  }

  List<Guest> listGuestsByFloor(int floor) {
    return this
        .rooms
        .where((room) => room.floor == floor && room.bookedAt != null)
        .map((room) =>
            new Guest(guestName: room.guestName!, guestAge: room.guestAge!))
        .toList();
  }

  checkoutGuestByFloor(int floor) {
    List<Room> _rooms = this
        .rooms
        .where((room) => room.floor == floor && room.bookedAt != null)
        .toList();
    _rooms.forEach((room) {
      clearKeycard(room.keycardId!);
      clearRoom(room.roomId);
    });

    return _rooms;
  }

  bookByFloor(int floor, String guestName, int guestAge) {
    bool _hasFloorAvalable = this.listGuestsByFloor(floor).length == 0;

    if (!_hasFloorAvalable) {
      throw "Cannot book floor $floor for $guestName.";
    }
    List<Room> _rooms =
        this.rooms.where((room) => room.floor == floor).toList();

    List<Room> _bookedRooms = _rooms
        .map((room) => this.bookByUser(room.roomId, guestName, guestAge))
        .toList();

    return _bookedRooms;
  }

  static String createRoomId(int floor, int room) {
    return "$floor${room.toString().padLeft(2, "0")}";
  }

  int getAvailableKeycardIndex() {
    return this.keycards.indexWhere((keycard) => keycard.roomId == null);
  }

  clearRoom(String roomId) {
    int _roomIndex = this.rooms.indexWhere((room) => room.roomId == roomId);

    this.rooms[_roomIndex].keycardId = null;
    this.rooms[_roomIndex].guestName = null;
    this.rooms[_roomIndex].guestAge = null;
    this.rooms[_roomIndex].bookedAt = null;
  }

  clearKeycard(String keycardId) {
    int _keycardIndex =
        this.keycards.indexWhere((keycard) => keycard.keycardId == keycardId);

    this.keycards[_keycardIndex].roomId = null;
    this.keycards[_keycardIndex].guestName = null;
  }
}
