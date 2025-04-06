import 'package:flutter/material.dart';
import 'package:saathi_chhotu/components/task_screen/habitual_tasks.dart';
import 'package:saathi_chhotu/components/task_screen/learning_tasks.dart';
import 'package:saathi_chhotu/components/task_screen/top_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  Map<String, List<Map<String, dynamic>>> tasks = {
    "habitual": [],
    "learning": [],
  };

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionCookie = prefs.getString('session_cookie');
    if (sessionCookie == null) {
      return;
    }
    print(sessionCookie);
    try {
      final habitualResponse = await http.get(
        Uri.parse("${dotenv.env['BASE_URL']}/common/habitual/"),
        headers: {'Content-Type': 'application/json', 'Cookie': sessionCookie},
      );
      print(habitualResponse.body);
      final learningResponse = await http.get(
        Uri.parse("${dotenv.env['BASE_URL']}/common/learning/"),
        headers: {'Content-Type': 'application/json', 'Cookie': sessionCookie},
      );
      print(learningResponse.body);
      print(habitualResponse.statusCode);
      print(learningResponse.statusCode);
      if (habitualResponse.statusCode == 200 &&
          learningResponse.statusCode == 200) {
        print("inside");
        print(json.decode(habitualResponse.body));
        final List<dynamic> habitualData =
            json.decode(habitualResponse.body)['habitual_tasks'];
        final List<dynamic> learningData =
            json.decode(learningResponse.body)['learning_tasks'];
        print('here');
        setState(() {
          tasks = {
            "habitual": List<Map<String, dynamic>>.from(habitualData),
            "learning": List<Map<String, dynamic>>.from(learningData),
          };
          print(tasks);
        });
      } else {
        print('Failed to load tasks');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void onTap(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          spacing: 10,
          children: [
            TopBar(),
            HabitualTasks(tasks: tasks['habitual']!),
            LearningTasks(tasks: tasks['learning']!),
          ],
        ),
      ),
    );
  }
}
