import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyek_uts_flutter/models/hutangpiutang.dart';
import 'package:proyek_uts_flutter/models/peminjam.dart';
import 'package:proyek_uts_flutter/pages/navigationbar.dart';

class Inputnama extends StatefulWidget {
  const Inputnama({Key? key}) : super(key: key);

  @override
  _InputnamaState createState() => _InputnamaState();
}

class _InputnamaState extends State<Inputnama> {
  TextEditingController nameController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  final _peminjam = FirebaseFirestore.instance.collection('peminjam').doc();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            TextField(
              controller: alamatController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            TextField(
              controller: totalController,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              decoration: InputDecoration(
                  labelText: 'Total',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
            const Padding(
                padding: EdgeInsets.only(top: 54, left: 20, right: 20)),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 45,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF5DB075),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                onPressed: () async {
                  await _create();

                  nameController.text = '';
                  alamatController.text = '';
                  totalController.text = '';

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Navigationbar()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text(
                  "Simpan",
                  style:
                      TextStyle(color: Color(0xffffffff), fontFamily: 'inter'),
                ),
              ),
            )
          ],
        ));
  }

  Future<void> _create() async {
    final String? name = nameController.text;
    final String? alamat = alamatController.text;
    final double? total = double.tryParse(totalController.text);
    if (name != null && alamat != null && total != null) {
      // Persist a new product to Firestore

      final data = Peminjam(
          id: _peminjam.id,
          ref_user_id: FirebaseAuth.instance.currentUser!.uid,
          nama_peminjam: name,
          alamat_peminjam: alamat,
          total: total,
          created_at: DateTime.now());

      final json = data.toJson();

      await _peminjam.set(json);

      final _hutang = FirebaseFirestore.instance.collection('hutangpiutang').doc();

      final inputHutang = HutangPiutang(
          id: _hutang.id,
          ref_peminjam_id: _peminjam.id,
          status: 'hutang',
          nominal: total,
          deskripsi: 'Hutang Awal',
          created_at: DateTime.now());

      final inputJson = inputHutang.toJson();
      await _hutang.set(inputJson);


    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Berhasil Menambah Data')));
  }
}
