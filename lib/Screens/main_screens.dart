import 'dart:convert';
import 'package:vigenesia/Models/motivasi_model.dart';
import 'edit_page.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'login.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:another_flushbar/flushbar.dart';

class MainScreens extends StatefulWidget {
  final String idUser;
  final String nama;
  const MainScreens({Key key, this.nama, this.idUser}) : super(key: key);
  @override
  MainScreensState createState() => MainScreensState();
}

class MainScreensState extends State<MainScreens> {
  String baseurl = url;
  String id;
  var dio = Dio();
  List<MotivasiModel> ass = [];
  TextEditingController titleController = TextEditingController();
  Future sendMotivasi(String isi) async {
    dynamic body = {
      'isi_motivasi': isi,
      // 'iduser': widget.idUser
    }; // [Tambah IDUSER -> Widget.iduser]
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

  List<MotivasiModel> listproduk = [];
  Future<List<MotivasiModel>> getData() async {
    var response = await dio.get(
        '$baseurl/vigenesia/api/motivations/${widget.idUser}'); // NGambil by data
    print(' ${response.data}');
    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers =
          getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> deletePost(String id) async {
    dynamic data = {
      'id': id,
    };
    var response = await dio.delete('$baseurl/vigenesia/api/dev/DELETEmotivasi',
        data: data,
        options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {'Content-type': 'application/json'}));
    print(' ${response.data}');
    var resbody = jsonDecode(response.data);
    return resbody;
  }

  Future<List<MotivasiModel>> getData2() async {
    var response = await dio
        .get('$baseurl/vigenesia/api/motivations'); // Ngambil by ALL USER
    print(' ${response.data}');
    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers =
          getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<void> _getData() async {
    setState(() {
      getData();
      listproduk.clear();
      return const CircularProgressIndicator();
    });
  }

  TextEditingController isiController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getData();
    getData2();
    _getData();
  }

  String trigger;
  String triggeruser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // <-- Berfungsi Untuk Bisa Scroll
        child: SafeArea(
          // < -- Biar Gak Keluar Area Screen HP
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .center, // <-- Berfungsi untuk atur nilai X jadi tengah
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hallo ${widget.nama}',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                          child: const Icon(Icons.logout),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const Login()));
                          })
                    ],
                  ),
                  const SizedBox(height: 20), // <-- Kasih Jarak Tinggi : 50px
                  FormBuilderTextField(
                    controller: isiController,
                    name: 'isiMotivasi',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: () async {
                          await sendMotivasi(
                            isiController.text,
                          ).then((value) => {
                                if (value != null)
                                  {
                                    Flushbar(
                                      message: 'Berhasil Submit',
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.greenAccent,
                                      flushbarPosition: FlushbarPosition.TOP,
                                    ).show(context)
                                  }
                              });
                          _getData();
                          print('Sukses');
                        },
                        child: const Text('Submit')),
                  ),
                  TextButton(
                    child: const Icon(Icons.refresh),
                    onPressed: () {
                      _getData();
                    },
                  ),
                  FormBuilderRadioGroup(
                      onChanged: (value) {
                        setState(() {
                          trigger = value;
                          print(' HASILNYA --> $trigger'); // hasil ganti value
                        });
                      },
                      name: '_',
                      options: ['Motivasi By All', 'Motivasi By User']
                          .map((e) =>
                              FormBuilderFieldOption(value: e, child: Text(e)))
                          .toList()),
                  trigger == 'Motivasi By All'
                      ? FutureBuilder(
                          future: getData2(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<MotivasiModel>> snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  for (var item in snapshot.data)
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          Text(item.isiMotivasi),
                                        ],
                                      ),
                                    ),
                                ],
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data.isEmpty) {
                              return const Text('No Data');
                            } else {
                              return const CircularProgressIndicator();
                            }
                          })
                      : Container(),
                  trigger == 'Motivasi By User'
                      ? FutureBuilder(
                          future: getData(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<MotivasiModel>> snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  for (var item in snapshot.data)
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          Card(
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                Text(item.isiMotivasi),
                                                Row(children: [
                                                  TextButton(
                                                    child: const Icon(
                                                        Icons.settings),
                                                    onPressed: () {
                                                      // String id;
                                                      // String isiMotivasi;
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                EditPage(
                                                                    id: item.id,
                                                                    isiMotivasi:
                                                                        item.isiMotivasi),
                                                          ));
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Icon(
                                                        Icons.delete),
                                                    onPressed: () {
                                                      deletePost(item.id)
                                                          .then((value) => {
                                                                if (value !=
                                                                    null)
                                                                  {
                                                                    Flushbar(
                                                                      message:
                                                                          'Berhasil Delete',
                                                                      duration: const Duration(
                                                                          seconds:
                                                                              2),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .redAccent,
                                                                      flushbarPosition:
                                                                          FlushbarPosition
                                                                              .TOP,
                                                                    ).show(
                                                                        context)
                                                                  }
                                                              });
                                                      _getData();
                                                    },
                                                  )
                                                ]),
                                              ])),
                                        ],
                                      ),
                                    ),
                                ],
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data.isEmpty) {
                              return const Text('No Data');
                            } else {
                              return const CircularProgressIndicator();
                            }
                          })
                      : Container(),
                ]),
          ),
        ),
      ),
    );
  }
}
