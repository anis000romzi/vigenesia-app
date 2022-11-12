import 'dart:convert';

List<MotivasiModel> motivasiModelFromJson(String str) =>
    List<MotivasiModel>.from(
        json.decode(str).map((x) => MotivasiModel.fromJson(x)));
String motivasiModelToJson(List<MotivasiModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MotivasiModel {
  MotivasiModel({
    this.id,
    this.isiMotivasi,
    this.idUser,
    // this.idKategori,
    this.tanggalInput,
    this.tanggalUpdate,
    this.nama,
    this.judul,
  });
  String id;
  String isiMotivasi;
  String idUser;
  // String idKategori;
  DateTime tanggalInput;
  String tanggalUpdate;
  String nama;
  String judul;

  factory MotivasiModel.fromJson(Map<String, dynamic> json) => MotivasiModel(
        id: json['id'],
        isiMotivasi: json['isi_motivasi'],
        idUser: json['iduser'],
        // idKategori: json['id_kategori'],
        tanggalInput: json['tanggal_input'],
        tanggalUpdate: json['tanggal_update'],
        nama: json['nama'],
        judul: json['judul'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'isi_motivasi': isiMotivasi,
        'iduser': idUser,
        // 'id_kategori': idKategori,
        'tanggal_input': tanggalInput,
        'tanggal_update': tanggalUpdate,
        'nama': nama,
        'judul': judul,
      };
}
