import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LTaskCard extends StatefulWidget {
  final Function(String link, int points, String title) addTask;
  final Function(Map<String, dynamic> task) updateTask;
  final Function(String task_id) deleteTask;
  final Map<String, dynamic>? task;
  final Function hideOverlay;

  const LTaskCard({
    super.key,
    required this.hideOverlay,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    this.task,
  });

  @override
  State<LTaskCard> createState() => _LTaskCardState();
}

class _LTaskCardState extends State<LTaskCard> {
  late TextEditingController linkCtl, pointCtl, titleCtl;
  late bool isReadOnly;

  @override
  void initState() {
    super.initState();
    isReadOnly = widget.task != null;
    linkCtl = TextEditingController(
      text: widget.task != null ? widget.task!['link'] : '',
    );
    pointCtl = TextEditingController(
      text: widget.task != null ? '${widget.task!['points']}' : '',
    );
    titleCtl = TextEditingController(
      text: widget.task != null ? widget.task!['title'] : '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFADDC1),
        borderRadius: BorderRadius.circular(10),
      ),
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        spacing: 20,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Learning Tasks",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFFF830A),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "YouTube Link",
                        style: TextStyle(
                          color: Color(0xFFFF830A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFD1A4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: TextField(
                          controller: linkCtl,
                          enabled: !isReadOnly,
                          decoration: InputDecoration(
                            // hintText: "Ask anything",
                            border:
                                InputBorder
                                    .none, // No border for the text field
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Points",
                        style: TextStyle(
                          color: Color(0xFFFF830A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFD1A4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: TextField(
                          controller: pointCtl,
                          enabled: !isReadOnly,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            // hintText: "Ask anything",
                            border:
                                InputBorder
                                    .none, // No border for the text field
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: TextStyle(
                      color: Color(0xFFFF830A),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFD1A4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: titleCtl,
                      enabled: !isReadOnly,
                      decoration: InputDecoration(
                        // hintText: "Ask anything",
                        border:
                            InputBorder.none, // No border for the text field
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (widget.task != null) {
                      widget.updateTask({
                        'task_id': widget.task!['task_id'],
                        'link': linkCtl.text.trim(),
                        'points': int.tryParse(pointCtl.text.trim()) ?? 0,
                        'title': titleCtl.text.trim(),
                        'is_done': true,
                      });
                    }
                    widget.hideOverlay(context);
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF9CD8FD),
                    ),
                    child: Text(
                      "Done",
                      style: TextStyle(
                        color: Color(0xFF0060FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.hideOverlay(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFFF830A)),
                      // color: Color(0xFF9CD8FD)
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xFFFF830A),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
