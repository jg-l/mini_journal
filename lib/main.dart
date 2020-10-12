import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:mini_journal/providers.dart';
import 'package:mini_journal/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

final _searchFilter = StateProvider<String>((_) => '');

final _journalEntryListProvider = StateNotifierProvider<JournalEntries>((ref) {
  return JournalEntries([
    JournalEntry(entry: 'Hello World!'),
  ]);
});

// ignore: top_level_function_literal_block
final _filteredEntriesProvider = Provider((ref) {
  final searchFilter = ref.watch(_searchFilter);
  final filtered = ref.watch(_journalEntryListProvider.state);

  if (searchFilter.state != '') {
    // return filtered.where((entry) => entry.entry.contains(searchFilter.state));
    return filtered.where((entry) => entry.entry.contains(searchFilter.state));
  } else {
    // return filtered.where((entry) => entry.entry.contains('Hello'));
    return filtered.toList();
  }
});

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SafeArea(child: MiniJournal()),
    );
  }
}

class MiniJournal extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final entries = watch(_filteredEntriesProvider);
    final scrollController = watch(_scrollController);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: null,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: entries.length > 0
                ? SingleChildScrollView(
                    controller: scrollController.state,
                    child: Column(
                      children: [
                        Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: entries
                                .map((e) => EntryWidget(entry: e))
                                .toList()),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                    'Make some entries!',
                    style: GoogleFonts.roboto(
                      fontSize: 25.0,
                      color: Colors.black54,
                    ),
                  )),
          ),
          KeyboardBar(),
        ],
      ),
    );
  }
}

final _scrollController = StateProvider<ScrollController>((ref) {
  return ScrollController();
});

class KeyboardBar extends StatefulWidget {
  const KeyboardBar({
    Key key,
  }) : super(key: key);

  @override
  _KeyboardBarState createState() => _KeyboardBarState();
}

class _KeyboardBarState extends State<KeyboardBar> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black12,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height / 2,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: TextField(
            controller: _textEditingController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: (value) {
              if (_textEditingController.text.trim()[0] == '?') {
                // initiate the filter
                final searchString =
                    _textEditingController.text.trim().substring(1).trim();
                context.read(_searchFilter).state = searchString;
              } else {
                context.read(_searchFilter).state = '';
              }
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Start typing or search with ?',
              prefixIcon: IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () {
                  // Make a photo entry
                },
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.add_box,
                ),
                onPressed: () {
                  final _sc = context.read(_scrollController);
                  if (_textEditingController.text != '' &&
                      _textEditingController.text.trim()[0] != '?') {
                    context
                        .read(_journalEntryListProvider)
                        .add(_textEditingController.text);
                    setState(() {
                      _textEditingController.clear();
                    });

                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      _sc.state.animateTo(
                        _sc.state.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInCirc,
                      );
                    });
                    FocusScope.of(context).unfocus();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EntryWidget extends StatelessWidget {
  const EntryWidget({
    Key key,
    this.entry,
  }) : super(key: key);
  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        context.read(_journalEntryListProvider).remove(entry);
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 21.0,
          left: 21.0,
          right: 21.0,
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.created.entryDate(),
              style: GoogleFonts.roboto(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
            Text(
              entry.created.entryTime(),
              style: GoogleFonts.roboto(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 60,
            ),
            Text(
              entry.entry,
              style: GoogleFonts.roboto(
                fontSize: 16.0,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 21.0),
              child: Divider(),
            ),
          ],
        ),
      ),
    );
  }
}
