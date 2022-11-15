// import 'dart:convert';
import 'package:vigenesia/Models/motivasi_model.dart';
import 'edit_page.dart';
import 'motivasi_page.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'login.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

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
    try {
      final response =
          await dio.delete('$baseurl/vigenesia/api/motivations/$id');
      print(' ${response.data}');
      return response;
    } catch (e) {
      print('Error di -> $e');
    }
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
    // ignore: void_checks
    setState(() {
      getData();
      listproduk.clear();
      return const CircularProgressIndicator();
    });
  }

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
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      MotivasiPage(idUser: widget.idUser),
                ));
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.history_edu_sharp),
        ),
        body: SingleChildScrollView(
          // <-- Berfungsi Untuk Bisa Scroll
          child: RefreshIndicator(
            onRefresh: () async {
              await _getData();
            },
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
                            'Halo, ${widget.nama} ~',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const Login()));
                            },
                            style: OutlinedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(24),
                            ),
                            child: const Icon(Icons.logout_sharp),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomRadioButton(
                        elevation: 0,
                        horizontal: false,
                        autoWidth: true,
                        padding: 5,
                        enableButtonWrap: true,
                        wrapAlignment: WrapAlignment.center,
                        enableShape: true,
                        unSelectedColor: Theme.of(context).canvasColor,
                        buttonLables: const [
                          'Motivasi',
                          'Motivasi Kamu',
                        ],
                        buttonValues: const [
                          "MOTIVASI",
                          "MOTIVASI_KAMU",
                        ],
                        buttonTextStyle: const ButtonTextStyle(
                            selectedColor: Colors.white,
                            unSelectedColor: Colors.black,
                            textStyle: TextStyle(fontSize: 16)),
                        radioButtonValue: (value) {
                          setState(() {
                            trigger = value;
                            print(
                                ' HASILNYA --> $trigger'); // hasil ganti value
                          });
                        },
                        selectedColor: Theme.of(context).colorScheme.secondary,
                      ),
                      trigger == "MOTIVASI"
                          ? FutureBuilder(
                              future: getData2(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<MotivasiModel>> snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      for (var item in snapshot.data)
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.only(
                                              right: 10,
                                              top: 20,
                                              left: 10,
                                              bottom: 10),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey)),
                                          ),
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    item.judul,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      child: Text(
                                                        item.isiMotivasi,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      )),
                                                  Text(
                                                    '${item.nama} - ${item.tanggalInput}',
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    'diubah: ${item.tanggalUpdate}',
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              )
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
                      trigger == "MOTIVASI_KAMU"
                          ? FutureBuilder(
                              future: getData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<MotivasiModel>> snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      for (var item in snapshot.data)
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.only(
                                              right: 10, top: 20, left: 10),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey)),
                                          ),
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: [
                                              Column(children: [
                                                Text(
                                                  item.judul,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: Text(
                                                      item.isiMotivasi,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    )),
                                                Text(
                                                  '${item.tanggalInput}',
                                                  style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.grey),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: Text(
                                                    'diubah: ${item.tanggalUpdate}',
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                DecoratedBox(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border(
                                                          top: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.grey)),
                                                    ),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextButton.icon(
                                                            label: const Text(
                                                                'Edit',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black)),
                                                            icon: const Icon(
                                                                Icons
                                                                    .drive_file_rename_outline_sharp,
                                                                color: Colors
                                                                    .black),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (BuildContext context) => EditPage(
                                                                        id: item
                                                                            .id,
                                                                        isiMotivasi:
                                                                            item
                                                                                .isiMotivasi,
                                                                        judul: item
                                                                            .judul),
                                                                  ));
                                                            },
                                                          ),
                                                          TextButton.icon(
                                                            label: const Text(
                                                                'Hapus',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black)),
                                                            icon: const Icon(
                                                                Icons
                                                                    .delete_outline_sharp,
                                                                color: Colors
                                                                    .black),
                                                            onPressed:
                                                                () async {
                                                              await deletePost(
                                                                      item.id)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            if (value !=
                                                                                null)
                                                                              {
                                                                                Flushbar(
                                                                                  message: 'Berhasil Delete',
                                                                                  duration: const Duration(seconds: 2),
                                                                                  backgroundColor: Colors.redAccent,
                                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                                ).show(context)
                                                                              }
                                                                          });
                                                              _getData();
                                                            },
                                                          )
                                                        ])),
                                              ]),
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
        ));
  }
}
