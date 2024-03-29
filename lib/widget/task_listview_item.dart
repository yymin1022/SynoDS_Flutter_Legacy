import 'package:flutter/material.dart';
import 'package:syno_downlaodstation/model/task_listview_data.dart';

class TaskListItem extends StatelessWidget {
  final TaskListData task;
  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    late MaterialColor color;
    switch (task.status) {
      case 'downloading':
        color = Colors.blue;
        break;
      case 'paused':
        color = Colors.amber;
        break;
      case 'finished':
        color = Colors.green;
        break;
      case 'error':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
        break;
    }

    return Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.only(right: 20),
                                child: Text(
                                  task.title,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false
                                ),
                              ),
                            ),
                            Text(
                                task.status,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: color,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                          ],
                        ),

                        Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.file_present, size: 20,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Text(task.taskSize),
                                      )
                                    ],
                                  ),
                                  // Text(task.startDate, style: const TextStyle(fontSize: 14)),
                                  Text(
                                      '(${task.downloadedSize}) ${(task.progress * 100).toStringAsFixed(2)}%',
                                      style: const TextStyle(fontSize: 14)
                                  ),
                                ]
                            )
                        )
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: LinearProgressIndicator(
                          value: task.progress,
                          color: color,
                          backgroundColor: Colors.grey[300],
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.arrow_upward, size: 20,),
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(task.uploadSpeed),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.arrow_downward, size: 20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(task.downloadSpeed),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        )
    );
  }
}