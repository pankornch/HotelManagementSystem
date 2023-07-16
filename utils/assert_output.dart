import 'dart:convert';
import 'dart:io';

class AssertOutput {
  final String filename;

  AssertOutput({required this.filename});

  assertByIndex(String result, int index) async {
    String output = await File(this.filename).readAsString(encoding: utf8);
    List<String> content = output.split("\n");

    assert(content[index] == result, "[$index] expected ${content[index]}; got $result");
  }
}
