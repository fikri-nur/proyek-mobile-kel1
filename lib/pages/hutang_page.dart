import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyek_uts_flutter/models/hutangpiutang.dart';
import 'package:proyek_uts_flutter/models/peminjam.dart';
import 'package:proyek_uts_flutter/pages/navigationbar.dart';

class HutangPage extends StatefulWidget {
  final Peminjam peminjam;

  const HutangPage({Key? key, required this.peminjam}) : super(key: key);

  @override
  _HutangPageState createState() => _HutangPageState();
}

class _HutangPageState extends State<HutangPage> {
  TextEditingController nominalController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String refPeminjamId = widget.peminjam.id;
    double getTotal = widget.peminjam.total;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5DB075),
        centerTitle: true,
        title: const Text("Masukkan Hutang",
            style: TextStyle(
              fontFamily: 'inter',
            )),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: nominalController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Nominal',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              TextField(
                controller: deskripsiController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.description),
                    labelText: 'Deskripsi',
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
                      backgroundColor: const Color(0xFF5DB075),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  onPressed: () async {
                    await _createHutang(refPeminjamId, getTotal);
                    nominalController.text = '';
                    dateController.text = '';
                    deskripsiController.text = '';

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Navigationbar()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text(
                    "Simpan",
                    style: TextStyle(
                        color: Color(0xffffffff), fontFamily: 'inter'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createHutang(String refPeminjamId, double getTotal) async {
    final _hutang = FirebaseFirestore.instance.collection('hutangpiutang').doc();

    final double? nominal = double.tryParse(nominalController.text);
    final String? date = dateController.text;
    final String? desc = deskripsiController.text;
    if (nominal != null && date != null && desc != null) {
      // Persist a new product to Firestore

      final data = HutangPiutang(
          id: _hutang.id,
          ref_peminjam_id: refPeminjamId,
          status: 'hutang',
          nominal: nominal,
          deskripsi: desc,
          created_at: DateTime.now());

      final json = data.toJson();
      await _hutang.set(json);

      final _peminjam =
          FirebaseFirestore.instance.collection('peminjam').doc(refPeminjamId);
      double count = getTotal + nominal;
      await _peminjam.update({
        "total": count,
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil memasukkan cicilan')));
  }
}
