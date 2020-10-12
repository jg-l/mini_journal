import 'package:flutter_riverpod/all.dart';
import 'package:uuid/uuid.dart';

var _uuid = Uuid();

class JournalEntry {
  JournalEntry({String id, this.entry, DateTime created})
      : id = id ?? _uuid.v4(),
        created = created ?? DateTime.now();
  final String id;
  final String entry;
  final DateTime created;

  @override
  String toString() {
    return 'JournalEntry(Entry: $entry)';
  }
}

/// An object that controls a list of [Todo].
class JournalEntries extends StateNotifier<List<JournalEntry>> {
  JournalEntries([List<JournalEntry> initialEntries])
      : super(initialEntries ?? []);

  void add(String entry) {
    state = [
      ...state,
      JournalEntry(entry: entry),
    ];
  }

  void remove(JournalEntry target) {
    state = state.where((entry) => entry.id != target.id).toList();
  }
}
