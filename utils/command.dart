import 'dart:convert';

import 'dart:io';

class Command {
  final String name;
  final List<String> params;

  Command({required this.name, required this.params});

  static Future<List<Command>> getCommandsFormFileName(String filename) async {
    String input = await File(filename).readAsString(encoding: utf8);

    List<Command> commands = input.split("\n").map((line) {
      List<String> command = line.split(' ');

      return new Command(name: command[0], params: command.sublist(1));
    }).toList();

    return commands;
  }
}
