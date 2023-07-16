import 'models/guest.dart';
import 'models/room.dart';
import 'services/hotel_management_service.dart';
import 'utils/assert_output.dart';
import 'utils/command.dart';
import 'utils/message.dart';

void main() async {
  HotelManagementService service = new HotelManagementService();

  List<Command> commands = await Command.getCommandsFormFileName("input.txt");

  for (int i = 0; i < commands.length; i++) {
    Command command = commands[i];
    AssertOutput assertOutput = new AssertOutput(filename: 'output.txt');
    // print("${i + 1} ${command.name}");
    switch (command.name) {
      case "create_hotel":
        int floor = int.parse(command.params[0]);
        int roomPerFloor = int.parse(command.params[1]);

        service.createHotel(floor, roomPerFloor);

        String result = Message.createHotel(floor, roomPerFloor);

        print(result);
        assertOutput.assertByIndex(result, i);
        break;

      case "book":
        String roomId = command.params[0];
        String guestName = command.params[1];
        int guestAge = int.parse(command.params[2]);

        try {
          Room room = service.bookByUser(roomId, guestName, guestAge);
          String result = Message.book(room);

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
          Room room = service.checkoutByUser(keycardId, guestName);
          String result = Message.checkout(room);

          print(result);
          assertOutput.assertByIndex(result, i);
        } catch (e) {
          print(e);
          assertOutput.assertByIndex(e.toString(), i);
        }
        break;

      case "list_available_rooms":
        List<Room> rooms = service.listAvailableRooms();

        String result = Message.listAvailableRooms(rooms);

        print(result);
        assertOutput.assertByIndex(result, i);
        break;

      case "list_guest":
        List<Guest> guests = service.listGuests();

        String result = Message.listGuest(guests);

        print(result);
        assertOutput.assertByIndex(result, i);
        break;

      case "get_guest_in_room":
        String roomId = command.params[0];

        Guest? guest = service.getGuestInRoom(roomId);

        String result = Message.getGuestInRoom(guest);

        print(result);
        assertOutput.assertByIndex(result, i);
        break;

      case "list_guest_by_age":
        String operation = command.params[0];
        int age = int.parse(command.params[1]);

        List<Guest> guests = service.listGuestsByAge(operation, age);

        String result = Message.listGuestByAge(guests);

        print(result);
        assertOutput.assertByIndex(result, i);

        break;

      case "list_guest_by_floor":
        int floor = int.parse(command.params[0]);

        List<Guest> guests = service.listGuestsByFloor(floor);

        String result = Message.listGuestByFloor(guests);

        print(result);
        assertOutput.assertByIndex(result, i);
        break;

      case "checkout_guest_by_floor":
        int floor = int.parse(command.params[0]);

        List<Room> rooms = service.checkoutGuestByFloor(floor);

        String result = Message.checkoutGuestByFloor(rooms);

        print(result);
        assertOutput.assertByIndex(result, i);
        break;

      case "book_by_floor":
        int floor = int.parse(command.params[0]);
        String guestName = command.params[1];
        int guestAge = int.parse(command.params[2]);

        try {
          List<Room> rooms = service.bookByFloor(floor, guestName, guestAge);
          String result = Message.bookByFloor(rooms);

          print(result);
          assertOutput.assertByIndex(result, i);
        } catch (e) {
          print(e);
          assertOutput.assertByIndex(e.toString(), i);
        }

        break;
      default:
        break;
    }
  }
}
