import 'package:flutter/material.dart';
import 'package:syno_downlaodstation/widget/task_listview_item.dart';
import 'package:syno_downlaodstation/model/task_listview_data.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({super.key, required this.rawTasks});
  final List<TaskListData> rawTasks;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: rawTasks.length,
        itemBuilder: (BuildContext context, int idx) {
          return TaskListItem(task: rawTasks[idx]);
        },
        padding: const EdgeInsets.only(bottom: 16),
        shrinkWrap: true,
      ),
    );
  }
}