import '../models/keycard.dart';

class KeycardService {
  late List<Keycard> _keycards = [];

  List<Keycard> get keycards {
    return _keycards;
  }

  List<Keycard> setKeycards(List<Keycard> keycards) {
    this._keycards = keycards;
    return keycards;
  }

  Keycard updateKeycard(Keycard keycard) {
    int index = this.findIndexById(keycard.keycardId);
    this._keycards[index] = keycard;

    return this._keycards[index];
  }

  int findIndexById(String keycardId) {
    return this
        .keycards
        .indexWhere((keycard) => keycard.keycardId == keycardId);
  }

  Keycard findById(String keycardId) {
    int index = this.findIndexById(keycardId);
    return this.keycards[index];
  }

  Keycard? getAvailableKeycard() {
    return this._keycards.firstWhere((keycard) => keycard.roomId == null);
  }

  void clearKeycard(String keycardId) {
    int _index = this.findIndexById(keycardId);

    this.keycards[_index].roomId = null;
    this.keycards[_index].guestName = null;
  }
}
