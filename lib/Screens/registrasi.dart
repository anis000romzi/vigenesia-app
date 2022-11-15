import 'package:vigenesia/Constant/const.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'login.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dio/dio.dart';

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);
  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  String baseurl = url;
  bool _passwordVisible;

  Future postRegister(
      String nama, String profesi, String email, String password) async {
    var dio = Dio();
    dynamic data = {
      'nama': nama,
      'profesi': profesi,
      'email': email,
      'password': password
    };
    try {
      final response = await dio.post('$baseurl/vigenesia/api/users',
          data: data,
          options: Options(headers: {'Content-type': 'application/json'}));
      print('Respon -> ${response.data} + ${response.statusCode}');
      if (response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      print('Failed To Load $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController profesiController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Register Your Account',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 50),
                  FormBuilderTextField(
                    name: 'name',
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      hintText: "Nama",
                      fillColor: Colors.white70,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormBuilderTextField(
                    name: 'profesi',
                    controller: profesiController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      hintText: "Profesi",
                      fillColor: Colors.white70,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormBuilderTextField(
                    name: 'email',
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      hintText: "Email",
                      fillColor: Colors.white70,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    obscureText: !_passwordVisible,
                    name: 'password',
                    controller: passwordController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          }),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      hintText: "Password",
                      fillColor: Colors.white70,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: () async {
                          await postRegister(
                                  nameController.text,
                                  profesiController.text,
                                  emailController.text,
                                  passwordController.text)
                              .then((value) => {
                                    if (value != null)
                                      {
                                        setState(() {
                                          Navigator.pop(context);
                                          Flushbar(
                                            message: 'Berhasil Registrasi',
                                            duration:
                                                const Duration(seconds: 2),
                                            backgroundColor: Colors.greenAccent,
                                            flushbarPosition:
                                                FlushbarPosition.TOP,
                                          ).show(context);
                                        })
                                      }
                                    else if (value == null)
                                      {
                                        Flushbar(
                                          message:
                                              'Check Your Field Before Register',
                                          duration: const Duration(seconds: 5),
                                          backgroundColor: Colors.redAccent,
                                          flushbarPosition:
                                              FlushbarPosition.TOP,
                                        ).show(context)
                                      }
                                  });
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.all(24),
                            shape: const StadiumBorder()),
                        child: const Text('Daftar')),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Login()));
                      },
                      style: OutlinedButton.styleFrom(
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Kembali'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
