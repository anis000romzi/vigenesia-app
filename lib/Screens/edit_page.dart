import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:vigenesia/Constant/const.dart';
// import 'package:vigenesia/Models/motivasi_model.dart';

class EditPage extends StatefulWidget {
  final String id;
  final String isiMotivasi;
  final String judul;
  const EditPage({Key key, this.id, this.isiMotivasi, this.judul})
      : super(key: key);
  @override
  EditPageState createState() => EditPageState();
}

class EditPageState extends State<EditPage> {
  String baseurl = url;
  var dio = Dio();
  Future putPost(String isiMotivasi, String judul) async {
    dynamic data = {'isi_motivasi': isiMotivasi, 'judul': judul};
    var response =
        await dio.put('$baseurl/vigenesia/api/motivations/${widget.id}',
            data: data,
            options: Options(headers: {
              'Content-type': 'application/json',
            }));
    print('---> ${response.data} + ${response.statusCode}');
    return response.data;
  }

  TextEditingController isiMotivasiC = TextEditingController();
  TextEditingController judulC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Motivasi'),
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
                controller: judulC..text = widget.judul,
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
                controller: isiMotivasiC..text = widget.isiMotivasi,
                keyboardType: TextInputType.multiline,
                maxLines: 15,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintText: "Isi Motivasi",
                  fillColor: Colors.white70,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  putPost(isiMotivasiC.text, judulC.text).then((value) => {
                        if (value != null)
                          {
                            Navigator.pop(context),
                            Flushbar(
                              message: 'Berhasil Update & Refresh dulu',
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
                    padding: const EdgeInsets.all(24),
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
