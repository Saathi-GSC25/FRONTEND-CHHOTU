import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int points = 100; // Example state variable

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
                  color: const Color(
                    0xFFFCCBC4,
                  ).withOpacity(0.8), // Slight opacity
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
                    ), // To avoid the notch area
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
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                );
                              },
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Greeting Message
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Hey Mayank!\nWelcome back!',
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
                  const Color(0xFFFF8D1D), // Peach
                ),
                _buildFunctionalityButton(
                  'Practice Speaking',
                  'assets/icons/talk.svg',
                  const Color(0xFFFAD4C6),
                  const Color(0xFFFFAA8A),
                  const Color(0xFFFBB59B),
                  const Color(0xFFFF5A1C), // Light Coral
                ),
                _buildFunctionalityButton(
                  'Schedule Calls',
                  'assets/icons/call.svg',
                  const Color(0xFFF8EDBD),
                  const Color(0xFFFFE058),
                  const Color(0xFFFFE886),
                  const Color(0xFFBE9B00), // Light Yellow
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
          elevation: 8, // Shadow effect
          shadowColor: color2,
          backgroundColor: color1, // Button color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          padding: const EdgeInsets.all(10),
        ),
        child: Stack(
          children: [
            // SVG inside a rounded square
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
            // Button text positioned a little lower
            Align(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 40,
                ), // Adjusted text position
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color4, // Use variable directly without const
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
