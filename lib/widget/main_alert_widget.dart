import 'package:flutter/material.dart';
import 'package:syno_downlaodstation/main.dart';

class MainAlertWidget extends StatefulWidget {
  const MainAlertWidget({super.key, required this.alertValue});
  final String alertValue;

  @override
  State<MainAlertWidget> createState() => MainAlertWidgetState();
}

class MainAlertWidgetState extends State<MainAlertWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Container(
              key: const Key("loading"),
              padding: const EdgeInsets.fromLTRB(16, 2, 4, 2),
              // padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              alignment: Alignment.center,
              color: Colors.amber,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                            widget.alertValue,
                            style: const TextStyle(fontWeight: FontWeight.bold)
                        ),
                      )
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      ServerDetailPageState? parent = context.findAncestorStateOfType<ServerDetailPageState>();
                      parent?.setState(() {
                        parent.alertBool = false;
                      });
                    },
                  )
                ],
              ),
            )
          ),
        ),
      ],
    );
  }
}