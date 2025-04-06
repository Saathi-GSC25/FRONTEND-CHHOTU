import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HTaskCard extends StatefulWidget {
  final Function(String from, String to, int points, String title) addTask;
  final Function(Map<String, dynamic> task) updateTask;
  final Function(String task_id) deleteTask;
  final Map<String, dynamic>? task;
  final Function hideOverlay;

  const HTaskCard({
    super.key,
    required this.hideOverlay,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    this.task,
  });

  @override
  State<HTaskCard> createState() => _HTaskCardState();
}

class _HTaskCardState extends State<HTaskCard> {
  late TextEditingController fromCtl, toCtl, pointCtl, titleCtl;
  late bool isReadOnly;

  String formatToHHMM(String? time) {
    if (time == null || time.isEmpty) return '';
    final parts = time.split(':');
    if (parts.length >= 2) {
      final hh = parts[0].padLeft(2, '0');
      final mm = parts[1].padLeft(2, '0');
      return '$hh:$mm';
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    isReadOnly = widget.task != null;
    fromCtl = TextEditingController(
      text: widget.task != null ? formatToHHMM(widget.task!['from_time']) : '',
    );
    toCtl = TextEditingController(
      text: widget.task != null ? formatToHHMM(widget.task!['to_time']) : '',
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
              "Habitual Tasks",
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
                        "Time",
                        style: TextStyle(
                          color: Color(0xFFFF830A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFFD1A4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: TextField(
                              controller: fromCtl,
                              enabled: !isReadOnly,
                              decoration: InputDecoration(
                                hintText: "From",
                                border:
                                    InputBorder
                                        .none, // No border for the text field
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '-',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFFD1A4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: TextField(
                              controller: toCtl,
                              enabled: !isReadOnly,
                              decoration: InputDecoration(
                                hintText: "To",
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
                        'from_time': fromCtl.text.trim(),
                        'to_time': toCtl.text.trim(),
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
