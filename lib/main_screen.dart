import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const blueColor = Color(0xff3B5DD6);

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F5F6),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1531147646552-1eec68116469?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80',
                    // 'https://images.unsplash.com/photo-1580898179497-ce3b9e9ac350?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
                    // 'https://images.unsplash.com/photo-1507400492013-162706c8c05e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=609&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Good Morning'.toUpperCase(),
                    style: GoogleFonts.sourceSansPro(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0),
                    ),
                  ),
                  Text(
                    'You have 5 tasks',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: SingleChildScrollView(
                    key: UniqueKey(),
                    child: Column(
                      children: [
                        TaskWidget(),
                        TaskWidget(),
                        TaskWidget(),
                        TaskWidget(),
                        TaskWidget(),
                        TaskWidget(),
                        TaskWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class TaskModel {
  String title;
  TaskState taskState;
  DateTime createdDate;
  DateTime completedDate;
}

enum TaskState { normal, active, completed }

class TaskWidget extends StatefulWidget {
  const TaskWidget({
    Key key,
    this.state = TaskState.normal,
  }) : super(key: key);

  final TaskState state;

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TaskState _taskState;

  @override
  void initState() {
    super.initState();
    _taskState = widget.state;
  }

  Color getTaskBG() {
    switch (_taskState) {
      case TaskState.completed:
        return Color(0xffDEDEDE);
        break;
      case TaskState.normal:
        return Colors.white;
        break;
      case TaskState.active:
        return blueColor;
        break;
      default:
        return blueColor;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 283),
      padding: EdgeInsets.all(18.0),
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: getTaskBG(),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: () {
          setState(() {
            if (_taskState == TaskState.active) {
              _taskState = TaskState.normal;
            } else {
              _taskState = TaskState.active;
            }
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  if (_taskState == TaskState.completed) {
                    _taskState = TaskState.normal;
                  } else {
                    _taskState = TaskState.completed;
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 12.0),
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: _taskState == TaskState.active
                      ? Colors.white.withOpacity(0.3)
                      : Color(0xffEBEBEB),
                ),
                child: _taskState == TaskState.completed
                    ? Icon(
                        Icons.check,
                        color: Color(0xff707070),
                      )
                    : SizedBox.shrink(),
              ),
            ),
            Flexible(
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean vel orci euismod, faucibus magna quis, tincidunt massa.',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: _taskState == TaskState.completed ||
                            _taskState == TaskState.active
                        ? Colors.white
                        : Colors.black,
                    fontSize: 18.0,
                    fontWeight: _taskState == TaskState.active
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
