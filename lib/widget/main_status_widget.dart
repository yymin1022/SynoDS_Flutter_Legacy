import 'package:flutter/material.dart';
import 'package:filesize/filesize.dart';

class MainStatusWidget extends StatefulWidget {
  const MainStatusWidget({
    super.key,
    required this.uploadSpeed,
    required this.downloadSpeed
  });
  final int uploadSpeed;
  final int downloadSpeed;

  @override
  State<MainStatusWidget> createState() => MainStatusWidgetState();
}

class MainStatusWidgetState extends State<MainStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            // color: Colors.amber,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                '${filesize(widget.uploadSpeed)}/s',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                )
                              ),
                            ),
                            const Icon(Icons.arrow_upward)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.arrow_downward),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '${filesize(widget.downloadSpeed)}/s',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                              )
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}