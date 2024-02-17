import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/view/widget/all_task.dart';

class TaskBarView extends StatefulWidget {
  const TaskBarView({super.key});

  @override
  State<TaskBarView> createState() => _TaskBarViewState();
}

class _TaskBarViewState extends State<TaskBarView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 5, vsync: this);
    return Expanded(
      child: Column(
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
              Text('All'),
              Row(
                children: [
                  Icon(Icons.task),
                  SizedBox(width: 5),
                  Text('Todo'),
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
              children: const [
                AllTask(),
                Center(
                  child: Text(
                    "Todo Task",
                    style: TextStyle(color: white),
                  ),
                ),
                Center(
                  child: Text(
                    "Completed",
                    style: TextStyle(color: white),
                  ),
                ),
                Center(
                  child: Text(
                    "Total Sales",
                    style: TextStyle(color: white),
                  ),
                ),
                Center(
                  child: Text(
                    "Total Sales",
                    style: TextStyle(color: white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
