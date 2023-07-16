import 'models/guest.dart';
import 'models/room.dart';
import 'services/hotel_management_service.dart';
import 'utils/assert_output.dart';
import 'utils/command.dart';

void main() async {
  String filename = "input.txt";
  HotelManagementService service = new HotelManagementService();

  List<Command> commands = await Command.getCommandsFormFileName(filename);

  for (int i = 0; i < commands.length; i++) {
    Command command = commands[i];
    AssertOutput assertOutput = new AssertOutput(filename: 'output.txt');
    print("${i + 1} ${command.name}");
    switch (command.name) {
      case "create_hotel":
        int floor = int.parse(command.params[0]);
        int roomPerFloor = int.parse(command.params[1]);
        service.createHotel(floor, roomPerFloor);

        String result =
            "Hotel created with $floor floor(s), $roomPerFloor room(s) per floor.";

        print(result);

        assertOutput.assertByIndex(result, i);
        break;

      case "book":
        String roomId = command.params[0];
        String guestName = command.params[1];
        int guestAge = int.parse(command.params[2]);

        try {
          Room _room = service.bookByUser(roomId, guestName, guestAge);
          String result =
              "Room $roomId is booked by $guestName with keycard number ${_room.keycardId}.";
          print(result);
          assertOutput.assertByIndex(result, i);
        } catch (e) {
          print(e);
          assertOutput.assertByIndex(e.toString(), i);
        }

        break;

      case "checkout":
        String keycardId = command.params[0];
        String guestName = command.params[1];

        try {
          Room _room = service.checkoutByUser(keycardId, guestName);
          String result = "Room ${_room.roomId} is checkout.";
          print(result);
          assertOutput.assertByIndex(result, i);
        } catch (e) {
          print(e);
          assertOutput.assertByIndex(e.toString(), i);
        }
        break;

      case "list_available_rooms":
        List<Room> _rooms = service.listAvailableRooms();

        String result = _rooms.map((room) => room.roomId).join(", ");
        print(result);
        assertOutput.assertByIndex(result, i);
        break;

      case "list_guest":
        List<Guest> guests = service.listGuests();
        String result = guests.map((guest) => guest.guestName).join(", ");
        print(result);
        assertOutput.assertByIndex(result, i);
        break;

      case "get_guest_in_room":
        String roomId = command.params[0];
        Guest guest = service.getGuestInRoom(roomId);
        String result = guest.guestName;
        print(result);
        assertOutput.assertByIndex(result, i);
        break;

      default:
        break;
    }
  }
}
