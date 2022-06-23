import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyek_uts_flutter/models/hutangpiutang.dart';
import 'package:proyek_uts_flutter/models/peminjam.dart';
import 'package:proyek_uts_flutter/pages/cicil_page.dart';
import 'package:proyek_uts_flutter/pages/hutang_page.dart';
import 'package:proyek_uts_flutter/widgets/formatMataUang.dart';

class DetailPage extends StatefulWidget {
  final Peminjam peminjam;
  const DetailPage({Key? key, required this.peminjam}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    Peminjam peminjam = widget.peminjam;

    Stream<List<HutangPiutang>> readDatas() => FirebaseFirestore.instance
        .collection('hutangpiutang')
        .where("ref_peminjam_id", isEqualTo: peminjam.id)
        .orderBy("created_at", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HutangPiutang.fromJson(doc.data()))
            .toList());

    BorderSide _border(String status) {
      if (status == 'cicilan') {
        return BorderSide(color: Color(0xFF5DB075), width: 1);
      } else {
        return BorderSide(color: Color(0xFFb05d85), width: 1);
      }
    }

    Icon _icon(String status) {
      if (status == 'cicilan') {
        return Icon(Icons.article, color: Color(0xFF5DB075), size: 50);
      } else {
        return Icon(Icons.article, color: Color(0xFFb05d85), size: 50);
      }
    }

    Widget buildPeminjam(HutangPiutang data) => SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: Card(
          margin: EdgeInsets.only(top: 8, left: 10, right: 10),
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: _border(data.status)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              _icon(data.status),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(FormatMataUang.convertToIdr(data.nominal, 2),
                      style: TextStyle(
                        fontFamily: 'inter',
                        fontSize: 16,
                      )),
                  Text(data.deskripsi, style: TextStyle(fontSize: 14)),
                ],
              ),
              Spacer(),
              Text(
                DateFormat.yMMMMd().format(data.created_at),
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(width: 10),
            ],
          ),
        ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5DB075),
        centerTitle: true,
        title: Text("Detail: " + peminjam.nama_peminjam,
            style: TextStyle(
              fontFamily: 'inter',
            )),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            decoration: const BoxDecoration(
              color: Color(0xFF5DB075),
            ),
            child: Center(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Text(peminjam.nama_peminjam,
                      style: const TextStyle(
                        fontFamily: 'inter',
                        fontSize: 30,
                      )),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Text(peminjam.alamat_peminjam,
                      style:
                          const TextStyle(fontFamily: 'inter', fontSize: 20)),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Text(FormatMataUang.convertToIdr(peminjam.total, 2),
                      style:
                          const TextStyle(fontFamily: 'inter', fontSize: 26)),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(3),
            height: 450,
            child: Column(
              children: <Widget>[
                Expanded(
                    child: StreamBuilder<List<HutangPiutang>>(
                        stream: readDatas(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          } else if (snapshot.hasData) {
                            final datas = snapshot.data!;
                            return ListView(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: datas.map(buildPeminjam).toList());
                            // children: peminjams.map(buildPeminjam).toList(),
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }))
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 125,
                height: 45,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF5DB075),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CicilPage(peminjam: peminjam)));
                  },
                  child: const Text(
                    "Cicil",
                    style: TextStyle(
                        color: Color(0xffffffff),
                        fontFamily: 'inter',
                        fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                width: 125,
                height: 45,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF5DB075),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HutangPage(peminjam: peminjam)));
                  },
                  child: const Text(
                    "Hutang",
                    style: TextStyle(
                        color: Color(0xffffffff),
                        fontFamily: 'inter',
                        fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
