import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/authentication/auth_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/authentication/auth_event.dart';
import 'package:flutter_ecommerce_project/bloc/authentication/auth_state.dart';
import 'package:flutter_ecommerce_project/screens/dashbord_screen.dart';
import 'package:flutter_ecommerce_project/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const ViewContainer(),
    );
  }
}

class ViewContainer extends StatefulWidget {
  const ViewContainer({super.key});

  @override
  State<ViewContainer> createState() => _ViewContainerState();
}

class _ViewContainerState extends State<ViewContainer> {
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  bool _obscureText = true;

  @override
  void dispose() {
    _usernameTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                    width: 160,
                    height: 160,
                    child: Image.asset('assets/images/login_photo.jpg')),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'نام کاربری :',
                        style: TextStyle(
                          fontFamily: 'dana',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[300],
                        ),
                        child: TextField(
                          controller: _usernameTextController,
                          style: const TextStyle(
                            fontFamily: 'SM',
                            fontSize: 15,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'رمز عبور :',
                        style: TextStyle(
                          fontFamily: 'dana',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[300],
                        ),
                        child: TextField(
                          controller: _passwordTextController,
                          obscureText: _obscureText,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: const TextStyle(
                            fontFamily: 'SM',
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 15),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthResponseState) {
                      state.response.fold((l) {
                        _usernameTextController.text = '';
                        _passwordTextController.text = '';
                        var snackBar = SnackBar(
                          content: Text(
                            l,
                            style: TextStyle(
                              fontFamily: 'dana',
                              fontSize: 15,
                            ),
                          ),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 1),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }, (r) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const DashbordScreen(),
                          ),
                        );
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthInitiateState) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(
                            fontFamily: 'SB',
                            fontSize: 18,
                          ),
                          minimumSize: Size(200, 50),
                        ),
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context).add(
                            AutLoginRequest(
                              _usernameTextController.text,
                              _passwordTextController.text,
                            ),
                          );
                        },
                        child: Text(
                          'ورود به حساب کاربری',
                          style: TextStyle(
                            fontFamily: 'dana',
                          ),
                        ),
                      );
                    }
                    if (state is AuthLoadingState) {
                      return const CircularProgressIndicator();
                    }
                    if (state is AuthResponseState) {
                      Widget widget = Text('');
                      state.response.fold((l) {
                        widget = ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontFamily: 'SB',
                              fontSize: 18,
                            ),
                            minimumSize: const Size(200, 50),
                          ),
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context).add(
                              AutLoginRequest(
                                _usernameTextController.text,
                                _passwordTextController.text,
                              ),
                            );
                          },
                          child: const Text(
                            'ورود به حساب کاربری',
                            style: TextStyle(
                              fontFamily: 'dana',
                            ),
                          ),
                        );
                      }, (r) {
                        widget = Text(
                          r,
                          style: const TextStyle(color: Colors.green),
                        );
                      });
                      return widget;
                    }
                    return const Text('خطای نامشخص');
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'اگر حساب کاربری ندارید ثبت نام کنید',
                    style: TextStyle(
                      fontFamily: 'dana',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
