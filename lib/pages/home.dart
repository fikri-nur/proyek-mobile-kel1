import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyek_uts_flutter/models/peminjam.dart';
import 'package:proyek_uts_flutter/pages/detail_page.dart';
import 'package:proyek_uts_flutter/widgets/formatMataUang.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<List<Peminjam>> readPeminjams() => FirebaseFirestore.instance
      .collection('peminjam')
      .where("ref_user_id", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .orderBy("created_at", descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Peminjam.fromJson(doc.data())).toList());

  Widget buildPeminjam(Peminjam peminjam) => ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.person),
      ),
      title: Text(peminjam.nama_peminjam),
      subtitle: Text(FormatMataUang.convertToIdr(peminjam.total, 2)),
      // Text(data['total'].toString()),
      trailing: SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await deleteData(peminjam);
              },
            ),
          ],
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Peminjam>>(
        stream: readPeminjams(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData) {
            final peminjams = snapshot.data!;
            return ListView.builder(
              itemCount: peminjams.length,
              itemBuilder: (context, index) =>
                  buildListItemPeminjam(context, peminjams[index]),
            );
            // children: peminjams.map(buildPeminjam).toList(),
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget buildListItemPeminjam(BuildContext context, Peminjam peminjam) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailPage(peminjam: peminjam)),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.person),
        ),
        title: Text(peminjam.nama_peminjam),
        subtitle: Text(FormatMataUang.convertToIdr(peminjam.total, 2)),
        // Text(data['total'].toString()),
        trailing: SizedBox(
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await deleteData(peminjam);
                },
              ),
            ],
          ),
        )),
    );
  }

  Future<void> deleteData(Peminjam peminjam) async {
    await FirebaseFirestore.instance
        .collection('peminjam')
        .doc(peminjam.id)
        .delete();

    // Show a snackbar
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Berhasil Menghapus Data')));
  }
}
