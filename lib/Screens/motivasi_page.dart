// import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:vigenesia/Constant/const.dart';
// import 'package:vigenesia/Models/motivasi_model.dart';

class MotivasiPage extends StatefulWidget {
  final String idUser;
  const MotivasiPage({Key key, this.idUser}) : super(key: key);
  @override
  MotivasiPageState createState() => MotivasiPageState();
}

class MotivasiPageState extends State<MotivasiPage> {
  String baseurl = url;
  var dio = Dio();
  Future sendMotivasi(String isi, String judul) async {
    dynamic body = {'isi_motivasi': isi, 'judul': judul};
    try {
      final response = await dio.post(
          '$baseurl/vigenesia/api/motivations/${widget.idUser}',
          data: body,
          options: Options(headers: {
            'Content-type': 'application/json'
          })); // Formatnya Harus Form Data
      print('Respon -> ${response.data} + ${response.statusCode}');
      return response;
    } catch (e) {
      print('Error di -> $e');
    }
  }

  TextEditingController isiMotivasiC = TextEditingController();
  TextEditingController judulC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivasi Baru'),
        elevation: 0,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormBuilderTextField(
                name: 'judul',
                controller: judulC,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintText: "Judul",
                  fillColor: Colors.white70,
                  hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800]),
                ),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'isi_motivasi',
                controller: isiMotivasiC,
                keyboardType: TextInputType.multiline,
                maxLines: 15,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintText: "Isi Motivasi",
                  fillColor: Colors.white70,
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  sendMotivasi(isiMotivasiC.text, judulC.text).then((value) => {
                        if (value != null)
                          {
                            Navigator.pop(context),
                            Flushbar(
                              message: 'Berhasil Tambah Motivasi',
                              duration: const Duration(seconds: 5),
                              backgroundColor: Colors.green,
                              flushbarPosition: FlushbarPosition.TOP,
                            ).show(context)
                          }
                      });
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shadowColor: Colors.transparent,
                    shape: const StadiumBorder()),
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      )),
    );
  }
}
