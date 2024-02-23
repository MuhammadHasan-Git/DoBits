import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/view/pending_task.dart';
import 'package:todo_app/view/widget/completed_task.dart';
import 'package:todo_app/view/widget/inprogress_task.dart';
import 'package:todo_app/view/widget/todo_task.dart';

class TaskBarView extends StatefulWidget {
  const TaskBarView({super.key, required this.mobileId});
  final String mobileId;

  @override
  State<TaskBarView> createState() => _TaskBarViewState();
}

class _TaskBarViewState extends State<TaskBarView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 4, vsync: this);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          splashFactory: NoSplash.splashFactory,
          controller: tabController,
          padding: const EdgeInsets.symmetric(vertical: 20),
          labelPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          labelColor: Colors.blueAccent,
          labelStyle: const TextStyle(fontSize: 16, letterSpacing: 1.2),
          indicatorColor: Colors.blueAccent,
          unselectedLabelColor: Colors.grey,
          dividerColor: Colors.transparent,
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          tabs: const <Widget>[
            Row(
              children: [
                Icon(Icons.task),
                SizedBox(width: 5),
                Text('Task'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.done),
                SizedBox(width: 5),
                Text('Completed'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.play_arrow),
                SizedBox(width: 5),
                Text('In Progress'),
              ],
            ),
            Row(
              children: [
                Icon(CupertinoIcons.clock),
                SizedBox(width: 5),
                Text('Pending'),
              ],
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              TodoTask(mobileId: widget.mobileId),
              CompletedTask(mobileId: widget.mobileId),
              InProgressTask(mobileId: widget.mobileId),
              PendingTask(mobileId: widget.mobileId),
            ],
          ),
        )
      ],
    );
  }
}
