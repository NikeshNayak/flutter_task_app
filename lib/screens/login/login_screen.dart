import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  var _loginPasswordVisible = false;

  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isValidate = false;

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: CustomPaint(
                      painter: CurvePainter(Theme.of(context).primaryColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 60),
                          const Align(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  const Text(
                                    'Welcome back',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'We are Happy to see you again',
                                    style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  _userNameInputField(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  _passwordInputField(),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  _isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        )
                                      : _loginButton(),
                                  const SizedBox(
                                    height: 80,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _userNameInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 3,
                color: Colors.grey.shade400,
              ),
            ],
          ),
          child: TextFormField(
            controller: _userIdController,
            decoration: const InputDecoration(
              hintText: 'User Id',
              labelStyle: TextStyle(color: Colors.black),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.person),
            ),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
              setState(() {});
            },
          ),
        ),
        if (_isValidate && _passwordController.text.isEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  'Please enter a userId !',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _passwordInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 3,
                color: Colors.grey.shade400,
              ),
            ],
          ),
          child: TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Password',
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _loginPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: _passwordFocusNode.hasFocus ? Theme.of(context).primaryColor : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _loginPasswordVisible = !_loginPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !_loginPasswordVisible,
          ),
        ),
        if (_isValidate && _passwordController.text.isEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  'Please enter a password !',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      onPressed: () {
        setState(() {
          _isValidate = true;
        });
        if (!_formKey.currentState!.validate()) {
          return;
        }
        login();
      },
    );
  }

  void login() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await dio.post('/auth/login', queryParameters: {
        'username': _userIdController.text,
        'password': _passwordController.text,
      });
      final responseData = jsonDecode(response.data) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final token = responseData['token'] as String;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
      rethrow;
    }
  }

  void showSnackMessage({required BuildContext context, required String title, required String text, required IconData icon, Color color = Colors.red, int seconds = 3}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    text,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
        backgroundColor: color,
      ),
    );
  }

}

class CurvePainter extends CustomPainter {
  final Color color;

  CurvePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(size.width / 2, size.height / 2, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
