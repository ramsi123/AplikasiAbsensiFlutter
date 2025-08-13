import 'package:aplikasi_absensi/components/my_textfield.dart';
import 'package:aplikasi_absensi/pages/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // email and pw controllers
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // text
                    Text(
                      'Aplikasi Absensi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),

                    SizedBox(height: 25),

                    // email textfield
                    MyTextfield(
                      controller: _emailController,
                      title: 'Email',
                      obscureText: false,
                      hintText: 'Masukkan Email',
                    ),

                    SizedBox(height: 10),

                    // password textfield
                    MyTextfield(
                      controller: _pwController,
                      title: 'Password',
                      obscureText: true,
                      hintText: 'Masukkan Password',
                    ),

                    SizedBox(height: 35),

                    // login button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          if (_emailController.text.contains(
                                'admin123@gmail.com',
                              ) &&
                              _pwController.text.contains('password')) {
                            Navigator.push(context, HomePage.route());

                            // clear textfield
                            _emailController.clear();
                            _pwController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('email atau password salah'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
