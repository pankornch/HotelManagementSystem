import '../models/guest.dart';
import '../models/keycard.dart';
import '../models/room.dart';
import '../utils/message.dart';
import 'keycard_service.dart';
import 'room_service.dart';

class HotelManagementService {
  late RoomService roomService;
  late KeycardService keycardService;

  HotelManagementService() {
    this.roomService = new RoomService();
    this.keycardService = new KeycardService();
  }

  List<Room> createHotel(int floors, int roomsPerFloor) {
    List<Room> _rooms = [];
    List<Keycard> _keycards = [];

    for (int f = 0; f < floors; f++) {
      for (int r = 0; r < roomsPerFloor; r++) {
        String roomId = RoomService.createRoomId(f + 1, r + 1);
        Room _room = Room(roomId: roomId, floor: f + 1);
        _rooms.add(_room);

        String keycardId = "${_keycards.length + 1}";
        Keycard _keycard = new Keycard(keycardId: keycardId);
        _keycards.add(_keycard);
      }
    }

    this.roomService.setRooms(_rooms);
    this.keycardService.setKeycards(_keycards);

    return _rooms;
  }

  Room bookByUser(String roomId, String guestName, int guestAge) {
    Room? _room = this.roomService.findById(roomId);

    if (_room == null) {
      throw Message.roomNotFound(roomId);
    }

    if (_room.guest != null) {
      throw Message.alreadyBookByGuest(
        _room,
        new Guest(guestName: guestName, guestAge: guestAge),
      );
    }

    Keycard? _availableKeycard = this.keycardService.getAvailableKeycard();

    if (_availableKeycard == null) {
      throw Message.keycardNotAvailable();
    }

    _room.guest = new Guest(guestName: guestName, guestAge: guestAge);
    _room.keycardId = _availableKeycard.keycardId;
    _room.bookedAt = new DateTime.now();

    _availableKeycard.roomId = _room.roomId;
    _availableKeycard.guestName = guestName;

    this.roomService.updateRoom(_room);
    this.keycardService.updateKeycard(_availableKeycard);

    return _room;
  }

  List<Room> listAvailableRooms() {
    return this.roomService.listAvailableRooms();
  }

  Room checkoutByUser(String keycardId, String guestName) {
    Keycard _keycard = this.keycardService.findById(keycardId);

    if (_keycard.guestName != guestName) {
      throw Message.invalidGuestCheckout(_keycard);
    }

    Room _room = this.roomService.findById(_keycard.roomId!)!;

    this.keycardService.clearKeycard(keycardId);
    this.roomService.clearRoom(_room.roomId);

    return _room;
  }

  List<Guest> listGuests() {
    List<Room> _bookedRooms = this.roomService.listBookedRooms();

    _bookedRooms.sort((a, b) => a.bookedAt!.compareTo(b.bookedAt!));

    return _bookedRooms.map((room) => room.guest!).toList();
  }

  Guest? getGuestInRoom(String roomId) {
    Room? _room = this.roomService.findById(roomId);
    if (_room == null) {
      throw Message.roomNotFound(roomId);
    }

    return _room.guest;
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
        .roomService
        .filter((room) => room.floor == floor && room.guest != null)
        .map((room) => room.guest!)
        .toList();
  }

  checkoutGuestByFloor(int floor) {
    List<Room> _rooms = this
        .roomService
        .filter((room) => room.floor == floor && room.bookedAt != null)
        .toList();

    _rooms.forEach((room) {
      this.keycardService.clearKeycard(room.keycardId!);
      this.roomService.clearRoom(room.roomId);
    });

    return _rooms;
  }

  bookByFloor(int floor, String guestName, int guestAge) {
    bool _hasFloorAvailable = this.listGuestsByFloor(floor).length == 0;

    if (!_hasFloorAvailable) {
      throw Message.bookByFloorNotAvailable(floor, guestName);
    }
    List<Room> _rooms = this.roomService.listRoomsByFloor(floor);

    List<Room> _bookedRooms = _rooms
        .map((room) => this.bookByUser(room.roomId, guestName, guestAge))
        .toList();

    return _bookedRooms;
  }
}
