import '../models/guest.dart';
import '../models/keycard.dart';
import '../models/room.dart';

class Message {
  static String createHotel(int floor, int roomPerFloor) {
    return "Hotel created with $floor floor(s), $roomPerFloor room(s) per floor.";
  }

  static String book(Room room) {
    return "Room ${room.roomId} is booked by ${room.guest!.guestName} with keycard number ${room.keycardId}.";
  }

  static String checkout(Room room) {
    return "Room ${room.roomId} is checkout.";
  }

  static String listAvailableRooms(List<Room> rooms) {
    return rooms.map((room) => room.roomId).join(", ");
  }

  static String listGuest(List<Guest> guests) {
    return guests.map((guest) => guest.guestName).join(", ");
  }

  static String getGuestInRoom(Guest? guest) {
    return guest?.guestName ?? "";
  }

  static String listGuestByAge(List<Guest> guests) {
    return Message.listGuest(guests);
  }

  static String listGuestByFloor(List<Guest> guests) {
    return Message.listGuest(guests);
  }

  static String checkoutGuestByFloor(List<Room> rooms) {
    return "Room ${rooms.map((room) => room.roomId).join(", ")} are checkout.";
  }

  static String roomNotFound(String roomId) {
    return "room $roomId not found";
  }

  static String bookByFloor(List<Room> rooms) {
    return "Room ${rooms.map((room) => room.roomId).join(", ")} are booked with keycard number ${rooms.map((room) => room.keycardId).join(", ")}";
  }

  static String alreadyBookByGuest(Room room, Guest guest) {
    return "Cannot book room ${room.roomId} for ${guest.guestName}, The room is currently booked by ${room.guest!.guestName}.";
  }

  static String keycardNotAvailable() {
    return "keycard is not available";
  }

  static String invalidGuestCheckout(Keycard keycard) {
    return "Only ${keycard.guestName} can checkout with keycard number ${keycard.keycardId}.";
  }

  static String bookByFloorNotAvailable(int floor, String guestName) {
    return "Cannot book floor $floor for $guestName.";
  }
}
