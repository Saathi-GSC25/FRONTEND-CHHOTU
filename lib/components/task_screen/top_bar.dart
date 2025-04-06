import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Color(0xFFFADDC1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFFFD1A4),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Icon(Icons.event_note, color: Color(0xFFFF830A))
          ),
          Text(
            "Task Manager",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 18,
              color: Color(0xFFFF830A),
              fontWeight: FontWeight.bold
            )
          )
        ]
      )
    );
  }
}