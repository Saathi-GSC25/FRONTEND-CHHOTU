import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final hashedPassword = base64.encode(utf8.encode(password));
    print(hashedPassword);

    try {
      final response = await http.post(
        Uri.parse('https://7153-14-139-185-115.ngrok-free.app/child/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': hashedPassword}),
      );

      if (response.statusCode == 200) {
        String? sessionCookie = response.headers['set-cookie'];
        if (sessionCookie != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('session_cookie', sessionCookie);
          print("Session cookie saved: $sessionCookie");
        }

        print('Login successful');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login successful')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        print('Login failed');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please check your credentials.'),
          ),
        );
      }
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Section with Image and Text
          Container(
            height: 250,
            child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/icons/logobg.svg', // Your SVG file path
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                  left: 32,
                  bottom: 32,
                  right: 32,
                  child: const Text(
                    'Sign in to your account',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Spacing between the container and login form
          // Login Form Section
          Padding(
            padding: const EdgeInsets.only(
              bottom: 48,
              left: 20,
              right: 20,
              top: 48,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 20,
                ), // Adjusted spacing between the header and login form
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Color(0xFFB0B0B0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF93A6D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),

          // Logo at the Bottom
          Padding(
            padding: const EdgeInsets.only(top: 160),
            child: Center(
              child: SvgPicture.asset('assets/icons/logo.svg', height: 80),
            ),
          ),
        ],
      ),
    );
  }
}
