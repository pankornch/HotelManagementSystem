import 'services/hotel_management_service.dart';
import 'utils/command.dart';

void main() async {
  String filename = "input.txt";
  HotelManagementService service = new HotelManagementService();

  List<Command> commands = await Command.getCommandsFormFileName(filename);

  commands.forEach((command) {
    switch (command.name) {
      case "create_hotel":
        int floor = int.parse(command.params[0]);
        int roomPerFloor = int.parse(command.params[1]);
        var rooms = service.createHotel(floor, roomPerFloor);

        print(
            "Hotel created with $floor floor(s), $roomPerFloor room(s) per floor.");
        return;
      default:
        return;
    }
  });
}
