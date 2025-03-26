import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int points = 100;
  Map<String, dynamic>? childDetails;

  @override
  void initState() {
    super.initState();
    fetchChildDetails();
  }

  Future<void> fetchChildDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionCookie = prefs.getString('session_cookie');

    if (sessionCookie == null) {
      print("Session cookie not found!");
      return;
    }
    final response = await http.post(
      Uri.parse('https://7153-14-139-185-115.ngrok-free.app/child/details'),
      headers: {'Content-Type': 'application/json', 'Cookie': sessionCookie},
    );

    if (response.statusCode == 200) {
      setState(() {
        childDetails = jsonDecode(response.body);
      });
      print("Child Details: $childDetails");
    } else {
      print(
        "Failed to load child details. Status Code: ${response.statusCode}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Half: Greeting with Points and Logout
          Expanded(
            child: Stack(
              children: [
                // Pink Background Container (Bottom Layer)
                Container(
                  color: const Color(0xFFFCCBC4).withOpacity(0.8),
                  width: double.infinity,
                  height: double.infinity,
                ),

                // SVG Background Container (Middle Layer)
                Positioned.fill(
                  child: SvgPicture.asset(
                    'assets/icons/bg-1.svg',
                    fit: BoxFit.cover,
                  ),
                ),

                // Text and Content Container (Top Layer)
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Points and Logout Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/points.svg',
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$points',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Greeting Message
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Hey ${childDetails?['name'] ?? "loading..."}!\nWelcome back!',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xBF000000),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Half: Four Buttons
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1,
              padding: const EdgeInsets.all(10),
              children: [
                _buildFunctionalityButton(
                  'Talk to Aasha',
                  'assets/icons/profile.svg',
                  const Color(0xFFC7E7FB),
                  const Color(0xFF69C5FF),
                  const Color(0xFF9CD8FD),
                  const Color(0xFF069DFD),
                ),
                _buildFunctionalityButton(
                  'Today’s Schedule',
                  'assets/icons/list.svg',
                  const Color(0xFFFADDC1),
                  const Color(0xFFFFB771),
                  const Color(0xFFFFD1A4),
                  const Color(0xFFFF8D1D),
                ),
                _buildFunctionalityButton(
                  'Practice Speaking',
                  'assets/icons/talk.svg',
                  const Color(0xFFFAD4C6),
                  const Color(0xFFFFAA8A),
                  const Color(0xFFFBB59B),
                  const Color(0xFFFF5A1C),
                ),
                _buildFunctionalityButton(
                  'Schedule Calls',
                  'assets/icons/call.svg',
                  const Color(0xFFF8EDBD),
                  const Color(0xFFFFE058),
                  const Color(0xFFFFE886),
                  const Color(0xFFBE9B00),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionalityButton(
    String text,
    String svgPath,
    Color color1,
    Color color2,
    Color color3,
    Color color4,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => Scaffold(
                    appBar: AppBar(title: Text(text)),
                    body: Center(child: Text('$text Screen')),
                  ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shadowColor: color2,
          backgroundColor: color1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color3,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SvgPicture.asset(svgPath, height: 32, width: 32),
              ),
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
