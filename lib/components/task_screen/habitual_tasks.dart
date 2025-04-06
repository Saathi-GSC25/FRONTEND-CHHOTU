import 'package:flutter/material.dart';
import 'package:saathi_chhotu/components/task_screen/htask_card.dart';
import 'dart:ui';
import 'package:saathi_chhotu/components/task_screen/top_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HabitualTasks extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;
  const HabitualTasks({super.key, required this.tasks});

  @override
  State<HabitualTasks> createState() => _HabitualTasksState();
}

class _HabitualTasksState extends State<HabitualTasks> {
  void onTap(BuildContext context) {}
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context, {Map<String, dynamic>? task}) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Material(
            color: Colors.transparent,
            child: SafeArea(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => _hideOverlay(context),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(color: Colors.black.withAlpha(125)),
                    ),
                  ),
                  Column(
                    children: [
                      TopBar(),
                      Expanded(
                        child: Center(
                          child: HTaskCard(
                            hideOverlay: _hideOverlay,
                            addTask: addTask,
                            updateTask: updateTask,
                            deleteTask: deleteTask,
                            task: task,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay(BuildContext context) {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  void addTask(String from, String to, int points, String title) async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionCookie = prefs.getString('session_cookie');
    if (sessionCookie == null) {
      return;
    }

    Map<String, dynamic> newTask = {
      'from_time': from,
      'to_time': to,
      'title': title,
      'points': points,
      'is_done': false,
    };

    try {
      final response = await http.post(
        Uri.parse("${dotenv.env['BASE_URL']}/common/habitual/"),
        headers: {"Content-Type": "application/json", 'Cookie': sessionCookie},
        body: jsonEncode(newTask),
      );
      print(response.body);
      if (response.statusCode == 201) {
        setState(() {
          widget.tasks.add(Map<String, dynamic>.from(newTask));
        });
        _hideOverlay(
          context,
        ); // hide the overlay after successful task addition
      } else {
        print("Failed to add task: ${response.statusCode}");
        // Optionally show a snackbar or dialog
      }
    } catch (e) {
      print("Error while posting task: $e");
    }
  }

  void updateTask(Map<String, dynamic> updatedTask) async {
    print('here');
    final prefs = await SharedPreferences.getInstance();
    String? sessionCookie = prefs.getString('session_cookie');
    if (sessionCookie == null) {
      print("No session cookie found");
      return;
    }
    print(updatedTask);
    try {
      final response = await http.put(
        Uri.parse("${dotenv.env['BASE_URL']}/common/habitual/"),
        headers: {"Content-Type": "application/json", "Cookie": sessionCookie},
        body: jsonEncode(updatedTask),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Task updated successfully
        setState(() {
          for (int i = 0; i < widget.tasks.length; i++) {
            if (widget.tasks[i]['task_id'] == updatedTask['task_id']) {
              widget.tasks[i] = updatedTask;
              break;
            }
          }
        });
        print("Task updated successfully");
      } else {
        print("Failed to update task: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("Error while updating task: $e");
    }
  }

  void deleteTask(String taskId) async {
    print('here');
    final prefs = await SharedPreferences.getInstance();
    String? sessionCookie = prefs.getString('session_cookie');
    if (sessionCookie == null) {
      print("No session cookie found");
      return;
    }
    try {
      final response = await http.delete(
        Uri.parse("${dotenv.env['BASE_URL']}/common/habitual/"),
        headers: {"Content-Type": "application/json", "Cookie": sessionCookie},
        body: jsonEncode({'task_id': taskId}),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Task updated successfully
        setState(() {
          for (int i = 0; i < widget.tasks.length; i++) {
            if (widget.tasks[i]['task_id'] == taskId) {
              widget.tasks.removeAt(i);
              break;
            }
          }
        });
        print("Task delete successfully");
      } else {
        print("Failed to delete task: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("Error while delete task: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFFADDC1),
        borderRadius: BorderRadius.circular(10),
      ),
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Habitual Tasks",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFFF830A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8),
              // padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                // color: Color(0xFFFFD1A4),
                color: Color(0xFFFADDC1),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  widget.tasks.isEmpty
                      ? Center(
                        child: Text(
                          "No tasks created yet",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 35,
                            color: Color(0xFF363636),
                          ),
                        ),
                      )
                      : DefaultTextStyle(
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        child: SingleChildScrollView(
                          child: Table(
                            columnWidths: {
                              0: IntrinsicColumnWidth(),
                              1: FlexColumnWidth(),
                              2: IntrinsicColumnWidth(),
                            },
                            children:
                                widget.tasks.map<TableRow>((row) {
                                  return TableRow(
                                    decoration: BoxDecoration(
                                      color:
                                          row['is_done']
                                              ? Color(0xFFFFD1A4).withAlpha(125)
                                              : Color(0xFFFFD1A4),
                                    ),
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 8,
                                          top: 16,
                                          bottom: 16,
                                        ),
                                        child: Text(
                                          '${row['from_time']} - ${row['to_time']}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 16,
                                        ),
                                        child:
                                            row['is_done']
                                                ? Text(
                                                  row['title'],
                                                ) // Unclickable
                                                : GestureDetector(
                                                  onTap:
                                                      () => _showOverlay(
                                                        context,
                                                        task: row,
                                                      ),
                                                  child: Text(row['title']),
                                                ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 8,
                                          top: 16,
                                          bottom: 16,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.currency_bitcoin,
                                              color: Color(0xFFFF830A),
                                            ),
                                            Text('${row['points']}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
